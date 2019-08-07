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
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        DBref = Database.database().reference()
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if Auth.auth().currentUser != nil{
            let userID = Auth.auth().currentUser?.uid
            print("user id is ", userID!)
            
            self.DBref.child("users").child(userID!).child("admin").observeSingleEvent(of: .value) { (snapshot) in
                print("snapshot is ", snapshot.value!)
                if snapshot.value as! Int == 1{
                    self.performSegue(withIdentifier: "adminLoggedIn2", sender: self)
                }
                else{
                    self.performSegue(withIdentifier: "alreadyLoggedIn2", sender: self)
                }
            }
            
        }
    }
    
    @IBAction func tapped(_ sender:UIButton){
        sender.pulsate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }


}

