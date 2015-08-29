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
    @IBOutlet weak var explanation: UILabel!
    @IBOutlet weak var explanation2: UILabel!
    
    var startMark: MKPlacemark?
    var endMark: MKPlacemark?
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let homeLat = userDefaults.objectForKey("homeLatitude") as? Double
        let homeLong = userDefaults.objectForKey("homeLongitude") as? Double
        let workLat = userDefaults.objectForKey("workLatitude") as? Double
        let workLong = userDefaults.objectForKey("workLongitude") as? Double
        let homeAddressText = userDefaults.objectForKey("homeAddress") as? String
        let workAddressText = userDefaults.objectForKey("workAddress") as? String
        
        if let homeLat = homeLat {
            setHomeLocationForLatitude(homeLat, andLongitude: homeLong!)
            if let workLat = workLat {
                setWorkLocationForLatitude(workLat, andLongitude: workLong!)
            }
        }
        else {
            
        }
        
        getETAToWork(explanation, baseline: false)
        getETAToWork(explanation2, baseline: true)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"setAnswer2:", name: "setAnswerNotif", object: nil)

    }
    
    func setAnswer2(ntf:NSNotification) {
        if((explanation2.text != "Calculating...") && (explanation.text != "Calculating...")) {
            let baseLineTraffic = getNumberFromLabelText(explanation.text!)
            let currentTraffic = getNumberFromLabelText(explanation2.text!)
            
            if(currentTraffic > baseLineTraffic) {
                answer.text = "Yes"
            }
            else {
                answer.text = "No"
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
                labelToSet.text = "Error: \(error.description)"
            }
            
            
        }
    }
    @IBAction func dismissVC(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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