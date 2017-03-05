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
import Foundation

class GeneratePathViewController: UIViewController, CLLocationManagerDelegate, UISearchBarDelegate {

    let manager = CLLocationManager()
    lazy var geocoder = CLGeocoder()
    
    //dictionary used to create JSON
    var dictionary: [String : Any?] = [:]
    var dataString : String = ""
    var startingLocation : Any? = ""
    var distance : Double = 0
    var guardianPathEnabled : Bool = true
    var pathType: String = "Bike"
    
    //UI elements
    @IBOutlet weak var segmentedControlBikeRun: UISegmentedControl!
    @IBOutlet weak var startingLocationSearchBar: UISearchBar!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var guardianPathGeneratedSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        startingLocationSearchBar.delegate = self
        stepper.autorepeat = true
    }
    
     //If bike or run is clicked, update pathType for JSON
    @IBAction func bikeOrRunButtons(_ sender: Any) {
        switch segmentedControlBikeRun.selectedSegmentIndex {
        case 0:
            pathType = "Bike";
        case 1:
            pathType = "Run";
        default:
            break
        }
    }

    //user clicked "Use current location" for starting and ending location
    @IBAction func useCurrentLocationClicked(_ sender: Any) {
        manager.startUpdatingLocation()
    }
    
    //Find address for current location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            self.processResponse(placemarks: placemarks, error: error)
            manager.stopUpdatingLocation()
        }
    }
    
    //Find address for given location
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
    
    //verify address that user has searched for
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        geocoder.geocodeAddressString(searchBar.text!, completionHandler: { (placemarks, error) in
            if error != nil {
                print(error as Any)
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
    
    //change search bar text so user can see that address has been found
    private func changeSearchBarText(placemark: CLPlacemark) {
        let address = placemark.addressDictionary
        let street = address?["Street"] as? String ?? ""
        let city = address?["City"] as? String ?? ""
        let state = address?["State"] as? String ?? ""
        let zipcode = address?["ZIP"] as? String ?? ""
        startingLocation = placemark.addressDictionary
        startingLocationSearchBar.text = "\(street) \(city) \(state) \(zipcode)"
    }
    
    //distance value increased or decreased. Label updated accordingly
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        distanceLabel.text = String(format:"%.1f", sender.value)
        distance = sender.value
    }
    
    //Guadrian path enabled switch toggled and value updated for JSON
    @IBAction func changedGuardianPathSwitch(_ sender: Any) {
        if guardianPathGeneratedSwitch.isOn {
            guardianPathEnabled = true
        } else {
            guardianPathEnabled = false
        }
    }
    
    //Generate clicked and JSON generated
    @IBAction func didTapGeneratePath(_ sender: Any) {
        createDictionaryForJSON()
        do {
            let data = try JSONSerialization.data(withJSONObject:dictionary, options:[])
            dataString = String(data: data, encoding: String.Encoding.utf8)!
        } catch {
            print("JSON serialization failed:  \(error)")
        }
    }
    
    private func createDictionaryForJSON() {
        dictionary["Path Type"] = pathType
        dictionary["Starting Location"] = startingLocation
        dictionary["Ending Location"] = startingLocation
        let distanceTimesTen: Double = distance*10
        let roundedDistance: Double = round(distanceTimesTen)
        distance = roundedDistance/10
        dictionary["Distance"] = distance
        dictionary["Guardian Path Enabled"] = guardianPathEnabled
    }
    
    //pass json to next page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destViewController : PathJSONViewController = segue.destination as! PathJSONViewController
        destViewController.jsonLabelText = dataString
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
