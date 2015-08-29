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
    
    static var blah: MKPlacemark?;
    static var bob: MKPlacemark?;
    
    static func HasBothLocations() -> Bool {
        return blah != nil && bob != nil;
    }
    
   public static func getETAToWork(start: MKPlacemark, end: MKPlacemark) -> NSTimeInterval {
        var directionsRequest = MKDirectionsRequest()
        directionsRequest.setSource(MKMapItem(placemark: start))
        directionsRequest.setDestination(MKMapItem(placemark: end))
        var directions = MKDirections(request: directionsRequest)
        var time: NSTimeInterval? = nil
        directions.calculateETAWithCompletionHandler { (response, error) -> Void in
            time = response.expectedTravelTime
        }
        return time!;
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
                    self.blah = placeMark;
                }
                else if which == LocationId.Work {
                    self.bob = placeMark;
                }
                self.HasBothLocations();
            }
        })
        return outputRegion.center;
    }
    
    public enum LocationId {
        case Home
        case Work
    }
}