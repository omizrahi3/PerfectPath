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
import Material

class GeneratePathViewController: UIViewController, CLLocationManagerDelegate, UISearchBarDelegate {
    fileprivate var logoutButton: IconButton!
    let manager = CLLocationManager()
    lazy var geocoder = CLGeocoder()
    
    var pathInformation: [String : Any?] = [:]
    var dataString : String = ""
    var startingLocation : CLPlacemark? = nil
    var distance : Double = 0
    var guardianPathEnabled : Bool = true
    var pathType: String = "Bike"
    var path: Path?
    
    //UI elements
    @IBOutlet weak var segmentedControlBikeRun: UISegmentedControl!
    @IBOutlet weak var startingLocationSearchBar: UISearchBar!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var guardianPathGeneratedSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareLogoutButton()
        prepareNavigationItem()
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

    //user clicked "Use current location" for starting location
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
        self.view.endEditing(true)
        geocoder.geocodeAddressString(searchBar.text!, completionHandler: { (placemarks, error) in
            if let _ = error {
                self.startingLocation = nil
                let alert = UIAlertController(title: nil, message: "Location was not found.", preferredStyle: .alert)
                let okButton = UIAlertAction(title: "OK", style: .cancel)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            } else {
                if (placemarks?.count)! > 0 {
                    let placemark = placemarks?.first
                    self.changeSearchBarText(placemark: placemark!)
                } else {
                    print("not found")
                }
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
        startingLocation = placemark
        startingLocationSearchBar.text = "\(street) \(city) \(state) \(zipcode)"
    }
    
    //distance value increased or decreased. Label updated accordingly
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        distanceLabel.text = String(format:"%.2f", sender.value)
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
    
    func searchbarShouldReturn(_ searchBar: UISearchBar) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    //Generate clicked and JSON generated
    @IBAction func didTapGeneratePath(_ sender: Any) {
        let distanceTimesTen: Double = distance*10
        let roundedDistance: Double = round(distanceTimesTen)
        distance = roundedDistance/10
        if startingLocation != nil {
            path = Path(startingLocation: startingLocation!, distanceInMiles: distance, guardianPathEnabled: guardianPathEnabled)
        }
    }

    
    //pass path to next page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        startingLocation = nil
        let destViewController : NewPathGeneratedControllerView = segue.destination as! NewPathGeneratedControllerView
        destViewController.path = path
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {
        if let ident = identifier {
            if ident == "generatePathSegue" {
                print("in should perform segue")
                if distance <= 0 {
                    print("in distance less than 0")
                    let alert = UIAlertController(title: nil, message: "Please enter preferred distance.", preferredStyle: .alert)
                    let okButton = UIAlertAction(title: "OK", style: .cancel)
                    alert.addAction(okButton)
                    self.present(alert, animated: true, completion: nil)
                    return false
                } else if (startingLocation == nil) {
                    let alert = UIAlertController(title: nil, message: "Please enter starting location.", preferredStyle: .alert)
                    let okButton = UIAlertAction(title: "OK", style: .cancel)
                    alert.addAction(okButton)
                    self.present(alert, animated: true, completion: nil)
                    return false
                }
            }
        }
        return true
    }

}

extension GeneratePathViewController {
    fileprivate func prepareLogoutButton() {
        logoutButton = IconButton(image: Icon.cm.close)
        logoutButton.addTarget(appDelegate,
                               action: #selector(AppDelegate.handleLogout),
                               for: .touchUpInside)
    }
    
    fileprivate func prepareNavigationItem() {
        navigationItem.title = "PerfectPath"
        navigationItem.detail = "Generate Path"
        navigationItem.rightViews = [logoutButton]
    }
}
