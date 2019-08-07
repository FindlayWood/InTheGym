//
//  PlayerInfoViewController.swift
//  InTheGym
//
//  Created by Findlay Wood on 30/07/2019.
//  Copyright © 2019 FindlayWood. All rights reserved.
//

import UIKit
import Firebase

class PlayerInfoViewController: UIViewController {
    
    var username:String = ""
    var adminKey:String = ""
    var gotArequest:Bool = false
    var requesters = [String]()
    var requestKeys = [String]()
    
    var DBRef:DatabaseReference!
    
    let userID = Auth.auth().currentUser?.uid
    
    @IBOutlet weak var nameLabel:UILabel!
    @IBOutlet weak var usernameLabel:UILabel!
    @IBOutlet weak var emailLabel:UILabel!
    @IBOutlet weak var coachNameLabel:UILabel!
    @IBOutlet weak var coachUsernameLabel:UILabel!
    @IBOutlet weak var coachEmailLabel:UILabel!
    @IBOutlet weak var countedLabel:UILabel!
    @IBOutlet weak var acceptRequestButton:UIButton!

    
    @IBAction func viewPBs(_ sender:UIButton){
        sender.pulsate()
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        let SVC = Storyboard.instantiateViewController(withIdentifier: "PBsViewController") as! PBsViewController
        SVC.username = self.username
        self.navigationController?.pushViewController(SVC, animated: true)
    }
    
    @IBAction func viewRequests(_ sender:UIButton){
        sender.pulsate()
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        let SVC = Storyboard.instantiateViewController(withIdentifier: "RequestsViewController") as! RequestsViewController
        SVC.requesters = self.requesters
        SVC.requestKeys = self.requestKeys
        SVC.username = self.username
        self.navigationController?.pushViewController(SVC, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DBRef = Database.database().reference()
        
        self.username = PlayerActivityViewController.username
        self.usernameLabel.text = "@\(PlayerActivityViewController.username ?? "@username")"
        //self.acceptRequestButton.isHidden = true
        
    }
    
    func requests(){
        self.requesters.removeAll()
        self.requestKeys.removeAll()
        var requestCount = 0
        self.DBRef.child("users").observe(.childAdded, with: { (snapshot) in
            if let snap = snapshot.value as? [String:Any]{
                if snap["admin"] as! Bool == true{
                    if let playerSnap = snap["players"] as? [String:Any]{
                        if let requests = playerSnap["requested"] as? [String]{
                            if requests.contains(self.username){
                                requestCount = requestCount + 1
                                let coach = snap["username"] as! String
                                self.requesters.append(coach)
                                self.requestKeys.append(snapshot.key)
                                //self.adminLabel.text = "you have \(requestCount) new requests"
                                //self.acceptRequestButton.isHidden = false
                            }
                            else{
                                //self.adminLabel.text = "You don't have any new requests."
                               //self.acceptRequestButton.isHidden = true
                            }
                        }
                        else{
                            //self.adminLabel.text = "You don't have any new requests."
                            //self.acceptRequestButton.isHidden = true
                        }
                    }
                }
            }
        }, withCancel: nil)
    }
    
    func loadUserInfo(){
        var coachName:String!
        self.DBRef.child("users").child(userID!).observe(.value) { (snapshot) in
            if let snap = snapshot.value as? [String:Any]{
                let first = snap["firstName"] as? String ?? "FIRST"
                let last = snap["lastName"] as? String ?? "LAST"
                self.nameLabel.text = "\(first) \(last)"
                self.emailLabel.text = snap["email"] as? String
                let counted = snap["numberOfCompletes"] as? Int
                self.countedLabel.text = "\(counted ?? 0)"
                coachName = snap["coachName"] as? String ?? ""
                //self.coachUsernameLabel.text = "@\(coachName!)"
            }
        }
        
        self.DBRef.child("users").observe(.childAdded, with: { (snapshot) in
            if let snap = snapshot.value as? [String:Any]{
                let x = snap["username"] as! String
                if (x.contains(coachName)){
                    self.adminKey = snapshot.key
                    self.DBRef.child("users").child(self.adminKey).observe(.value, with: { (snapshot) in
                        if let snap = snapshot.value as? [String:Any]{
                            let first = snap["firstName"] as? String ?? "First"
                            let last = snap["lastName"] as? String ?? "Last"
                            self.coachNameLabel.text = "\(first) \(last)"
                            let username = snap["username"] as? String
                            self.coachUsernameLabel.text = "@\(username ?? "")"
                            self.coachEmailLabel.text = snap["email"] as? String
                        }
                    }, withCancel: nil)
                }
            }
        }, withCancel: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadUserInfo()
        requests()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }


}
