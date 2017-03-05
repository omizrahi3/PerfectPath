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

class GeneratePathViewController: UIViewController, CLLocationManagerDelegate, UISearchBarDelegate {

    let manager = CLLocationManager()
    lazy var geocoder = CLGeocoder()
    
    @IBOutlet weak var startingLocationSearchBar: UISearchBar!
    
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        distanceLabel.text = String(format:"%.1f", sender.value)
    }
    
    @IBAction func useCurrentLocationClicked(_ sender: Any) {
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    private func processResponse( placemarks: [CLPlacemark]? , error: Error?) {
        if let error = error {
            print("Unable to Reverse Geocode Location (\(error))")
        } else {
            if let placemarks = placemarks, let placemark = placemarks.first {
                changeSearchBarText(placemark: placemark)
            } else {
                print("No Matching Addresses Found")
            }
        }
    }
    
    private func changeSearchBarText(placemark: CLPlacemark) {
        let address = placemark.addressDictionary
        let street = address?["Street"] as? String ?? ""
        let city = address?["City"] as? String ?? ""
        let state = address?["State"] as? String ?? ""
        let zipcode = address?["ZIP"] as? String ?? ""
        startingLocationSearchBar.text = "\(street) \(city) \(state) \(zipcode)"
    }
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        geocoder.geocodeAddressString(searchBar.text!, completionHandler: { (placemarks, error) in
            if error != nil {
                print(error)
                return
            }
            if (placemarks?.count)! > 0 {
                let placemark = placemarks?.first
                self.changeSearchBarText(placemark: placemark!)
            } else {
                print("not found")
            }
        })
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
        startingLocationSearchBar.delegate = self
        stepper.autorepeat = true
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
