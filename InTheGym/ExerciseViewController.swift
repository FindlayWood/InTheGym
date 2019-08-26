//
//  ExerciseViewController.swift
//  InTheGym
//
//  Created by Findlay Wood on 07/07/2019.
//  Copyright © 2019 FindlayWood. All rights reserved.
//

import UIKit
import Firebase

class ExerciseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var exerciseType: String = ""
    var exerciseList = [String]()
    @IBOutlet weak var tableview:UITableView!
    
    var DBRef:DatabaseReference!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Exercise"

        DBRef = Database.database().reference().child("Exercises")
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exerciseList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = exerciseList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let StoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let SVC = StoryBoard.instantiateViewController(withIdentifier: "SetsViewController") as! SetsViewController
        
        if exerciseType == "Upper Body"{
            SVC.exercise = exerciseList[indexPath.row]
        }
        else if exerciseType == "Lower Body"{
            SVC.exercise = exerciseList[indexPath.row]
        }
        else if exerciseType == "Core"{
            SVC.exercise = exerciseList[indexPath.row]
        }
        else{
            SVC.exercise = exerciseList[indexPath.row]
            SVC.type = "cardio"
        }
        
        self.navigationController?.pushViewController(SVC, animated: true)
        
    }
    
    func loadExercises(bodyType: String){
        exerciseList.removeAll()
        DBRef.child(bodyType).observe(.childAdded) { (snapshot) in
            if let snap = snapshot.value as? String{
                self.exerciseList.append(snap)
                self.tableview.reloadData()
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadExercises(bodyType: exerciseType)
        navigationController?.navigationBar.tintColor = .white
    }
    

}
