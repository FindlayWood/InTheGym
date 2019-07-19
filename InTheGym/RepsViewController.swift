//
//  RepsViewController.swift
//  InTheGym
//
//  Created by Findlay Wood on 07/07/2019.
//  Copyright © 2019 FindlayWood. All rights reserved.
//

import UIKit
import Firebase

class RepsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var sets: String = ""
    var exercise: String = ""
    var type: String = ""
    
    var DBref: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if type == "weights"{
            self.navigationItem.title = "Reps"
        }else{
            self.navigationItem.title = "Minutes"
        }
        
        
        let userID = Auth.auth().currentUser?.uid
        
        DBref = Database.database().reference().child("users").child(userID!).child("workouts")

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        var x = 0
        while (x<21) {
            cell.textLabel?.text = "\(indexPath.row + 1)"
            x = x + 1
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if type == "weights"{
            let StoryBoard = UIStoryboard(name: "Main", bundle: nil)
            let SVC = StoryBoard.instantiateViewController(withIdentifier: "WeightViewController") as! WeightViewController
            SVC.exercise = self.exercise
            SVC.sets = self.sets
            SVC.reps = "\(indexPath.row+1)"
            self.navigationController?.pushViewController(SVC, animated: true)
            
        }else{
            let dictData = ["exercise": self.exercise,
                            "sets": self.sets,
                            "reps": "\(indexPath.row + 1)"]
            AddWorkoutHomeViewController.exercises.append(dictData)
            
            
            let alert = UIAlertController(title: "Added!", message: "Exercise has been added to the list.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
                let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
                self.navigationController?.popToViewController(viewControllers[viewControllers.count - 5], animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
}
