//
//  SignUpViewController.swift
//  InTheGym
//
//  Created by Findlay Wood on 31/05/2019.
//  Copyright © 2019 FindlayWood. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    
    // outlet variables to for the signup fields
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var passwordConfirm :UITextField!
    @IBOutlet var segment: UISegmentedControl!
    
    
    
    
    
    
    var userRef: DatabaseReference!
    var admin: Bool = false
    var usernames = [String]()
    
    // function for choosing either coach or player user
    @IBAction func segmentTapped(_ sender: Any) {
        switch segment.selectedSegmentIndex {
        case 0:
            admin = true
        case 1:
            admin = false
        default:
            break
        }
    }
    
    
    // function for when the user taps signup. checks all fields for valid info
    @IBAction func signUp(_ sender: UIButton){
        sender.pulsate()
        // check no field is emoty
        if firstName.text!.isEmpty || lastName.text!.isEmpty || email.text!.isEmpty || username.text!.isEmpty{
            let alert = UIAlertController(title: "Error!", message: "Make sure all information has been entered.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler:  nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            // check that username is unique
            if usernames.contains(username.text!){
                let alert = UIAlertController(title: "Error!", message: "Username already exists. Please choose another username.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler:  nil))
                self.present(alert, animated: true, completion: nil)
                username.text = ""
            }
            else{
                // check if passwords match
                if password.text != passwordConfirm.text{
                    let alert = UIAlertController(title: "Error!", message: "Passwords do not match.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler:  nil))
                    self.present(alert, animated: true, completion: nil)
                    password.text = ""
                    passwordConfirm.text = ""
                }
                else{
                    // create new user
                    Auth.auth().createUser(withEmail: email.text!, password: password.text!) { (user, error) in
                        if error == nil{
                            
                            //let key = self.userRef.childByAutoId().key
                            let userID = Auth.auth().currentUser!.uid
                            
                            let userData = ["email":self.email.text!,
                                            "username":self.username.text!,
                                            "admin":self.admin,
                                            "firstName":self.firstName.text!,
                                            "lastName":self.lastName.text!] as [String : Any]
                            
                            self.userRef.child(userID).setValue(userData)
                            
                            // send user to the correct page. either coach or player
                            if self.admin == true{
                                self.performSegue(withIdentifier: "adminPage2", sender: self)
                                ViewController.admin = true
                            }
                            else{
                                self.performSegue(withIdentifier: "signUpHome2", sender: self)
                                ViewController.admin = false
                            }
                        }
                        else{
                            // check that email is unique
                            let alert = UIAlertController(title: "Error!", message: "Invalid email address.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                            self.email.text = ""
                        }
                    }
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        
        userRef = Database.database().reference().child("users")
        checkUsernames()
        
        
    }
    
    
    // fucntion to load over all usernames. used later to check for unique password
    func checkUsernames(){
        self.userRef.observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject]{
                let user = Users()
                user.username = dictionary["username"] as? String
                self.usernames.append(user.username!)
            }
        }, withCancel: nil)
    }
    

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
        
    }

}
