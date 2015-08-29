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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeAddress.delegate = self
        workAddress.delegate = self
        
        let homeLat = userDefaults.objectForKey("homeLatitude") as? Double
        let homeLong = userDefaults.objectForKey("homeLongitude") as? Double
        let workLat = userDefaults.objectForKey("workLatitude") as? Double
        let workLong = userDefaults.objectForKey("workLongitude") as? Double
        
        if let homeLat = homeLat {
            Mapping.setHomeLocationForLatitude(homeLat, andLongitude: homeLong!)
        }
        
        if let workLat = workLat {
            Mapping.setHomeLocationForLatitude(workLat, andLongitude: workLong!)
        }
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func homeAddressEntered(sender: AnyObject) {
        let info = Mapping.getAndSetLocation(self.homeAddress.text, mapView: self.homeMapView, which: Mapping.LocationId.Home)
        userDefaults.setDouble(info.latitude, forKey: "homeLatitude")
        userDefaults.setDouble(info.longitude, forKey: "homeLongitude")
        
        userDefaults.synchronize()
    }

    @IBAction func workAddressEntered(sender: AnyObject) {
        let info = Mapping.getAndSetLocation(self.workAddress.text, mapView: self.workMapView, which: Mapping.LocationId.Work)
        userDefaults.setDouble(info.latitude, forKey: "workLatitude")
        userDefaults.setDouble(info.longitude, forKey: "workLongitude")
        
        userDefaults.synchronize()

    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationVC = segue.destinationViewController as? ETAViewController
        
        destinationVC?.homeAddress = Mapping.homeLocation;
        destinationVC?.workAddress = Mapping.workLocation;
    }
}
