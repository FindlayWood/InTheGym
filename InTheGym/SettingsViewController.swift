//
//  SettingsViewController.swift
//  InTheGym
//
//  Created by Findlay Wood on 31/07/2019.
//  Copyright © 2019 FindlayWood. All rights reserved.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func logout(_ sender:UIButton){
        sender.pulsate()
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
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    



}
