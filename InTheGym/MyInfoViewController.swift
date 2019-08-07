//
//  MyInfoViewController.swift
//  InTheGym
//
//  Created by Findlay Wood on 29/07/2019.
//  Copyright © 2019 FindlayWood. All rights reserved.
//

import UIKit
import Firebase

class MyInfoViewController: UIViewController {
    
    @IBOutlet weak var nameLabel:UILabel!
    @IBOutlet weak var usernameLabel:UILabel!
    @IBOutlet weak var emailLabel:UILabel!
    @IBOutlet weak var playerCountLabel:UILabel!
    @IBOutlet weak var workoutsSetCount:UILabel!
    
    var DBRef:DatabaseReference!
    var playerCount:Int!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let userID = Auth.auth().currentUser?.uid
        DBRef = Database.database().reference().child("users").child(userID!)

    }
    
    func loadInfo(){
        DBRef.observe(.value) { (snapshot) in
            if let snap = snapshot.value as? [String:AnyObject]{
                let first = snap["firstName"] as? String ?? "First"
                let last = snap["lastName"] as? String ?? "Last"
                self.nameLabel.text = "\(first) \(last)"
                let username = snap["username"] as? String
                self.usernameLabel.text = "@\(username!)"
                self.emailLabel.text = snap["email"] as? String
            }
        }
    }
    
    func loadNumberOfUsers(){
        DBRef.child("players").child("accepted").observeSingleEvent(of: .value) { (snapshot) in
            if let snap = snapshot.value as? [String]{
                self.playerCount = snap.count
                print(self.playerCount!)
                self.playerCountLabel.text = "\(self.playerCount!)"
            }
        }
    }
    
    func loadNumberOfWorkouts(){
        DBRef.child("NumberOfWorkouts").observeSingleEvent(of: .value) { (snapshot) in
            print(snapshot.value!)
            let count = snapshot.value as? Int
            self.workoutsSetCount.text = "\(count ?? 0)"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadInfo()
        loadNumberOfUsers()
        loadNumberOfWorkouts()
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    

}
