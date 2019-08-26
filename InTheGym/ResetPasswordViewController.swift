//
//  ResetPasswordViewController.swift
//  InTheGym
//
//  Created by Findlay Wood on 13/08/2019.
//  Copyright © 2019 FindlayWood. All rights reserved.
//

import UIKit
import Firebase

class ResetPasswordViewController: UIViewController {
    
    @IBOutlet weak var emailTextField:UITextField!
    
    @IBAction func resetPressed(_ sender:UIButton){
        if emailTextField.text!.isEmpty{
            let alert = UIAlertController(title: "Error", message: "Enter email.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            let email = emailTextField.text!
            Auth.auth().sendPasswordReset(withEmail: email) { (error) in
                if let error = error{
                    print(error)
                    let alert = UIAlertController(title: "Error", message: "Failed to send Reset email.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                else{
                    let alert = UIAlertController(title: "Sent!", message: "Reset email sent. Follow instructions in the email to change your password.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    self.emailTextField.text = ""
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()


    }
    


}
