//
//  LoginViewController.swift
//  InTheGym
//
//  Created by Findlay Wood on 31/05/2019.
//  Copyright © 2019 FindlayWood. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var email:UITextField!
    @IBOutlet weak var password:UITextField!
    
    var DBref:DatabaseReference!
    
    @IBAction func logIn(_ sender: UIButton){
        sender.pulsate()
        Auth.auth().signIn(withEmail: email.text!, password: password.text!) { (user, error) in
            if error == nil{
                let userID = Auth.auth().currentUser?.uid
                
                self.DBref.child("users").child(userID!).child("admin").observeSingleEvent(of: .value, with: { (snapshot) in
                    if snapshot.value as! Int == 1{
                        self.performSegue(withIdentifier: "logInAdmin2", sender: self)
                    }
                    else{
                        self.performSegue(withIdentifier: "logInHome2", sender: self)
                    }
                })
                
                
                
            }
            else{
                let alert = UIAlertController(title: "Error", message: "Invalid information. Please enter valid login information.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        
        DBref = Database.database().reference()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

}
