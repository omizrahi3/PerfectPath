//
//  NewPathGeneratedControllerView.swift
//  PerfectPath
//
//  Created by Kasey Clark on 3/2/17.
//  Copyright © 2017 PerfectPath. All rights reserved.
//

import UIKit
import MapKit
import WatchConnectivity


class NewPathGeneratedControllerView: UIViewController, MKMapViewDelegate, WCSessionDelegate {
    var pathInformation: [String : Any?] = [:]
    var waypoints = [MKMapItem]()
    let numWaypoints = 3
    var path : Path?
    var activityIndicator: UIActivityIndicatorView?
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var distanceLabel: UILabel!        
    @IBOutlet weak var guardianEnabledLabel: UILabel!
    
    //for watch communication
    var lastMessage: CFAbsoluteTime = 0
    
    
    
    
    
    //load view of route and metrics
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        addActivityIndicator()
        waypoints.append(MKMapItem(placemark: MKPlacemark(placemark: (path?.startingLocation)!)))
        let prefferedDistanceMeters = path?.prefferedDistanceMeters
        let waypointDistance = prefferedDistanceMeters! / Double(numWaypoints+1)
        let initialBearing = Double(arc4random_uniform(360))
        findPath(index: 1, initialBearing: initialBearing, waypointDistance: waypointDistance)
        addGuardianLabel()
    }
    //############################## CODE FOR WATCH COMMUNICATION #################################
