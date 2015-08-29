//
//  Mapping.swift
//  ShouldIRemote
//
//  Created by Ben Cooley on 8/28/15.
//  Copyright (c) 2015 Irrational Midnight Avengers. All rights reserved.
//

import Foundation
import MapKit
public class Mapping {
    
    static var homeLocation: MKPlacemark?
    static var workLocation: MKPlacemark?

    static var time:NSTimeInterval?
    
    static var hasBothLocations = false
    
    
    
    public static func getETAToWork(start: MKPlacemark, end: MKPlacemark, labelToSet: UILabel) -> Void {
        var directionsRequest = MKDirectionsRequest()
        directionsRequest.setSource(MKMapItem(placemark: start))
        directionsRequest.setDestination(MKMapItem(placemark: end))
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
    public static func getAndSetLocation(address: String, mapView: MKMapView!, which: LocationId) -> CLLocationCoordinate2D {
        let geocoder = CLGeocoder()
        var outputRegion: CLCircularRegion = CLCircularRegion()
        geocoder.geocodeAddressString(address, completionHandler: { (placemarks, error) -> Void in
            if let placemarks = placemarks {
                let topResult = placemarks[0] as! CLPlacemark
                let placeMark = MKPlacemark(placemark: topResult)
                var region = mapView.region
                
                outputRegion = (placeMark.region as! CLCircularRegion)
                region.center = outputRegion.center
                region.span.longitudeDelta /= 50.0
                region.span.latitudeDelta /= 50.0
                
                mapView.setRegion(region, animated: true)
                mapView.addAnnotation(placeMark)
                
                if which == LocationId.Home {
                    self.homeLocation = placeMark;
                }
                else if which == LocationId.Work {
                    self.workLocation = placeMark;
                }
            }
        })
        return outputRegion.center;
    }
    
    public static func setHomeLocationForLatitude(latitude:Double, andLongitude longitude:Double) {
        homeLocation = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), addressDictionary: nil)
    }
   
    public static func setWorkLocationForLatitude(latitude:Double, andLongitude longitude:Double) {
        workLocation = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), addressDictionary: nil)
    }
    
    public enum LocationId {
        case Home
        case Work
    }
}