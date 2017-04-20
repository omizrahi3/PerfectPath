//
//  MapController.swift
//  PerfectPath
//
//  Created by Kasey Clark on 3/2/17.
//  Copyright © 2017 PerfectPath. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class MapController: WKInterfaceController {
    
    
    //var session: WCSession?
    
    //variables
    @IBOutlet var guardianBtn: WKInterfaceButton!
    var internalTimer = Timer()
    var binaryCount = 0b0000
    let testTenSecondBinary = 0b00001010
    let oneMinBinary = 0b00111100
    let fiveMinBinary = 0b100101100
    let tenMinBinary = 0b1001011000
    var watchPath: WatchPath?
    @IBOutlet var startBtn: WKInterfaceButton!
    @IBOutlet var testLabel: WKInterfaceLabel!
    @IBOutlet var mapObject: WKInterfaceMap!
    
//    var mapLocation: CLLocationCoordinate2D?
//    var coordinateSpan: MKCoordinateSpan!


    // Override to grab information pushed from SetCheckInController
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        print("Entering awake...")
                
        // Make sure data was passed properly from SetCheckInController
        if let _: [Int] = context as? [Int] {
            binaryCount = testTenSecondBinary
            start() // Start the timer here
            self.guardianBtn.setBackgroundColor(UIColor.green)// change the color of the guardian button once it is enabled
        }
    }
    
    override func didAppear() {
        super.didAppear()
        print("Entering didAppear...")
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func start() {
        internalTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(MapController.countDown), userInfo: nil, repeats: true)
    }
    

//    func outlineRouteOnMap() {
//        print("Entering outlineRouteOnMap...")
//        
////        self.mapLocation = CLLocationCoordinate2DMake(33.77, -87.4)
////        if (mapLocation != nil) {
////            print("mapLocation not nil")
////        }
////        
////        let span = MKCoordinateSpanMake(0.1, 0.1)
////        let region = MKCoordinateRegionMake(self.mapLocation!,
////                                            span)
////        self.mapObject.setRegion(region)
////        self.mapObject.addAnnotation(self.mapLocation!, with: .red)
//        
////        TODO left off here becuase code below somewhere is giving nil
//        //CLLocationCoordinate2D mapLocation = CLLocationCoordinate2DMake(watchPath.latitude, watchPath.longitude)
//        //mapLocation = CLLocationCoordinate2DMake(33.77, -87.4)
//        //if (mapLocation != nil) {
//        //    print("mapLocation not nil")
//        //}
//        //coordinateSpan = MKCoordinateSpanMake(1,1)
//        //self.mapObj.addAnnotation(mapLocation, with: .purple)
//        //self.mapObj.setRegion(MKCoordinateRegionMake(mapLocation, coordinateSpan))
//    }
    
    
//    /* SENDING MESSAGE WATCH -> PHONE */
//    // TEST -- NOT IMPORTANT
//    @IBAction func didTapStartBtn() {
//        print("Entering didTapStartBtn...")
//        if WCSession.default().isReachable == true {
//            print("Session is reachable on watch")
//            
//            let requestValues = ["command" : "start"]
//            let session = WCSession.default()
//            
//            session.sendMessage(requestValues, replyHandler: { (reply) -> Void in
//                self.testLabel.setText(reply["data"] as? String)
//                print("sent message: " + String(describing: requestValues["command"]))
//                print("rec message: " + String(describing: reply["data"]))
//            }, errorHandler: { error in
//                print("error: \(error)")
//            })
//        }
//    }
//    
    
    func countDown() {
        
        binaryCount -= 0b0001
        // if the counter reached 16, reset it to 0
        if (binaryCount == 0b0000) {
            print("binaryCount: 0")
            
            //stop timer when it reaches 0
            internalTimer.invalidate()
            
            //set value of button back to light grey 85 RGB and 1.0 alpha
            self.guardianBtn.setBackgroundColor(UIColor(red:0.66, green:0.66, blue:0.66, alpha:1.0))
            
            //trigger AlertTimerCountdownController to pop up
            self.pushController(withName: "AlertTimerCountdownController", context: nil)
        }
    }
}

