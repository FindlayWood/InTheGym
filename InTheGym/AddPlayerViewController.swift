//
//  AddPlayerViewController.swift
//  InTheGym
//
//  Created by Findlay Wood on 30/06/2019.
//  Copyright © 2019 FindlayWood. All rights reserved.
//

import UIKit
import Firebase

class AddPlayerViewController: UIViewController {
    
    var DBref:DatabaseReference!
    
    var playerUsernames = [String]()
    var adminsPlayers = [String]()
    var requestedPlayers = [String]()
    var acceptedPlayers = [String]()
    var users = [Users]()
    var adminsUsers = [Users]()
    
    let userID = Auth.auth().currentUser!.uid
    
    @IBOutlet weak var playerfield:UITextField!
    
    @IBAction func addTapped(_ sender:UIButton){
        sender.pulsate()
        let typedNamed = playerfield.text
        if playerUsernames.contains(typedNamed!){
            if self.requestedPlayers.contains(typedNamed!){
                let alert = UIAlertController(title: "Error!", message: "Request already sent.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler:  nil))
                self.present(alert, animated: true, completion: nil)
                playerfield.text = ""
            }
            else if self.acceptedPlayers.contains(typedNamed!){
                let alert = UIAlertController(title: "OOPS", message: "This player has already been added.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
                playerfield.text = ""
            }
                
            else{
                requestedPlayers.append(typedNamed!)
                for user in users{
                    if user.username == typedNamed{
                        self.adminsUsers.append(user)
                    }
                }
                self.DBref.child("users").child(self.userID).child("players").child("requested").setValue(requestedPlayers)
                let alert = UIAlertController(title: "Added!", message: "Request has been sent to player. They will have to accept before you can assign workouts to them.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler:  nil))
                self.present(alert, animated: true, completion: nil)
                playerfield.text = ""
            }
            
        }
        else{
            let alert = UIAlertController(title: "Error!", message: "This username doesn't exist", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler:  nil))
            self.present(alert, animated: true, completion: nil)
            playerfield.text = ""
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        
        DBref = Database.database().reference()
        
        self.DBref.child("users").child(self.userID).child("players").child("requested").observeSingleEvent(of: .value) { (snapshot) in
            if let snap = snapshot.value as? [String]{
                self.requestedPlayers = snap
            }
            
            
        }
        
        self.DBref.child("users").child(self.userID).child("players").child("accepted").observeSingleEvent(of: .value) { (snapshot) in
            if let snap = snapshot.value as? [String]{
                self.acceptedPlayers = snap
            }
        }
        
        self.DBref.child("users").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let user = Users()
                user.username = dictionary["username"] as? String
                user.admin = dictionary["admin"] as? Bool
                user.email = dictionary["email"] as? String
                if user.admin == false{
                    self.playerUsernames.append(user.username!)
                    self.users.append(user)
                }
            }
        }, withCancel: nil)

        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
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
