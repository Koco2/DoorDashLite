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
    
    public var userLocation:CLLocation!{
        didSet{
            getHumanReadableAddress()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        determineCurrentLocation()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        UI_SetUp()
    }
    
}





// MARK: - Location manager
extension ChooseAnAddressController: CLLocationManagerDelegate{
    
    private func determineCurrentLocation(){
        //TODO:Set up the location manager here.
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        //manager.stopUpdatingLocation()
        
        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        map.setRegion(region, animated: true)
        
        // Drop a pin at user's Current Location
        let myAnnotation: MKPointAnnotation = MKPointAnnotation()
        myAnnotation.coordinate = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude);
        myAnnotation.title = "Current location"
        map.addAnnotation(myAnnotation)
    }
    
    private func locationManager(manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    
    private func getHumanReadableAddress(){
        geocoder = CLGeocoder()
        // Create Location
        
        
        let location = CLLocation(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        
        
        
        
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





// MARK: - Views
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
    
    
    //add all UI components for the UIViewController
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
        confirmButton.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
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
    @objc private func buttonClicked(){
        
        
        let tabBarController = TabBarController()
        tabBarController.lat = userLocation.coordinate.latitude
        tabBarController.lng = userLocation.coordinate.longitude
        
        
        self.navigationController?.pushViewController(tabBarController, animated: true)
    }
}
