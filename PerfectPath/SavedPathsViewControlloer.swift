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

class SavedPathsViewControlloer: UIViewController, UITableViewDelegate, UITableViewDataSource {
    fileprivate var logoutButton: IconButton!
    @IBOutlet weak var tableView: UITableView!
    var tableItems = [String]()
    var locations = [SavedPath]()
    var path : Path?
    @IBOutlet weak var selectPathButton: UIButton!
    
    override func viewDidLoad() {
        loadPaths()
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        prepareLogoutButton()
        prepareNavigationItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadPaths() {
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        let request :NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "SavedPath")
        request.returnsObjectsAsFaults = false
        do{
            let results:NSArray = try context.fetch(request) as NSArray
            if (results.count > 0) {
                print("\(results.count) found!")
                for result in results {
                    let startingLocation = (result as! SavedPath).startingLocation as! CLPlacemark
                    tableItems.append(String(describing: startingLocation.name!))
                    locations.append(result as! SavedPath)
                    print(((result as! SavedPath).waypoints?[0] as! Waypoint).longitude as Any)
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
        path = Path()
        path?.startingLocation = savedPath.startingLocation as? CLPlacemark
        var mapItemWaypoints = [MKMapItem]()
        for item in savedPath.waypoints! {
            let waypoint = item as! Waypoint
            let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(waypoint.latitude, waypoint.longitude)
            let addrDic : [String:Any]? = waypoint.addressDictionary as? [String : Any]
            let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addrDic)
            mapItemWaypoints.append(MKMapItem(placemark: placemark))
        }
        path?.mapItemWaypoints = mapItemWaypoints
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destViewController : PathNavigationViewController = segue.destination as! PathNavigationViewController
        //destViewController.guardianInfo = guardianInfo
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
