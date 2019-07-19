//
//  HomeViewController.swift
//  InTheGym
//
//  Created by Findlay Wood on 31/05/2019.
//  Copyright © 2019 FindlayWood. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
    
    
    @IBOutlet weak var logoutButton:UIButton!
    
    @IBOutlet weak var welcomeLabel:UILabel!
    @IBOutlet weak var adminLabel:UILabel!
    @IBOutlet weak var acceptRequestButton:UIButton!
    @IBOutlet weak var coachName:UILabel!
    
    var username:String = ""
    var adminKey:String = ""
    var gotARequest:Bool = false
    var requesters = [String]()
    var requestKeys = [String]()
    
    var DBref:DatabaseReference!
    
    @IBAction func logout(_ sender:Any){
        let alert = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (UIAlertAction) in
            do{
                try Auth.auth().signOut()
            }
            catch let signOutError as NSError{
                print("Error signing out: %@", signOutError)
            }
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let initial = storyboard.instantiateInitialViewController()
            UIApplication.shared.keyWindow?.rootViewController = initial
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func viewWorkouts(_ sender:Any){
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        let SVC = Storyboard.instantiateViewController(withIdentifier: "ViewWorkoutViewController") as! ViewWorkoutViewController
        SVC.username = self.username
        self.navigationController?.pushViewController(SVC, animated: true)
        
    }
    
    @IBAction func viewPBs(_ sender:Any){
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        let SVC = Storyboard.instantiateViewController(withIdentifier: "PBsViewController") as! PBsViewController
        SVC.username = self.username
        self.navigationController?.pushViewController(SVC, animated: true)
    }
    
    @IBAction func viewRequests(_ sender:Any){
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        let SVC = Storyboard.instantiateViewController(withIdentifier: "RequestsViewController") as! RequestsViewController
        SVC.requesters = self.requesters
        SVC.requestKeys = self.requestKeys
        SVC.username = self.username
        self.navigationController?.pushViewController(SVC, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        acceptRequestButton.isHidden = true
        
    
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        DBref = Database.database().reference()
        
        let userID = Auth.auth().currentUser?.uid
        
        self.DBref.child("users").child(userID!).child("username").observeSingleEvent(of: .value) { (snapshot) in
            let username = snapshot.value as! String
            self.welcomeLabel.text = "Welcome " + username
            self.username = username
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.requesters.removeAll()
        self.requestKeys.removeAll()
        var requestCount = 0
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.DBref.child("users").observe(.childAdded, with: { (snapshot) in
            if let snap = snapshot.value as? [String:Any]{
                if snap["admin"] as! Bool == true{
                    if let playerSnap = snap["players"] as? [String:Any]{
                        if let requests = playerSnap["requested"] as? [String]{
                            if requests.contains(self.username){
                                requestCount = requestCount + 1
                                let coach = snap["username"] as! String
                                self.requesters.append(coach)
                                self.requestKeys.append(snapshot.key)
                                self.adminLabel.text = "you have \(requestCount) new requests"
                                self.acceptRequestButton.isHidden = false
                            }
                            else{
                                self.adminLabel.text = "You don't have any new requests."
                                self.acceptRequestButton.isHidden = true
                            }
                        }
                        else{
                            self.adminLabel.text = "You don't have any new requests."
                            self.acceptRequestButton.isHidden = true
                        }
                    }
                }
            }
        }, withCancel: nil)
        
        let userID = Auth.auth().currentUser?.uid
        
        self.DBref.child("users").child(userID!).child("coachName").observeSingleEvent(of: .value) { (snapshot) in
            if let coach = snapshot.value as? String{
                self.coachName.text = "Your coach is \(coach)"
            }
            else{
                self.coachName.text = "You do not have a coach yet."
            }
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