//    // Start the path on the watch
//    @IBAction func didTapStartPathOnWatch(_ sender: Any) {
//        print("Entering didTapStartPathOnWatch...")
//        
//   
//        if WCSession.isSupported() {
//            let watchSession = WCSession.default()
//            watchSession.delegate = self
//            watchSession.activate()
//            if watchSession.isPaired && watchSession.isWatchAppInstalled {
//                do {
//                    try watchSession.updateApplicationContext(["foo": "bar"])
//                } catch let error as NSError {
//                    print(error.description)
//                }
//            }
//        }
//        
//        self.sendWatchMessage(msg: "Hello")
//        
//    } //end didTapStartPathOnWatch
//    
//    
//    
//    
//    func sendWatchMessage(msg: String) {
//        let currentTime = CFAbsoluteTimeGetCurrent()
//        
//        // if less than half a second has passed, bail out
//        if lastMessage + 0.5 > currentTime {
//            return
//        }
//        
//        // send a message to the watch if it's reachable
//        if (WCSession.default().isReachable) {
//            // this is a meaningless message, but it's enough for our purposes
//            let message = ["Message": msg]
//            WCSession.default().sendMessage(message, replyHandler: nil)
//        }
//        
//        // update our rate limiting property
//        lastMessage = CFAbsoluteTimeGetCurrent()
//    }
    
    
    
    
    //##############################################################################################
    func findPath(index: Int, initialBearing: Double, waypointDistance: Double) {
        let lastMKPoint = waypoints[index-1]
        let lastCoords = lastMKPoint.placemark.coordinate
        let bearing = (initialBearing + (90 * (Double(index)-1))).truncatingRemainder(dividingBy: 360)
        let newCoords = locationWithBearing(bearing: bearing, distanceMeters: waypointDistance, origin: lastCoords)
        let newPoint = CLLocation(latitude: newCoords.latitude, longitude: newCoords.longitude)
        CLGeocoder().reverseGeocodeLocation(newPoint, completionHandler: {(placemarks: [CLPlacemark]?, error: Error?) -> Void in
            if let placemarks = placemarks {
                let mapItem = MKMapItem(placemark: MKPlacemark(placemark: placemarks.last!))
                self.waypoints.append(mapItem)
                //print("point resolved, signaling semaphore")
                //semaphore.signal()
                //print("point resolved, semaphore signaleds")
                if index < self.numWaypoints {
                    self.findPath(index: index + 1, initialBearing: initialBearing, waypointDistance: waypointDistance)
                } else {
                    self.calculateSegmentDirections(index: 0, time: 0, routes: [])
                }
            } else if let _ = error {
                print("Error: \(error)")
            }
        })
    }
    
    func calculateSegmentDirections(index: Int, time: TimeInterval, routes: [MKRoute]) {
        let request: MKDirectionsRequest = MKDirectionsRequest()
        if index < waypoints.count-1 {
            request.source = waypoints[index]
            request.destination = waypoints[index + 1]
            request.transportType = .walking
        } else {
            request.source = waypoints[index]
            request.destination = waypoints[0]
            request.transportType = .walking
        }
        let directions = MKDirections(request: request)
        directions.calculate(completionHandler: {(response: MKDirectionsResponse?, error: Error?) in
            if let routeResponse = response?.routes {
                let routeForSegment: MKRoute = routeResponse.sorted(by: {$0.expectedTravelTime < $1.expectedTravelTime})[0]
                var timeVar = time
                var routeVar = routes
                routeVar.append(routeForSegment)
                timeVar += routeForSegment.expectedTravelTime
                if index + 1 < self.waypoints.count {
                    self.calculateSegmentDirections(index: index+1, time: timeVar, routes: routeVar)
                } else {
                    self.hideActivityIndicator()
                    self.path?.routes = routeVar 
                    self.showRoute(routes: routeVar)
                    var distance = 0.0
                    for i in 0..<routes.count {
                        let temp = routeVar[i]
                        distance += temp.distance
                    }
                    distance = distance/1609.34
                    self.path?.actualDistance = distance
                    let distString = String(format: "%.1f",distance)
                    self.distanceLabel.text = "Distance: \(distString) mi"
                }
            } else if let _ = error {
                let alert = UIAlertController(title: nil, message: "Directions not available.", preferredStyle: .alert)
                let okButton = UIAlertAction(title: "OK", style: .cancel) {(alert) -> Void in
                    self.navigationController?.popViewController(animated: true)
                }
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
        })
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
    
    func locationWithBearing(bearing: Double, distanceMeters:Double, origin: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        let distRadians = distanceMeters / (6372797.6) //earth radius in meters
        let lat1 = origin.latitude * M_PI / 180
        let lon1 = origin.longitude * M_PI / 180
        
        let lat2 = asin(sin(lat1) * cos(distRadians) + cos(lat1) * sin(distRadians) * cos(bearing))
        let lon2 = lon1 + atan2(sin(bearing) * sin(distRadians) * cos(lat1), cos(distRadians) - sin(lat1) * sin(lat2))
        
        return CLLocationCoordinate2D(latitude: lat2 * 180 / M_PI, longitude: lon2 * 180 / M_PI)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    @IBAction func generateNewPath() {
        waypoints.removeAll()
        mapView.removeOverlays(mapView.overlays)
        addActivityIndicator()
        waypoints.append(MKMapItem(placemark: MKPlacemark(placemark: (path?.startingLocation)!)))
        let prefferedDistanceMeters = path?.prefferedDistanceMeters
        let waypointDistance = prefferedDistanceMeters! / Double(numWaypoints+1)
        let initialBearing = Double(arc4random_uniform(360))
        findPath(index: 1, initialBearing: initialBearing, waypointDistance: waypointDistance)
    }
    
    func addActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(frame: UIScreen.main.bounds)
        activityIndicator?.activityIndicatorViewStyle = .whiteLarge
        activityIndicator?.backgroundColor = UIColor.darkGray
        activityIndicator?.startAnimating()
        view.addSubview(activityIndicator!)
    }
    
    func hideActivityIndicator() {
        if activityIndicator != nil {
            activityIndicator?.removeFromSuperview()
            activityIndicator = nil
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destViewController : PathNavigationViewController = segue.destination as! PathNavigationViewController
        //destViewController.pathInformation = pathInformation
        destViewController.path = path
    }
    
    func addGuardianLabel() {
        if (path?.guardianPathEnabled)! {
            guardianEnabledLabel.text = "Guardian Enabled: Yes"
        } else {
            guardianEnabledLabel.text = "Guardian Enabled: No"
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    // Below methods are required to conform to protocol WCSessionDelegate
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    
    

}
