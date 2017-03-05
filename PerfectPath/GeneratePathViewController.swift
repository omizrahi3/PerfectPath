//
//  GeneratePathViewController.swift
//  PerfectPath
//
//  Created by Odell Mizrahi on 2/28/17.
//  Copyright © 2017 PerfectPath. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import AddressBookUI

class GeneratePathViewController: UIViewController, CLLocationManagerDelegate {

    let manager = CLLocationManager()
    lazy var geocoder = CLGeocoder()
    
    @IBAction func useCurrentLocationClicked(_ sender: Any) {
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    private func processResponse( placemarks: [CLPlacemark]? , error: Error?) {
        // Update View
        
        if let error = error {
            print("Unable to Reverse Geocode Location (\(error))")
        } else {
            if let placemarks = placemarks, let placemark = placemarks.first {
                print(placemark)
            } else {
                print("No Matching Addresses Found")
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            // Process Response
            self.processResponse(placemarks: placemarks, error: error)
            manager.stopUpdatingLocation()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapGeneratePath(_ sender: Any) {
        print("yay gen path")
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
