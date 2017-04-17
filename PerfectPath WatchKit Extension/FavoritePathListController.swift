//
//  FavoritePathListController.swift
//  PerfectPath
//
//  Created by Kasey Clark on 3/2/17.
//  Copyright © 2017 PerfectPath. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class FavoritePathListController: WKInterfaceController {
    
    
    @IBOutlet var favPathsTable: WKInterfaceTable!

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        self.getFavPathsFromPhone()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func getFavPathsFromPhone() {
        print("Entering getFavPathsFromPhone in FavoritePathListController...")
        if WCSession.default().isReachable == true {
            print("Session is reachable on watch")
            // request from watch looks like ["command" : "favPathsList"]
            // reply from ios looks like ["command" : "favPathsList","favPaths" : favPathArray as Any, "favPathNames": favPathNames as [String]]
            let requestValues = ["command" : "favPathsList"]
            let session = WCSession.default()
            session.sendMessage(requestValues, replyHandler: { (reply) -> Void in
                
                // TODO ADD IN WHEN SENDING PATHS TO WATCH
                //var favPathArray = [WatchPath]()
                //favPathArray = ((reply["favPaths"] as AnyObject) as! [WatchPath])
                var favPathNames = [String]()
                favPathNames = (reply["favPathNames"] as AnyObject) as! [String]
                print("length of favPathNames is " + String(favPathNames.count) + "with the first entry being " + String(favPathNames[0]))
                self.favPathsTable.setNumberOfRows(favPathNames.count, withRowType: "FavPathRowControllerIdentifier")
                for (index, name) in favPathNames.enumerated() {
                    let row = self.favPathsTable.rowController(at: index) as! FavPathRowController
                    row.pathName.setText(name)
                }
                print("# favPaths: " + String(favPathNames.count))
            }, errorHandler: { error in
                print("error: \(error)")
            })
        }
    }

}
