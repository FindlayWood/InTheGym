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
    
    var DBRef:DatabaseReference!
    
    
    @IBOutlet weak var tableview:UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Requests"
        navigationController?.setNavigationBarHidden(false, animated: true)
        tableview.rowHeight = 120
        
        DBRef = Database.database().reference().child("users")
        
        

        // Do any additional setup after loading the view.
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
        let adminID = requestKeys[sender.tag]
        let userID = Auth.auth().currentUser?.uid
        
        DBRef.child(adminID).child("players").child("requested").observeSingleEvent(of: .value) { (snapshot) in
            let snap = snapshot.value as? [String]
            self.currentRequested = snap!
            let index = self.currentRequested.firstIndex(of: self.username)
            self.currentRequested.remove(at: index!)
            self.DBRef.child(adminID).child("players").child("requested").setValue(self.currentRequested)
            let coachName = self.requesters[sender.tag]
            self.DBRef.child(userID!).child("coachName").setValue(coachName)
            self.requesters.remove(at: sender.tag)
            self.requestKeys.remove(at: sender.tag)
            self.tableview.reloadData()
            //self.navigationController?.popViewController(animated: true)
        }
        
        DBRef.child(adminID).child("players").child("accepted").observeSingleEvent(of: .value) { (snapshot) in
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
    }
    
    @objc func declinePressed(_ sender:UIButton){
        let adminID = requestKeys[sender.tag]
        
        DBRef.child(adminID).child("players").child("requested").observeSingleEvent(of: .value) { (snapshot) in
            let snap = snapshot.value as? [String]
            self.currentRequested = snap!
            let index = self.currentRequested.firstIndex(of: self.username)
            self.currentRequested.remove(at: index!)
            self.DBRef.child(adminID).child("players").child("requested").setValue(self.currentRequested)
            self.requesters.remove(at: sender.tag)
            self.requestKeys.remove(at: sender.tag)
            self.tableview.reloadData()
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
