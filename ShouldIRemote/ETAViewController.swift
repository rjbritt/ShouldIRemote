//
//  ETAViewController.swift
//  ShouldIRemote
//
//  Created by Ryan Britt on 8/28/15.
//  Copyright (c) 2015 Irrational Midnight Avengers. All rights reserved.
//

import UIKit
import MapKit

class ETAViewController: UIViewController {

    var dataVC:ViewController?
    
    @IBOutlet weak var lblTraffic: UILabel!
    @IBOutlet weak var lblNoTraffic: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataVC?.getETAToWork(lblTraffic, baseline: false)
        dataVC?.getETAToWork(lblNoTraffic, baseline: true)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
