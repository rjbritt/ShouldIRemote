//
//  ViewController.swift
//  ShouldIRemote
//
//  Created by Ryan Britt on 8/28/15.
//  Copyright (c) 2015 Irrational Midnight Avengers. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    @IBOutlet weak var homeMapView: MKMapView!
    @IBOutlet weak var workMapView: MKMapView!
    
    @IBOutlet weak var homeAddress: UITextField!
    @IBOutlet weak var workAddress: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func homeAddressEntered(sender: AnyObject) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(homeAddress.text, completionHandler: { (placemarks, error) -> Void in
            if let placemarks = placemarks {
                let topResult = placemarks[0] as! CLPlacemark
                let placeMark = MKPlacemark(placemark: topResult)
                var region = self.homeMapView.region
                
                region.center = (placeMark.region as! CLCircularRegion).center
                region.span.longitudeDelta /= 50.0
                region.span.latitudeDelta /= 50.0
                
                self.homeMapView.setRegion(region, animated: true)
                self.homeMapView.addAnnotation(placeMark)
                
            
                
            }
            
        })
        
    }

    @IBAction func workAddressEntered(sender: AnyObject) {
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(workAddress.text, completionHandler: { (placemarks, error) -> Void in
            if let placemarks = placemarks {
                let topResult = placemarks[0] as! CLPlacemark
                let placeMark = MKPlacemark(placemark: topResult)
                var region = self.workMapView.region
                
                region.center = (placeMark.region as! CLCircularRegion).center
                region.span.longitudeDelta /= 50.0
                region.span.latitudeDelta /= 50.0
                
                self.workMapView.setRegion(region, animated: true)
                self.workMapView.addAnnotation(placeMark)
                
                
                
            }
            
        })
    }
}

//
//CLGeocoder *geocoder = [[CLGeocoder alloc] init];
//[geocoder geocodeAddressString:location
//completionHandler:^(NSArray* placemarks, NSError* error){
//if (placemarks && placemarks.count > 0) {
//CLPlacemark *topResult = [placemarks objectAtIndex:0];
//MKPlacemark *placemark = [[MKPlacemark alloc] initWithPlacemark:topResult];
//
//MKCoordinateRegion region = self.mapView.region;
//region.center = placemark.region.center;
//region.span.longitudeDelta /= 8.0;
//region.span.latitudeDelta /= 8.0;
//
//[self.mapView setRegion:region animated:YES];
//[self.mapView addAnnotation:placemark];
//}
//}
//];