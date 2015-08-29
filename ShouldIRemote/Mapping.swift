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
    
    public static func GetLocationRegion(address: String) -> (region: CLCircularRegion, placemark: MKPlacemark)
    {
        let geocoder = CLGeocoder()
        var outputRegion = CLCircularRegion()
        var placeMark: MKPlacemark = MKPlacemark()
        geocoder.geocodeAddressString(address, completionHandler: { (placemarks, error) -> Void in
            if let placemarks = placemarks {
                let topResult = placemarks[0] as! CLPlacemark
                placeMark = MKPlacemark(placemark: topResult)
                outputRegion = (placeMark.region as! CLCircularRegion)
            }
        })
        return (outputRegion, placeMark);
    }
    
    public static func SetMapLocation(address: String, mapView: MKMapView!) -> Void {
        var circularRegion = GetLocationRegion(address)
        var region = mapView.region
        region.center = circularRegion.region.center
        region.span.longitudeDelta /= 50.0
        region.span.latitudeDelta /= 50.0
        
        mapView.setRegion(region, animated: true)
        mapView.addAnnotation(circularRegion.placemark)
    }
    
    public static func getAndSetLocation(address: String, mapView: MKMapView!) -> CLLocationCoordinate2D {
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
            }
        })
        return outputRegion.center;
    }
}