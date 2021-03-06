//
//  WorkoutDetailViewController.swift
//  InTheGym
//
//  Created by Findlay Wood on 09/07/2019.
//  Copyright © 2019 FindlayWood. All rights reserved.
//

import UIKit
import Firebase

class WorkoutDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var username: String = ""
    var titleString: String = ""
    var rowNumber: Int = 0
    var numberCompleted:Int!
    var complete: Bool!
    var exercises: [[String:AnyObject]] = []
    var workouts: [[String:AnyObject]] = []
    var activies: [[String:AnyObject]] = []
    var DBRef:DatabaseReference!
    var ActRef:DatabaseReference!
    var ComRef:DatabaseReference!
    var PVC: ViewWorkoutViewController!
    var ScoreRef: DatabaseReference!
    
    @IBOutlet var completeButton:UIButton!
    @IBOutlet var tableview:UITableView!
    
    
    @IBAction func completed(_ sender:UIButton){
        sender.pulsate()
        if complete == true{
            let alert = UIAlertController(title: "Uncomplete", message: "Are you sure this workout is uncomplete?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (UIAlertAction) in
                self.DBRef.child("\(self.rowNumber)").updateChildValues(["completed" : false])
                self.DBRef.child("\(self.rowNumber)").updateChildValues(["score" : ""])
                self.completeButton.setTitle("COMPLETED", for: .normal)
                let actData = ["time":ServerValue.timestamp(),
                               "message":"You uncompleted the workout \(self.titleString).",
                    "type":"Workout UnCompleted"] as [String:AnyObject]
                self.activies.insert(actData, at: 0)
                self.ActRef.setValue(self.activies)
                self.numberCompleted -= 1
                self.ComRef.child("numberOfCompletes").setValue(self.numberCompleted)
                self.navigationController?.popViewController(animated: true)
                
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
        else if complete == false{
            let alert = UIAlertController(title: "Completed!", message: "Enter a difficulty score if this workout is complete.", preferredStyle: .alert)
            alert.addTextField { (score) in
                score.placeholder = "enter difficulty score..."
                score.keyboardType = .numberPad
            }
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (UIAlertAction) in
                if alert.textFields?.first?.text == "" {
                    self.showError()
                }else if Int((alert.textFields?.first?.text)!)! < 0 || Int((alert.textFields?.first!.text)!)! > 11{
                    self.showError()
                }else{
                    self.DBRef.child("\(self.rowNumber)").updateChildValues(["completed" : true])
                    let scoreNum = alert.textFields?.first?.text!
                    self.DBRef.child("\(self.rowNumber)").updateChildValues(["score" : scoreNum!])
                    self.ScoreRef.updateChildValues([self.titleString:scoreNum!])
                    self.completeButton.setTitle("UNCOMPLETED", for: .normal)
                    let actData = ["time":ServerValue.timestamp(),
                                   "message":"You completed the workout \(self.titleString).",
                                    "type":"Workout Completed"] as [String:AnyObject]
                    self.activies.insert(actData, at: 0)
                    self.ActRef.setValue(self.activies)
                    self.numberCompleted += 1
                    self.ComRef.child("numberOfCompletes").setValue(self.numberCompleted)
                    self.navigationController?.popViewController(animated: true)
                    
                    
                }
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func showError(){
        let alert = UIAlertController(title: "Error", message: "Enter score between 1 and 10", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableview.rowHeight = 100
        let userID = Auth.auth().currentUser?.uid
        
        if complete == true{
            completeButton.setTitle("UNCOMPLETED", for: .normal)
        }
        navigationItem.title = titleString
        DBRef = Database.database().reference().child("Workouts").child(username)
        ActRef = Database.database().reference().child("users").child(userID!).child("activities")
        ComRef = Database.database().reference().child("users").child(userID!)
        if ViewController.admin == true{
            ScoreRef = Database.database().reference().child("Scores").child(AdminActivityViewController.username).child(username)
        }
        else{
            ScoreRef = Database.database().reference().child("Scores").child(PlayerActivityViewController.coachName).child(username)
        }
        //ScoreRef = Database.database().reference().child("Scores").child(userID!).child(username)
        loadActivities()
        loadNumberOfCompletes()
       
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableview.dequeueReusableCell(withIdentifier: "cell") as! DetailTableViewCell
        //let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        let exercise = exercises[indexPath.section]["exercise"] as! String
        let reps = exercises[indexPath.section]["reps"] as! String
        let sets = exercises[indexPath.section]["sets"] as! String
        let weight = exercises[indexPath.section]["weight"] as? String
        if weight == nil{
            //cell.textLabel?.text = "\(exercise), \(sets) sets, \(reps) mins"
            cell.exerciseLabel.text = "\(exercise)"
            cell.setsLabel.text = "SETS: \(sets)"
            cell.repsLabel.text = "MINS: \(reps)"
        }
        else if weight == ""{
            //cell.textLabel?.text = "\(exercise), \(sets) sets, \(reps) reps"
            cell.exerciseLabel.text = "\(exercise)"
            cell.setsLabel.text = "SETS: \(sets)"
            cell.repsLabel.text = "REPS: \(reps)"
        }
        else{
           //cell.textLabel?.text = "\(exercise), \(sets) sets, \(reps) reps, \(weight ?? "none") kg"
            cell.exerciseLabel.text = "\(exercise)"
            cell.setsLabel.text = "SETS: \(sets)"
            cell.repsLabel.text = "REPS: \(reps)"
            cell.weightLabel.text = "\(weight ?? "NA") kg"
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return exercises.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Exercise \(section+1)"
        label.font = .boldSystemFont(ofSize: 15)
        label.backgroundColor = #colorLiteral(red: 0.0167494379, green: 0.198006779, blue: 0.9999766946, alpha: 1)
        label.textAlignment = .center
        label.textColor = UIColor.white
        return label
    }
    
    func loadActivities(){
        ActRef.observe(.childAdded, with: { (snapshot) in
            if let snap = snapshot.value as? [String:AnyObject]{
                self.activies.append(snap)
            }
        }, withCancel: nil)
    }
    
    func loadNumberOfCompletes(){
        ComRef.child("numberOfCompletes").observeSingleEvent(of: .value) { (snapshot) in
            let count = snapshot.value as? Int
            self.numberCompleted = count ?? 0
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

}
