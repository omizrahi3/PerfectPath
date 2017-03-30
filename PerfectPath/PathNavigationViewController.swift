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

class PathNavigationViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var guardianBtn: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var paceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var startPauseButton: UIButton!

    var locationManager: CLLocationManager!
    var locations = [CLLocation]()
    var timer = Timer()
    var guardianInfo: [String : Any?] = [:]
    var path : Path?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //set up location manager to track user
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.activityType = .fitness
        locationManager.distanceFilter = 1.0
        let status = CLLocationManager.authorizationStatus()
        if status == .notDetermined || status == .denied || status == .authorizedWhenInUse {
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
        mapView.delegate = self
        mapView.mapType = MKMapType(rawValue: 0)!
        self.showRoute(routes: (path?.routes)!)
    }
    
    func showRoute(routes: [MKRoute]) {
        for i in 0..<routes.count {
            plotPolyline(route: routes[i])
        }
    }
    
    func plotPolyline(route: MKRoute) {
        mapView.add(route.polyline)
        if mapView.overlays.count == 1 {
            mapView.setVisibleMapRect(route.polyline.boundingMapRect,
                                      edgePadding: UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0), animated: false)
        } else {
            let polylinesBoundingRect = MKMapRectUnion(mapView.visibleMapRect, route.polyline.boundingMapRect)
            mapView.setVisibleMapRect(polylinesBoundingRect, edgePadding: UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0), animated: false)
        }
    }

    
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
    
    override func viewWillAppear(_ animated: Bool) {
        locationManager.requestAlwaysAuthorization()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //timer.invalidate()
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
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer! {
        if (overlay is MKPolyline) {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.blue
            polylineRenderer.lineWidth = 4
            polylineRenderer.lineDashPattern = [5, 10, 5, 10]
            return polylineRenderer
        }
        return nil
    }

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
            mapView.userTrackingMode = MKUserTrackingMode(rawValue: 0)!
            mapView.showsUserLocation = false
            timer.invalidate()
        }
    }
    
    @IBAction func unwindCheckInView(segue: UIStoryboardSegue) {
        if let svc = segue.source as? SetCheckInViewController {
            self.path = svc.path
        }
    }
    
    func start() {
        mapView.showsUserLocation = true
        mapView.userTrackingMode = MKUserTrackingMode(rawValue: 2)!
        startPauseButton.setTitle("Pause", for: .normal)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.eachSecond(timer:)), userInfo: nil, repeats: true)
        locationManager.startUpdatingLocation()
    }

    //TODO is there a way to make guardian view pop up but keep the path nav controller running still so it doesn't have to recalc
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SetCheckInViewController" {
            let destViewController : SetCheckInViewController = segue.destination as! SetCheckInViewController
            destViewController.guardianInfo = guardianInfo
            destViewController.path = path
            if (startPauseButton.titleLabel?.text == "Start" || startPauseButton.titleLabel?.text == "Resume") {
                destViewController.isPaused = true
            } else {
                destViewController.isPaused = false
            }
            print("in PathNavigationViewController in prepare with guardian info: " + (String(describing: destViewController.guardianInfo["Minutes"])))
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
