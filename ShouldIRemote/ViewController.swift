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
        var out: MKPlacemark? = nil;
        Mapping.getAndSetLocation(self.homeAddress.text, mapView: self.homeMapView, which: Mapping.LocationId.Home)
    }

    @IBAction func workAddressEntered(sender: AnyObject) {
        var out: MKPlacemark? = nil;
        Mapping.getAndSetLocation(self.workAddress.text, mapView: self.workMapView, which: Mapping.LocationId.Work)
    }
    
    
}
