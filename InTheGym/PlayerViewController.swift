//
//  PlayerViewController.swift
//  InTheGym
//
//  Created by Findlay Wood on 04/07/2019.
//  Copyright © 2019 FindlayWood. All rights reserved.
//

import UIKit

class PlayerViewController: UIViewController {
    
    @IBOutlet weak var userName:UILabel!
    @IBOutlet weak var userEmail:UILabel!
    @IBOutlet weak var firstName:UILabel!
    @IBOutlet weak var lastName:UILabel!
    var userNameString:String = ""
    var userEmailString:String = ""
    var firstNameString:String = ""
    var lastNameString:String = ""
    
    
    @IBAction func addWorkoutPressed(_ sender:UIButton){
        let StoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let SVC = StoryBoard.instantiateViewController(withIdentifier: "AddWorkoutHomeViewController") as! AddWorkoutHomeViewController
        SVC.userName = self.userNameString
        self.navigationController?.pushViewController(SVC, animated: true)
    }
    
    @IBAction func viewPBsPressed(_ sender:UIButton){
        let StoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let SVC = StoryBoard.instantiateViewController(withIdentifier: "PBsViewController") as! PBsViewController
        SVC.username = self.userNameString
        self.navigationController?.pushViewController(SVC, animated: true)
    }
    
    @IBAction func viewWorkoutsPressed(_ sender:UIButton){
        let StoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let SVC = StoryBoard.instantiateViewController(withIdentifier: "ViewWorkoutViewController") as! ViewWorkoutViewController
        SVC.username = self.userNameString
        self.navigationController?.pushViewController(SVC, animated: true)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        userName.text = "Username: \(userNameString)"
        userEmail.text = "Email: \(userEmailString)"
        firstName.text = "First Name: \(firstNameString)"
        lastName.text = "Last Name: \(lastNameString)"
        navigationItem.title = "Player Info"

        // Do any additional setup after loading the view.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

}
