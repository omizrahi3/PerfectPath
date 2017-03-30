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
    var path : Path?
    var timer = Timer()
    var isPaused : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isPaused == false {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.eachSecond(timer:)), userInfo: nil, repeats: true)
        }
    }
    
    @IBAction func didTapCheckInBtn(_ sender: Any) {
        // mark guardianStarted with true
        print("guardianStarted is now set to true")
        self.guardianStarted = true;
        dismiss(animated: true, completion: nil)
        // go to PathNavigationViewController screen
        
        //performSegue(withIdentifier: "SetGuardian", sender: nil)
    }
    
    func eachSecond(timer: Timer) {
        path?.secondsTraveled! += 1
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
        destViewController.path = path
    }

}
