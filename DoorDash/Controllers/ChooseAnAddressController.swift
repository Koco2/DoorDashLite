//
//  ChooseAnAddressController.swift
//  
//
//  Created by Chen Wang on 4/12/19.
//

import UIKit
import MapKit
import SnapKit
import CoreLocation
import SVProgressHUD

/*
 * Users can select a location by dragging on the map starting at the current location of the user.
 * The address of the location of the pin should show in the text box (addressLabel) above the 'Confirm Address' Button.
 */

class ChooseAnAddressController: UIViewController {

    private var map : MKMapView!
    private var addressLabel: UILabel!
    private var confirmButton: UIButton!
    private var locationManager: CLLocationManager!
    private var geocoder: CLGeocoder!
    private var myAnnotation: MKPointAnnotation = MKPointAnnotation()
    
    public var userLocation:CLLocation!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        determineCurrentLocation()
        UI_SetUp()
        addGesture()
    }
}






// MARK: - Location manager
extension ChooseAnAddressController: CLLocationManagerDelegate{
    
    private func determineCurrentLocation(){
        
        SVProgressHUD.show()
        
        //TODO:Set up the location manager here.
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("updating!!!!--------------")
        
        userLocation = locations[0] as CLLocation
        
        lat = userLocation.coordinate.latitude
        lng = userLocation.coordinate.longitude
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        //manager.stopUpdatingLocation()
        
        let center = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        

        map.setRegion(region, animated: true)
        
        dropPin(lat: lat, lng: lng)
        locationManager.stopUpdatingLocation()
        
        SVProgressHUD.dismiss()
        getHumanReadableAddress()
    }
    
    private func locationManager(manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    
    private func getHumanReadableAddress(){
        geocoder = CLGeocoder()
        // Create Location
        
        
        let location = CLLocation(latitude: lat, longitude: lng)
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            // Process Response
            self.processResponse(withPlacemarks: placemarks, error: error)
        }
    }
    
    private func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        // Update View
        //geocodeButton.isHidden = false
        //activityIndicatorView.stopAnimating()
        
        if let error = error {
            print("Unable to Reverse Geocode Location (\(error))")
            addressLabel.text = "Unable to Find Address for Location"
            
        } else {
            if let placemarks = placemarks, let placemark = placemarks.first {
                addressLabel.text = placemark.name
            } else {
                addressLabel.text = "No Matching Addresses Found"
            }
        }
    }
}





// MARK: - Add Component
extension ChooseAnAddressController{
    
    
    //basic setup
    private func UI_SetUp(){
        //for ViewController
        self.title = "Choose an Address"
        self.view.backgroundColor = UIColor.white
        //for NavigationController
        self.navigationController?.navigationBar.isTranslucent = false
        
        //add UI components
        add_UI_components()
    }
    
    
    //add gesture recognizer
    private func addGesture(){
        
        view.isUserInteractionEnabled = true
        let guesture = UILongPressGestureRecognizer(target: self, action: #selector(longPress(_ :)))
        view.addGestureRecognizer(guesture)
        
        
    }
    
    
    //add all UI components
    private func add_UI_components(){
        addAdressLabel()
        addConfirmButton()
        addMap()
        addLayout()
    }
    
    private func addAdressLabel(){
        addressLabel = UILabel()
        self.view.addSubview(addressLabel)
        addressLabel.backgroundColor = UIColor.white
    }
    
    private func addConfirmButton(){
        confirmButton = UIButton()
        self.view.addSubview(confirmButton)
        
        confirmButton.backgroundColor = UIColor(red: 254/255, green: 26/255, blue: 64/255, alpha: 1)
        confirmButton.setTitle("Confirm Address", for: .normal)
        confirmButton.addTarget(self, action: #selector(goToExplore), for: .touchUpInside)
    }
    
    private func addMap(){
        map = MKMapView()
        self.view.addSubview(map)
        
        //config
        //self.customMapView.userTrackingMode = MKUserTrackingModeFollowWithHeading;
        map.userTrackingMode = MKUserTrackingMode.followWithHeading
        
        
    }
    
    
    //SnapKit layout
    private func addLayout(){
        confirmButton.snp.makeConstraints { (make) in
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(SCREEN_HEIGHT/12)
            make.bottom.equalTo(0)
        }
        
        addressLabel.snp.makeConstraints { (make) in
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(SCREEN_HEIGHT/12)
            make.bottom.equalTo(confirmButton.snp.top)
        }
        
        map.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.width.equalTo(SCREEN_WIDTH)
            make.bottom.equalTo(addressLabel.snp.top)
        }
    }
    
}




// MARK: - for event trigering
extension ChooseAnAddressController{

    //change to restaurantListController
    @objc private func goToExplore(){
        
        
        let tabBarController = TabBarController()
        self.navigationController?.pushViewController(tabBarController, animated: true)
    }
    
    private func dropPin(lat:Double,lng:Double){
        //remove all pins
        let allAnnotations = map.annotations
        map.removeAnnotations(allAnnotations)
        
        //drop a new Pin
        myAnnotation.coordinate = CLLocationCoordinate2DMake(lat, lng);
        map.addAnnotation(myAnnotation)
    }
    
    @objc func longPress(_ sender:UILongPressGestureRecognizer){
        
        if(sender.state == UIGestureRecognizer.State.began)
        {
            let touchLocation = sender.location(in: map)
            let locationCoordinate = map.convert(touchLocation, toCoordinateFrom: map)
            print("Tapped at lat: \(locationCoordinate.latitude) long: \(locationCoordinate.longitude)")
            lat = locationCoordinate.latitude
            lng = locationCoordinate.longitude
            
            
            dropPin(lat: lat, lng: lng)
            getHumanReadableAddress()
        }
        
    }
}
