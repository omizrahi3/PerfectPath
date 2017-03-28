//
//  SetCheckInViewController.swift
//  PerfectPath
//
//  Created by Kasey Clark on 3/26/17.
//  Copyright © 2017 PerfectPath. All rights reserved.
//
import UIKit
import Material

class SetCheckInViewController: UIViewController {


    // variables
    @IBOutlet weak var minutesLabel: UILabel!
    @IBOutlet weak var minutesValueLabel: UILabel!
    var minutes : Int = 5
    var guardianInfo: [String : Any?] = [:]
    var guardianStarted: Bool = false
    var pathInformation: [String : Any?] = [:]
    
    @IBAction func didTapCheckInBtn(_ sender: Any) {
        // mark guardianStarted with true
        print("guardianStarted is now set to true")
        self.guardianStarted = true;
        
        // go to PathNavigationViewController screen
        
        //performSegue(withIdentifier: "SetGuardian", sender: nil)
        
    }
    

    @IBAction func stepperChanged(_ sender: UIStepper) {
        minutes = Int(sender.value)
        minutesValueLabel.text = String(minutes)
        print("stepperChanged, setting minutes to " + String(minutes))
        
    }
    
    //pass json to next page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guardianInfo["Guardian Started"] = guardianStarted
        guardianInfo["Minutes"] = minutes
                let destViewController : PathNavigationViewController = segue.destination as! PathNavigationViewController
        destViewController.guardianInfo = guardianInfo
        destViewController.pathInformation = pathInformation
    }

}
