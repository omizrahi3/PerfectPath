//
//  PathCompletedViewController.swift
//  PerfectPath
//
//  Created by Rachel Martin on 3/28/17.
//  Copyright © 2017 PerfectPath. All rights reserved.
//

import Foundation
import UIKit

class PathCompletedViewController: UIViewController {
    

    @IBOutlet weak var savePathButton: UIButton!
    var path: Path?
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.changeLabels()
    }
    
    //compute and display route summary
    func changeLabels() {
        var distanceInMiles = 0.0
        if let metersTraveled = path?.metersTraveled! {
            distanceInMiles = metersTraveled/1609
            let distanceRounded = ((distanceInMiles)*100).rounded()/100
            distanceLabel.text = "Distance: " + String(describing: distanceRounded) + "mi"
        }
        if let seconds = path?.secondsTraveled! {
                timeLabel.text = "Time: " + String(describing: seconds) + "sec"
                let speed = (((distanceInMiles*60*60)/Double(seconds))*10).rounded()/10
                speedLabel.text = "Speed: " + String(describing: speed) + "mph"
        }
    }
    
    //TODO: Save path
    @IBAction func savePathClicked(_ sender: Any) {
        print("save path button clicked")
    }
    
    
    
}
