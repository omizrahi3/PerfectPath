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
    var minutes = 5


    @IBAction func stepperChanged(_ sender: UIStepper) {
        minutes = Int(sender.value)
        minutesValueLabel.text = String(minutes)
        
    }

}
