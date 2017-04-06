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
    var guardianInfo: [(Int)] = [0,5] // contains guardianStarted bool at 0 and minutes at [1]
    var guardianStarted: Int = 0
    var guardianMinutes: Int = 0
    var path : Path?
    var timer = Timer()
    var isPaused : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isPaused == false {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.eachSecond(timer:)), userInfo: nil, repeats: true)
        }
        self.guardianStarted = 0
    }
    
    @IBAction func didTapCheckInBtn(_ sender: Any) {
        // mark guardianStarted with true
        print("guardianStarted is now set to true")
        self.guardianStarted = 1
        self.guardianInfo[0] = self.guardianStarted
        
        dismiss(animated: true, completion: nil)
        // go to PathNavigationViewController screen
//        performSegue(withIdentifier: "PathNavigationViewController", sender: SetCheckInViewController.self)
    }
    
    
    
    
    
    func eachSecond(timer: Timer) {
        path?.secondsTraveled! += 1
    }

    @IBAction func stepperChanged(_ sender: UIStepper) {
        self.guardianMinutes = Int(sender.value)
        self.minutesValueLabel.text = String(self.guardianMinutes)
        guardianInfo[1] = guardianMinutes
        print("stepperChanged, setting minutes to " + String(self.guardianMinutes))
    }
    
    //pass json to next page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("SetCheckInViewController in prepare")
        print("sending guardian started as " + String(self.guardianStarted))
        print("sending guardian minutes as " + String(self.guardianMinutes))
    
        let destViewController : PathNavigationViewController = segue.destination as! PathNavigationViewController
        destViewController.guardianInfo = self.guardianInfo
        destViewController.path = path
    }

}
