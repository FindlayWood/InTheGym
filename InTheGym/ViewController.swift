//
//  ViewController.swift
//  InTheGym
//
//  Created by Findlay Wood on 29/05/2019.
//  Copyright © 2019 FindlayWood. All rights reserved.
//

import UIKit
import Firebase
import Network

class ViewController: UIViewController {
    
    var DBref: DatabaseReference!
    
    
    static var admin:Bool!
    
    let monitor = NWPathMonitor()

    override func viewDidLoad() {
        
        //check for internet connection
        monitor.pathUpdateHandler = { path in
            if path.status == .unsatisfied{
                self.showAlert()
            }
        }
        
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
        
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = .white
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        DBref = Database.database().reference()
        
        super.viewDidLoad()
        // check if current user exists and log them in
        if Auth.auth().currentUser != nil{
            let userID = Auth.auth().currentUser?.uid
            
            self.DBref.child("users").child(userID!).child("admin").observeSingleEvent(of: .value) { (snapshot) in
                if snapshot.value as! Int == 1{
                    self.performSegue(withIdentifier: "adminLoggedIn2", sender: self)
                    ViewController.admin = true
                }
                else{
                    self.performSegue(withIdentifier: "alreadyLoggedIn2", sender: self)
                    ViewController.admin = false
                }
            }
            
        }
    }
    
    // function when either button is tapped to navigate to the correct page
    @IBAction func tapped(_ sender:UIButton){
        sender.pulsate()
    }
    
    // set navigation bar hidden
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
    // alert to show when user has no internet connection
    func showAlert(){
        let alert = UIAlertController(title: "Connection", message: "You are not connected to the internet. This application will not work without an internet connection.", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
    }


}

