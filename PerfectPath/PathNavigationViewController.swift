//
//  PathNavigationViewController.swift
//  PerfectPath
//
//  Created by Rachel Martin on 3/21/17.
//  Copyright © 2017 PerfectPath. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import HealthKit
import MapboxDirections
import MapboxNavigationUI

let directions = Directions(accessToken: "pk.eyJ1IjoibWFpc3VyaWEiLCJhIjoiY2owbXFhMWJ5MDBsbjJ3cGs1ZG05ZjEzZSJ9.vaq-JpInz4YGhYzK1aVCTw")



class PathNavigationViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var guardianBtn: UIButton!
    @IBOutlet weak var paceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var startPauseButton: UIButton!
    @IBOutlet var mapVV: MKMapView!

    
    var returningFromSetCheckInViewController: Int = 0
    
    let testTenSecondBinary = 0b00001010
    let oneMinBinary = 0b00111100
    let fiveMinBinary = 0b100101100
    let tenMinBinary = 0b1001011000
    var guardianInternalTimer = Timer()
    var guardianInfo: [(Int)] = [0,5]
    var guardianBinaryCount = 0b0000
    
    var locationManager: CLLocationManager!
    var locations = [CLLocation]()
    var timer = Timer()
    
    var path : Path?
    var heading : CLLocationDirection?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if (returningFromSetCheckInViewController == 1) {
            start()
        }
        
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.activityType = .fitness
        locationManager.distanceFilter = kCLDistanceFilterNone
        let status = CLLocationManager.authorizationStatus()
        if status == .notDetermined || status == .denied || status == .authorizedWhenInUse {
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
        if (guardianInfo[0] == 1) {
            //change color of btn
            self.guardianBtn.backgroundColor = (UIColor.green)
            self.guardianBinaryCount = testTenSecondBinary
            //start timer
            self.startGuardianTimer()
        }

        
        var arr = [Waypoint]()
        
        for waypoint in (path?.mapItemWaypoints)! {
            arr.append(Waypoint(coordinate: CLLocationCoordinate2D(latitude: waypoint.placemark.coordinate.latitude, longitude: waypoint.placemark.coordinate.longitude), name: "Mapbox"))
        }
        
        
        let options = RouteOptions(waypoints: arr)//, profileIdentifier: .automobileAvoidsTraffic)
        options.includesSteps = true
        
        Directions.shared.calculate(options) { (waypoints, routes, error) in
            guard let route = routes?.first else { return }
            let viewController = NavigationUI.routeViewController(for: route).view
            self.mapVV.addSubview(viewController!)
            
            
            //            self.present(viewController, animated: true, completion: nil)
        }
    }
    
    
    func startGuardianTimer() {
        print("Starting Guardian Timer")
        guardianInternalTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.countDown(guardianInternalTimer:)), userInfo: nil, repeats: true)
    }
    
    func countDown(guardianInternalTimer: Timer) {
        var attemptToPresentPopUp = false

        self.guardianBinaryCount -= 0b0001
        // if the counter reached 16, reset it to 0
        if (self.guardianBinaryCount == 0b0000) {
            print("binaryCount: 0")
            
            //stop timer when it reaches 0
            self.guardianInternalTimer.invalidate()
            
            //set value of button back to light grey 85 RGB and 1.0 alpha
            //self.guardianBtn.backgroundColor = (UIColor(red:0.66, green:0.66, blue:0.66, alpha:1.0))
            self.guardianBtn.backgroundColor = UIColor.darkGray
            if !attemptToPresentPopUp {
                //trigger AlertTimerCountdownController to pop up
                self.performSegue(withIdentifier: "GuardianPopUpViewController", sender: PathNavigationViewController.self)
            }
            attemptToPresentPopUp = true
        }
    }
    


    //For every second that the exercise timer is running, update exercise metrics on path object and labels
    func eachSecond(timer: Timer) {
        path?.secondsTraveled! += 1
        let seconds = Double((path?.secondsTraveled)!)
        let secondsQuantity = HKQuantity(unit: HKUnit.second(), doubleValue: seconds)
        timeLabel.text = "Time: " + secondsQuantity.description
        let distanceInMiles = (path?.metersTraveled)!/1609
        let distanceRounded = ((distanceInMiles)*100).rounded()/100
        let distanceQuantity = HKQuantity(unit: HKUnit.mile(), doubleValue: distanceRounded)
        distanceLabel.text = "Distance: " + distanceQuantity.description
        let speedUnit = HKUnit.mile().unitDivided(by: HKUnit.hour())
        let speed = ((((distanceInMiles*60*60)/seconds)*10).rounded())/10
        let paceQuantity = HKQuantity(unit: speedUnit, doubleValue: speed)
        paceLabel.text = "Speed: " + paceQuantity.description
    }

 
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for location in locations {
            if location.horizontalAccuracy < 20 {
                //update distance
                if self.locations.count > 0 {
                    path?.metersTraveled! += location.distance(from: self.locations.last!)
                }
                //save location
                self.locations.append(location)
            }
        }
    }



    //change button from start -> pause -> resume
    @IBAction func startPauseButtonClicked(_ sender: Any) {
        let buttonName = startPauseButton.titleLabel?.text
        if buttonName == "Start" || buttonName == "Resume" {
            if buttonName == "Start" {
                path?.secondsTraveled = 0; path?.metersTraveled = 0.0
            }
            start()
        } else {
            startPauseButton.setTitle("Resume", for: .normal)
            locationManager.stopUpdatingLocation()
            timer.invalidate()
        }
    }

    /**
     When user clicks start or resume button, start tracking location and exercise timer
     */
    func start() {
        startPauseButton.setTitle("Pause", for: .normal)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.eachSecond(timer:)), userInfo: nil, repeats: true)
        locationManager.startUpdatingLocation()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SetCheckInViewController" {
            let destViewController : SetCheckInViewController = segue.destination as! SetCheckInViewController
            destViewController.guardianInfo = guardianInfo
            destViewController.path = path
            destViewController.locationManager = locationManager
            destViewController.returningFromSetCheckInViewController = returningFromSetCheckInViewController
            if (startPauseButton.titleLabel?.text == "Start" || startPauseButton.titleLabel?.text == "Resume") {
                destViewController.isPaused = true
            } else {
                destViewController.isPaused = false
            }
        }
        if segue.identifier == "GuardianPopUpViewController" {
            let destViewController : GuardianPopUpViewController = segue.destination as! GuardianPopUpViewController
            destViewController.guardianInfo = guardianInfo
            destViewController.path = path
            if (startPauseButton.titleLabel?.text == "Start" || startPauseButton.titleLabel?.text == "Resume") {
                destViewController.isPaused = true
            } else {
                destViewController.isPaused = false
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
