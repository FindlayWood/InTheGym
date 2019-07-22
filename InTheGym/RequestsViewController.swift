//
//  RequestsViewController.swift
//  InTheGym
//
//  Created by Findlay Wood on 13/07/2019.
//  Copyright © 2019 FindlayWood. All rights reserved.
//

import UIKit
import Firebase

class RequestsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var requesters = [String]()
    var username : String = ""
    var requestKeys = [String]()
    var currentRequested = [String]()
    var accepted = [String]()
    var activities : [[String:AnyObject]] = []
    
    var DBRef:DatabaseReference!
    
    
    @IBOutlet weak var tableview:UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Requests"
        navigationController?.setNavigationBarHidden(false, animated: true)
        tableview.rowHeight = 120
        
        DBRef = Database.database().reference().child("users")
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableview.dequeueReusableCell(withIdentifier: "cell") as! RequestTableViewCell
        cell.name.text = requesters[indexPath.row] as String
        cell.acceptButton.tag = indexPath.row
        cell.declineButton.tag = indexPath.row
        cell.acceptButton.addTarget(self, action: "acceptPressed:", for: .touchUpInside)
        cell.declineButton.addTarget(self, action: "declinePressed", for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requesters.count
    }
    
    @objc func acceptPressed(_ sender:UIButton){
        sender.pulsate()
        let adminID = requestKeys[sender.tag]
        let userID = Auth.auth().currentUser?.uid
        
        let alert = UIAlertController(title: "Accept Request", message: "Are you sure you want to accept \(requesters[sender.tag]) as your new Coach?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (UIAlertAction) in
            self.DBRef.child(adminID).child("players").child("requested").observeSingleEvent(of: .value) { (snapshot) in
                let snap = snapshot.value as? [String]
                self.currentRequested = snap!
                let index = self.currentRequested.firstIndex(of: self.username)
                self.currentRequested.remove(at: index!)
                self.DBRef.child(adminID).child("players").child("requested").setValue(self.currentRequested)
                let coachName = self.requesters[sender.tag]
                self.DBRef.child(userID!).child("coachName").setValue(coachName)
                let actData = ["time":ServerValue.timestamp(),
                               "type":"New Coach",
                               "message":"You accepted a request from \(self.requesters[sender.tag])."] as [String:AnyObject]
                self.activities.insert(actData, at: 0)
                self.DBRef.child(userID!).child("activities").setValue(self.activities)
                self.requesters.remove(at: sender.tag)
                self.requestKeys.remove(at: sender.tag)
                self.tableview.reloadData()
                //self.navigationController?.popViewController(animated: true)
            }
            self.DBRef.child(adminID).child("players").child("accepted").observeSingleEvent(of: .value) { (snapshot) in
                if let snap = snapshot.value as? [String]{
                    self.accepted = snap
                    self.accepted.append(self.username)
                    self.DBRef.child(adminID).child("players").child("accepted").setValue(self.accepted)
                }
                else{
                    self.accepted.append(self.username)
                    self.DBRef.child(adminID).child("players").child("accepted").setValue(self.accepted)
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "NO", style: .destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func declinePressed(_ sender:UIButton){
        sender.pulsate()
        let adminID = requestKeys[sender.tag]
        let userID = Auth.auth().currentUser?.uid
        
        DBRef.child(adminID).child("players").child("requested").observeSingleEvent(of: .value) { (snapshot) in
            let snap = snapshot.value as? [String]
            self.currentRequested = snap!
            let index = self.currentRequested.firstIndex(of: self.username)
            self.currentRequested.remove(at: index!)
            self.DBRef.child(adminID).child("players").child("requested").setValue(self.currentRequested)
            let actData = ["time":ServerValue.timestamp(),
                           "type":"Request Declined",
                           "message":"You declined a request from \(self.requesters[sender.tag])"] as [String:AnyObject]
            self.activities.insert(actData, at: 0)
            self.DBRef.child(userID!).child("activities").setValue(self.activities)
            self.requesters.remove(at: sender.tag)
            self.requestKeys.remove(at: sender.tag)
            self.tableview.reloadData()
        }
    }
    
    func loadActivities(){
        let userID = Auth.auth().currentUser?.uid
        DBRef.child(userID!).observe(.childAdded, with: { (snapshot) in
            if let snap = snapshot.value as? [String:AnyObject]{
                self.activities.append(snap)
            }
        }, withCancel: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadActivities()
    }


}
