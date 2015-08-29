//
//  SIRMainViewController.swift
//  ShouldIRemote
//
//  Created by Ryan Britt on 8/29/15.
//  Copyright (c) 2015 Irrational Midnight Avengers. All rights reserved.
//

import UIKit
import MapKit

class SIRMainViewController: UIViewController {

    @IBOutlet weak var answer: UILabel!
    @IBOutlet weak var baseLineTime: UILabel!
    @IBOutlet weak var currentTime: UILabel!
    
    var startMark: MKPlacemark?
    var endMark: MKPlacemark?
    
    var homeLat:Double?
    var homeLong:Double?
    var workLat:Double?
    var workLong:Double?
    var homeAddressText:String?
    var workAddressText:String?
    var maximumTimeInTraffic:Int?
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    override func viewWillAppear(animated: Bool) {
//        super.viewDidLoad()
        super.viewWillAppear(animated)
        
         homeLat = userDefaults.objectForKey("homeLatitude") as? Double
         homeLong = userDefaults.objectForKey("homeLongitude") as? Double
         workLat = userDefaults.objectForKey("workLatitude") as? Double
         workLong = userDefaults.objectForKey("workLongitude") as? Double
         homeAddressText = userDefaults.objectForKey("homeAddress") as? String
         workAddressText = userDefaults.objectForKey("workAddress") as? String
        maximumTimeInTraffic = userDefaults.integerForKey("maximumTimeInTraffic")
        
        if let homeLat = homeLat {
            setHomeLocationForLatitude(homeLat, andLongitude: homeLong!)
            if let workLat = workLat {
                setWorkLocationForLatitude(workLat, andLongitude: workLong!)
            }
        }
        getETAToWork(baseLineTime, baseline: true)
        getETAToWork(currentTime, baseline: false)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"setAnswer2:", name: "setAnswerNotif", object: nil)

    }
    
    override func viewWillLayoutSubviews() {
        if homeLong == nil {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            self.presentViewController((storyboard.instantiateViewControllerWithIdentifier("getAddressVC") as? ViewController)!, animated: true, completion: nil)
        }
    }
    
    func setAnswer2(ntf:NSNotification) {
        if((currentTime.text != "Calculating...") && (baseLineTime.text != "Calculating...")) {
            let baseLineTraffic = getNumberFromLabelText(baseLineTime.text!)
            let currentTraffic = getNumberFromLabelText(currentTime.text!)
            
            if(currentTraffic > Double(maximumTimeInTraffic!)) {
                answer.text = "Yes"
                answer.textColor = UIColor(red: 0.1, green: 0.60, blue: 0.10, alpha: 1)
            }
            else {
                answer.text = "No"
                answer.textColor = UIColor(red: 0.8, green: 0.20, blue: 0.20, alpha: 1)
            }
        }
        
    }
    
    func getNumberFromLabelText(text:String) -> Double? {
        return split(text) {$0 == " "}[0].doubleValue
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func setHomeLocationForLatitude(latitude:Double, andLongitude longitude:Double) {
        startMark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), addressDictionary: nil)
    }
    
    func setWorkLocationForLatitude(latitude:Double, andLongitude longitude:Double) {
        endMark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), addressDictionary: nil)
    }
    
    func getETAToWork(labelToSet: UILabel, baseline:Bool) -> Void {
        var directionsRequest = MKDirectionsRequest()
        
        if baseline {
            let today = NSDate()
            let gregorian = NSCalendar(identifier: NSCalendarIdentifierGregorian)
            let components = gregorian!.components(.CalendarUnitMonth | .CalendarUnitDay | .CalendarUnitYear | .HourCalendarUnit, fromDate: today)
            components.day -= 1
            components.hour = 1
            let yesterday = gregorian?.dateFromComponents(components);
            
            directionsRequest.departureDate = yesterday
        }
        
        directionsRequest.setSource(MKMapItem(placemark: startMark))
        directionsRequest.setDestination(MKMapItem(placemark: endMark))
        var directions = MKDirections(request: directionsRequest)
        directions.calculateETAWithCompletionHandler { (response, error) -> Void in
            if let response = response {
                let fmt = NSNumberFormatter()
                fmt.maximumFractionDigits = 2
                labelToSet.text = fmt.stringFromNumber(response.expectedTravelTime / 60.0)! + " minutes"
                NSNotificationCenter.defaultCenter().postNotificationName("setAnswerNotif", object: nil)
            }
            else {
                let alert = UIAlertController(title: "Oops!", message: "You can't drive there.", preferredStyle:UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (alert: UIAlertAction!) in
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    self.presentViewController((storyboard.instantiateViewControllerWithIdentifier("getAddressVC") as? ViewController)!, animated: true, completion: nil)

                    }))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            
            if baseline {
                labelToSet.text! += " in average traffic"
            }
            else {
                labelToSet.text! += " in current traffic"
            }
            
            labelToSet.adjustsFontSizeToFitWidth = true
            
        }
    }

    
    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//        (segue.destinationViewController as? ViewController)
//    }


}

extension String {
    var doubleValue: Double {
        let nf = NSNumberFormatter()
        nf.maximumFractionDigits = 2
        
        if let number = nf.numberFromString(self) {
            return Double(round(100 * number.doubleValue)/100)
        }
        return 0
    }
}