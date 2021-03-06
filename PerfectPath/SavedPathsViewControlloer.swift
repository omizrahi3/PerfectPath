//
//  SavedPathsViewControlloer.swift
//  PerfectPath
//
//  Created by Kasey Clark on 3/2/17.
//  Copyright © 2017 PerfectPath. All rights reserved.
//

import UIKit
import Material
import CoreData
import CoreLocation
import MapKit
import WatchConnectivity

class SavedPathsViewControlloer: UIViewController, UITableViewDelegate, UITableViewDataSource {
    fileprivate var logoutButton: IconButton!
    @IBOutlet weak var tableView: UITableView!
    var tableItems = [String]()
    var locations = [SavedPath]()
    var path : Path?
    var pathToSendToWatch: SavedPath?
    let appDelegateRef = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var selectPathButton: UIButton!
    @IBOutlet weak var startPathOnWatchBtn: UIButton!
    
    override func viewDidLoad() {
        loadPaths()
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        prepareLogoutButton()
        prepareNavigationItem()
    }
    @IBAction func didTapSelectSavedPath(_ sender: Any) {
        print("Entering didTapSelectSavedPath...")
            if WCSession.default().isReachable == true {
                print("Session is reachable on iOS")
                let requestValues = ["command" : "startPathNow","data" : "pathString" as Any]
                let session = WCSession.default()
                session.sendMessage(requestValues, replyHandler: { (reply) -> Void in
                    print("sent command: " + String(describing: requestValues["command"]))
                    print("rec data: " + String(describing: reply["data"]))
                }, errorHandler: { error in
                    print("error: \(error)")
                })
                
            }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapStartPathWatch(_ sender: Any) {
        print("Entering didTapStartPathWatch...")
            if WCSession.default().isReachable == true {
                print("Session is reachable on iOS")
                let requestValues = ["command" : "startPathNow","data" : "pathString" as Any]
                let session = WCSession.default()
                session.sendMessage(requestValues, replyHandler: { (reply) -> Void in
                    print("sent command: " + String(describing: requestValues["command"]))
                    print("rec data: " + String(describing: reply["data"]))
                }, errorHandler: { error in
                    print("error: \(error)")
                })
        
            }
    }
    
    
    func loadPaths() {
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        let request :NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "SavedPath")
        request.returnsObjectsAsFaults = false
        do{
            let results:NSArray = try context.fetch(request) as NSArray
            if (results.count > 0) {
                for result in results {
                    let startingLocation = (result as! SavedPath).startingLocation as! CLPlacemark
                    let distance = (((result as! SavedPath).distanceInMiles*100).rounded())/100
                    let tableLabel = "\(distance) miles : \(startingLocation.name!)"
                    tableItems.append(tableLabel)
                    //tableItems.append(String(describing: startingLocation.name!))
                    locations.append(result as! SavedPath)
                    appDelegateRef.favPathNames.append(tableLabel)
                }
            }
        } catch {
            print(error)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = self.tableItems[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.row)!")
        let savedPath = (locations[indexPath.row])
        self.pathToSendToWatch = savedPath
        path = Path()
        path?.startingLocation = savedPath.startingLocation as? CLPlacemark
        path?.actualDistance = savedPath.distanceInMiles
        var mapItemWaypoints = [MKMapItem]()
        for item in savedPath.spwaypoints! {
            let waypoint = item as! SPWaypoint
            let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(waypoint.latitude, waypoint.longitude)
            let addrDic : [String:Any]? = waypoint.addressDictionary as? [String : Any]
            let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addrDic)
            mapItemWaypoints.append(MKMapItem(placemark: placemark))
        }
        path?.mapItemWaypoints = mapItemWaypoints
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destViewController : PathNavigationViewController = segue.destination as! PathNavigationViewController
        destViewController.path = path
        destViewController.comingFromFavoritePath = 1
    }
    

}

extension SavedPathsViewControlloer {
    fileprivate func prepareLogoutButton() {
        logoutButton = IconButton(image: Icon.cm.close)
        logoutButton.addTarget(appDelegate,
                               action: #selector(AppDelegate.handleLogout),
                               for: .touchUpInside)
    }
    
    fileprivate func prepareNavigationItem() {
        navigationItem.title = "PerfectPath"
        navigationItem.detail = "Saved Paths"
        navigationItem.rightViews = [logoutButton]
    }
}
