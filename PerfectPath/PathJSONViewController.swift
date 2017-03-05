//
//  PathJSONViewController.swift
//  PerfectPath
//
//  Created by Rachel Martin on 3/5/17.
//  Copyright © 2017 PerfectPath. All rights reserved.
//

import Foundation
import UIKit

class PathJSONViewController: UIViewController {
    
    @IBOutlet weak var jsonLabel: UILabel!
    var jsonLabelText = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        jsonLabel.text = jsonLabelText
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
