//
//  ExerciseViewController.swift
//  InTheGym
//
//  Created by Findlay Wood on 07/07/2019.
//  Copyright © 2019 FindlayWood. All rights reserved.
//

import UIKit

class ExerciseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var upperBodyExercises = ["Bench Press", "Shoulder Press", "Pull Ups", "Push Ups"]
    var lowerBodyExercises = ["Squats", "Lunges", "Leg Press", "Box Jumps", "Calf Raises"]
    var coreExercises = ["Sit Ups", "Plank", "Side Plank", "Leg Raises"]
    var cardioExercises = ["Treadmill", "Bike", "Row"]
    
    var exerciseType: String = ""
    @IBOutlet weak var tableview:UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Exercise"

        // Do any additional setup after loading the view.
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if exerciseType == "Upper Body"{
            return upperBodyExercises.count
        }
        else if exerciseType == "Lower Body"{
            return lowerBodyExercises.count
        }
        else if exerciseType == "Core"{
            return coreExercises.count
        }
        else{
            return cardioExercises.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        if exerciseType == "Upper Body"{
            cell.textLabel?.text = upperBodyExercises[indexPath.row]
            return cell
        }
        else if exerciseType == "Lower Body"{
            cell.textLabel?.text = lowerBodyExercises[indexPath.row]
            return cell
        }
        else if exerciseType == "Core"{
            cell.textLabel?.text = coreExercises[indexPath.row]
            return cell
        }
        else{
            cell.textLabel?.text = cardioExercises[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let StoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let SVC = StoryBoard.instantiateViewController(withIdentifier: "SetsViewController") as! SetsViewController
        
        if exerciseType == "Upper Body"{
            SVC.exercise = upperBodyExercises[indexPath.row]
        }
        else if exerciseType == "Lower Body"{
            SVC.exercise = lowerBodyExercises[indexPath.row]
        }
        else if exerciseType == "Core"{
            SVC.exercise = coreExercises[indexPath.row]
        }
        else{
            SVC.exercise = cardioExercises[indexPath.row]
            SVC.type = "cardio"
        }
        
        self.navigationController?.pushViewController(SVC, animated: true)
        
    }
    

}
