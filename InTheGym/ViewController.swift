//
//  ViewController.swift
//  InTheGym
//
//  Created by Findlay Wood on 29/05/2019.
//  Copyright © 2019 FindlayWood. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    var DBref: DatabaseReference!

    override func viewDidLoad() {
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = .white
        
        DBref = Database.database().reference()
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if Auth.auth().currentUser != nil{
            let userID = Auth.auth().currentUser?.uid
            print("user id is ", userID!)
            
            self.DBref.child("users").child(userID!).child("admin").observeSingleEvent(of: .value) { (snapshot) in
                print("snapshot is ", snapshot.value!)
                if snapshot.value as! Int == 1{
                    self.performSegue(withIdentifier: "adminLoggedIn", sender: self)
                }
                else{
                    self.performSegue(withIdentifier: "alreadyLoggedIn", sender: self)
                }
            }
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }


}

