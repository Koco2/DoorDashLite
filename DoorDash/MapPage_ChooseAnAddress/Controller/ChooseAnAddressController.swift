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
 * Users can select(long press on the map) a location by dragging on the map starting at the current location of the user.
 * The address of the location of the pin should show in the text box (addressLabel) above the 'Confirm Address' Button.
 */

class ChooseAnAddressController: UIViewController {
    
    
    private var locationManager: CLLocationManager!
    private var geocoder: CLGeocoder!
    private var myAnnotation: MKPointAnnotation = MKPointAnnotation()
    public var shareView = ChooseAnAddressView()
    
    //load ExploreView
    override func loadView() {
        view = shareView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        basicSetUp()
        addGesture()
        
        //get lat & lng, then start updating location
        determineCurrentLocation()
        
    }
    
    //basic setup for the controller
    private func basicSetUp(){
        //for ViewController
        self.title = "Choose an Address"
        //for NavigationController
        self.navigationController?.navigationBar.isTranslucent = false
        //link all button actions
        addTargets()
    }
}




// MARK: - for event trigering-------------------------------------------------------------------------------
extension ChooseAnAddressController{
    
    //add gesture recognizer
    private func addGesture(){
        
        view.isUserInteractionEnabled = true
        
        //move location pin to where user long pressed and update AddressLabel's text
        let guesture = UILongPressGestureRecognizer(target: self, action: #selector(longPress(_ :)))
        view.addGestureRecognizer(guesture)
        
    }
    
    //addTargets for all buttons
    private func addTargets(){
        shareView.confirmButton.addTarget(self, action: #selector(goToExplore), for: .touchUpInside)
    }
    
    //change to restaurantListController
    @objc private func goToExplore(){
        
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse{
            showAlert()
        }
        
        let tabBarController = TabBarController()
        self.navigationController?.pushViewController(tabBarController, animated: true)
    }
    
    private func showAlert(){
        let alert = UIAlertController(title: "Need Location Authorization", message: "Please go to your Setting and enable location sharing for DoorDashLite", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    private func dropPin(lat:Double,lng:Double){
        //remove all pins
        let allAnnotations = shareView.map.annotations
        shareView.map.removeAnnotations(allAnnotations)
        
        //drop a new Pin
        myAnnotation.coordinate = CLLocationCoordinate2DMake(lat, lng);
        shareView.map.addAnnotation(myAnnotation)
    }
    
    
    @objc func longPress(_ sender:UILongPressGestureRecognizer){
        
        if(sender.state == UIGestureRecognizer.State.began)
        {
            let touchLocation = sender.location(in: shareView.map)
            let locationCoordinate = shareView.map.convert(touchLocation, toCoordinateFrom: shareView.map)
            print("Tapped at lat: \(locationCoordinate.latitude) long: \(locationCoordinate.longitude)")
            lat = locationCoordinate.latitude
            lng = locationCoordinate.longitude
            
            
            dropPin(lat: lat, lng: lng)
            updateAddressLabel()
        }
        
    }
}





// MARK: - Location related functions --------------------------------------------------------------------------
extension ChooseAnAddressController: CLLocationManagerDelegate{
    
    private func determineCurrentLocation(){
    
        
        //Set up the location manager here.
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        
        //require authorization
        locationManager.requestWhenInUseAuthorization()
    
        
        //update location
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation:CLLocation = locations[0]
        lat = userLocation.coordinate.latitude
        lng = userLocation.coordinate.longitude

        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        //manager.stopUpdatingLocation()
        locationManager.stopUpdatingLocation()
        
        //after updated loaction
        loadMap()
        updateAddressLabel()
        
    }
    
    private func loadMap(){
        // config what is going to be displayed on the map
        let center = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        shareView.map.setRegion(region, animated: true)
        
        //drop a Read pin on User's current location
        dropPin(lat: lat, lng: lng)
    }
    
    
    
    
    private func locationManager(manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    
    private func updateAddressLabel(){
        //get current location
        let location = CLLocation(latitude: lat, longitude: lng)
        
        //cover lat & lng to address
        geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            // Process Response
            self.processResponse(withPlacemarks: placemarks, error: error)
        }
    }
    
    private func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        
        if let error = error {
            print("Unable to Reverse Geocode Location (\(error))")
            shareView.addressLabel.text = "Unable to Find Address for Location"
            
        } else {
            if let placemarks = placemarks, let placemark = placemarks.first {
                shareView.addressLabel.text = placemark.name
            } else {
                shareView.addressLabel.text = "No Matching Addresses Found"
            }
        }
    }
}

