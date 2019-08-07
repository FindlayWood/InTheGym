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
    
    
    
    @IBAction func signUp(_ sender: UIButton){
        sender.pulsate()
        if firstName.text!.isEmpty || lastName.text!.isEmpty || email.text!.isEmpty || username.text!.isEmpty{
            let alert = UIAlertController(title: "Error!", message: "Make sure all information has been entered.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler:  nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            if usernames.contains(username.text!){
                let alert = UIAlertController(title: "Error!", message: "Username already exists. Please choose another username.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler:  nil))
                self.present(alert, animated: true, completion: nil)
                username.text = ""
            }
            else{
                if password.text != passwordConfirm.text{
                    let alert = UIAlertController(title: "Error!", message: "Passwords do not match.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler:  nil))
                    self.present(alert, animated: true, completion: nil)
                    password.text = ""
                    passwordConfirm.text = ""
                }
                else{
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
                            
                            if self.admin == true{
                                self.performSegue(withIdentifier: "adminPage2", sender: self)
                            }
                            else{
                                self.performSegue(withIdentifier: "signUpHome2", sender: self)
                            }
                        }
                        else{
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
