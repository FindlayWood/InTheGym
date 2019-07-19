//
//  ViewWorkoutViewController.swift
//  InTheGym
//
//  Created by Findlay Wood on 09/07/2019.
//  Copyright © 2019 FindlayWood. All rights reserved.
//

import UIKit
import Firebase

class ViewWorkoutViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var username:String = ""
    var workouts : [[String:Any]] = []
    var DBRef : DatabaseReference!
    @IBOutlet var tableview:UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Workouts"
        
    }
    
    func loadWorkouts(){
        workouts.removeAll()
        DBRef.observe(.childAdded, with: { (snapshot) in
            if let snap = snapshot.value as? [String:AnyObject]{
                self.workouts.append(snap)
                self.tableview.reloadData()
            }
        }, withCancel: nil)
        
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableview.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        cell.main.text = self.workouts[indexPath.row]["title"] as? String
        if self.workouts[indexPath.row]["completed"] as! Bool == true{
            cell.second.textColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
            cell.second.text = "COMPLETED"
        }else{
            cell.second.textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            cell.second.text = "UNCOMPLETED"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workouts.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let titleLabel = workouts[indexPath.row]["title"] as! String
        let complete = workouts[indexPath.row]["completed"] as! Bool
        let StoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let SVC = StoryBoard.instantiateViewController(withIdentifier: "WorkoutDetailViewController") as! WorkoutDetailViewController
        SVC.username = self.username
        SVC.titleString = titleLabel
        SVC.exercises = workouts[indexPath.row]["exercises"] as! [[String:AnyObject]]
        SVC.rowNumber = indexPath.row
        SVC.complete = complete
        self.navigationController?.pushViewController(SVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            workouts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
            DBRef.setValue(workouts)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        DBRef = Database.database().reference().child("Workouts").child(username)
        loadWorkouts()
        tableview.reloadData()
        
    }
}
