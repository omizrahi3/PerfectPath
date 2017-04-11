//
//  GuardianPopUpViewController.swift
//  PerfectPath
//
//  Created by Kasey Clark on 4/5/17.
//  Copyright © 2017 PerfectPath. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import Alamofire

class GuardianPopUpViewController: UIViewController {
    
    var contacts = [Contact]()
    var contactsRef: FIRDatabaseReference!
    var profileRef: FIRDatabaseReference!
    
    var latestRecievedProfile: Profile?
    
    @IBOutlet weak var secondsLabel: UILabel!
    var secondsVal : Int = 60
    
    var path : Path?
    var timer = Timer() //timer for run on path nagivation screen
    var isPaused : Bool = false
    var countdownToAlert = Timer()
    
    var guardianInfo: [(Int)] = [0,5] // contains guardianStarted bool at 0 and minutes at [1]
    var guardianStarted: Int = 0
    var guardianMinutes: Int = 0
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFirebaseObservers()
        if isPaused == false {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.eachSecond(timer:)), userInfo: nil, repeats: true)
        }
        secondsVal = 10
        countdownToAlert = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.countDown(countdownToAlert:)), userInfo: nil, repeats: true)
        
        //update label
    }
    
    func setupFirebaseObservers() {
        let firebaseRef = FIRDatabase.database().reference()
        let currentUsersUid = FIRAuth.auth()!.currentUser!.uid
        contactsRef = firebaseRef.child("contacts").child(currentUsersUid)
        profileRef = firebaseRef.child("profiles").child(currentUsersUid)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        contacts.removeAll()
        
        //TODO Add child to listen child added
        contactsRef.observe(.childAdded, with: { (snapshot) in
            print("childAdded")
            let addedContact = Contact(snapshot: snapshot)
            print(addedContact.getSnapshotValue())
            self.contacts.insert(addedContact, at: 0)
        })
        
        profileRef.observe(.value, with: { (snapshot) in
            self.latestRecievedProfile = Profile(snapshot: snapshot)
        })
    }
    
    //TODO : this should handle the sending of your current location via sms to your emergency contacts
    func sendMessagesToEmergencyContacts() {
        print("TODO : In sendMessagesToEmergencyContacts...")
        for contact in contacts {
            print ("sending message to "+contact.fullname)
            print (contact.phonenumber)
            
            let str1 = "EMERGENCY MESSAGE FROM PERFECT PATH. Please contact your friend "
            let str2 = (self.latestRecievedProfile?.firstname)! + " " + (self.latestRecievedProfile?.lastname)!
            let str3 = " as they did not respond from their Guardian Check in."
            let message = "\(str1) \(str2) \(str3)"
            
            let headers = [
                "Content-Type": "application/x-www-form-urlencoded"
            ]
            
            let parameters: Parameters = [
                "To": contact.phonenumber,
                "Body": message
            ]
            Alamofire.request("https://warm-inlet-35920.herokuapp.com/sms", method: .post, parameters: parameters, headers: headers).response { response in
                print(response)
                
            }
        }
    }
    
    
    
    // TODO : this is called when you cancel the alert after the timer has expired and original message has been sent to emergency contacts -- this message lets ECs know that you are in fact safe.
    func sendImOKMsgToEmergencyContacts() {
        print("TODO : In sendImOKMsgToEmergencyContacts... Alert cancelled after location message sent to Emergency Contacts.")
        
    }
    
    @IBAction func didTapCancelGuardianAlertiOS(_ sender: Any) {
        // stop internal timer
        countdownToAlert.invalidate()
        
        // revert back to the mapcontroller screen
        //self.pushController(withName: "MapController", context: nil)
        
        // if binaryCount negative, means message already send to ECs and then you cancelled so you need to send another message saying im okay false alarm.
        if (secondsVal < 0) {
            // send a message to ECs again saying you're okay
            self.sendImOKMsgToEmergencyContacts()
        }
    }

    
    
    
    func countDown(countdownToAlert: Timer) {
        
        secondsVal -= 1
        // if the counter reached 0, send the text message
        if (secondsVal == 0) {
            print("Timer hit 0")
            sendMessagesToEmergencyContacts()
        }
        if (secondsVal >= 0 ) {
            secondsLabel.text = String(secondsVal)
        }

         
    }
    
    func eachSecond(timer: Timer) {
        path?.secondsTraveled! += 1
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("GuardianPopUpViewController in prepare")
        
        let destViewController : PathNavigationViewController = segue.destination as! PathNavigationViewController
        destViewController.guardianInfo = guardianInfo
        destViewController.path = path
    }

}
