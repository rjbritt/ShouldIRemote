//
//  ViewController.swift
//  ShouldIRemote
//
//  Created by Ryan Britt on 8/28/15.
//  Copyright (c) 2015 Irrational Midnight Avengers. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var homeMapView: MKMapView!
    @IBOutlet weak var workMapView: MKMapView!
    
    @IBOutlet weak var homeAddress: UITextField!
    @IBOutlet weak var workAddress: UITextField!
    
    let userDefaults = NSUserDefaults.standardUserDefaults()

    var startMark:MKPlacemark?
    var endMark:MKPlacemark?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeAddress.delegate = self
        workAddress.delegate = self

        let homeLat = userDefaults.objectForKey("homeLatitude") as? Double
        let homeLong = userDefaults.objectForKey("homeLongitude") as? Double
        let workLat = userDefaults.objectForKey("workLatitude") as? Double
        let workLong = userDefaults.objectForKey("workLongitude") as? Double
        let homeAddressText = userDefaults.objectForKey("homeAddress") as? String
        let workAddressText = userDefaults.objectForKey("workAddress") as? String

        if let homeLat = homeLat {
            homeAddress.text = homeAddressText
            setHomeLocationForLatitude(homeLat, andLongitude: homeLong!)
        }

        if let workLat = workLat {
            workAddress.text = workAddressText
            setWorkLocationForLatitude(workLat, andLongitude: workLong!)
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func homeAddressEntered(sender: AnyObject) {
        self.userDefaults.setObject(self.homeAddress.text, forKey: "homeAddress")
        getAndSetAddressFromTextField(self.homeAddress, forMapView: self.homeMapView, forLocation:.Home)
        
    }
    
    @IBAction func workAddressEntered(sender: AnyObject) {
        self.userDefaults.setObject(self.workAddress.text, forKey: "workAddress")
        getAndSetAddressFromTextField(self.workAddress, forMapView: self.workMapView, forLocation:.Work)
    }
    
    func getAndSetAddressFromTextField(textField:UITextField ,forMapView mapView:MKMapView,forLocation location:LocationId) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(textField.text, completionHandler: { (placemarks, error) -> Void in
            if let placemarks = placemarks {
                let topResult = placemarks[0] as! CLPlacemark
                let placeMark = MKPlacemark(placemark: topResult)
                var region = mapView.region
                
                region.center = (placeMark.region as! CLCircularRegion).center
                region.span.longitudeDelta /= 50.0
                region.span.latitudeDelta /= 50.0
                
                mapView.setRegion(region, animated: true)
                mapView.addAnnotation(placeMark)
                
                if location == .Home {
                    self.startMark = placeMark
                    self.userDefaults.setDouble(placeMark!.coordinate.latitude, forKey: "homeLatitude")
                    self.userDefaults.setDouble(placeMark!.coordinate.longitude, forKey: "homeLongitude")
                }
                else {
                    self.endMark = placeMark
                    self.userDefaults.setDouble(placeMark!.coordinate.latitude, forKey: "workLatitude")
                    self.userDefaults.setDouble(placeMark!.coordinate.longitude, forKey: "workLongitude")
                }
                self.userDefaults.synchronize()
                
            }
            
        })
    }
    
    func getETAToWork(labelToSet: UILabel) -> Void {
        var directionsRequest = MKDirectionsRequest()
        directionsRequest.setSource(MKMapItem(placemark: startMark))
        directionsRequest.setDestination(MKMapItem(placemark: endMark))
        var directions = MKDirections(request: directionsRequest)
        directions.calculateETAWithCompletionHandler { (response, error) -> Void in
            if let response = response
            {
                labelToSet.text = "\(response.expectedTravelTime / 60.0) minutes"
                
            }
            else {
                labelToSet.text = "Error: \(error.description)"
            }
            
            
        }
    }
    
    enum LocationId {
        case Home
        case Work
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationVC = segue.destinationViewController as? ETAViewController
        destinationVC?.dataVC = self

    }
    
    
    func setHomeLocationForLatitude(latitude:Double, andLongitude longitude:Double) {
        startMark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), addressDictionary: nil)
    }
    
    func setWorkLocationForLatitude(latitude:Double, andLongitude longitude:Double) {
        endMark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), addressDictionary: nil)
    }
    
}