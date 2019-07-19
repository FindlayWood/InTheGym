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
    
    @IBAction func logIn(_ sender: Any){
        Auth.auth().signIn(withEmail: email.text!, password: password.text!) { (user, error) in
            if error == nil{
                let userID = Auth.auth().currentUser?.uid
                
                self.DBref.child("users").child(userID!).child("admin").observeSingleEvent(of: .value, with: { (snapshot) in
                    if snapshot.value as! Int == 1{
                        self.performSegue(withIdentifier: "logInAdmin", sender: self)
                    }
                    else{
                        self.performSegue(withIdentifier: "logInHome", sender: self)
                    }
                })
                
                
                
            }
            else{
                let alert = UIAlertController(title: "Error", message: "there was an error", preferredStyle: .alert)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
