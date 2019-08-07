//
//  PlayerWorkoutViewController.swift
//  InTheGym
//
//  Created by Findlay Wood on 30/07/2019.
//  Copyright © 2019 FindlayWood. All rights reserved.
//

import UIKit
import Firebase

class PlayerWorkoutViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableview:UITableView!
    
    var workouts:[[String:AnyObject]] = []
    var DBref:DatabaseReference!
    var UsernameRef:DatabaseReference!
    var username:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableview.rowHeight = 80
        
        let userID = Auth.auth().currentUser?.uid
        
        UsernameRef = Database.database().reference().child("users").child(userID!).child("username")
        DBref = Database.database().reference().child("Workouts")
        
    }
    
    func loadWorkouts(){
        workouts.removeAll()
        DBref.child(PlayerActivityViewController.username).observe(.childAdded, with: { (snapshot) in
            if let snap = snapshot.value as? [String:AnyObject]{
                self.workouts.append(snap)
                self.tableview.reloadData()
            }
        }, withCancel: nil)
        
        
    }
    
    func loadUsername(){
        UsernameRef.observeSingleEvent(of: .value) { (snapshot) in
            let snap = snapshot.value as! String
            self.username = snap
            //self.loadWorkouts()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableview.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        let score = self.workouts[indexPath.row]["score"] as? String
        cell.main.text = self.workouts[indexPath.row]["title"] as? String
        if self.workouts[indexPath.row]["completed"] as! Bool == true{
            cell.second.textColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
            cell.second.text = "COMPLETED"
            cell.score.text = "Score: \(score!)"
        }else{
            cell.second.textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            cell.second.text = "UNCOMPLETED"
            cell.score.text = ""
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
        SVC.username = PlayerActivityViewController.username
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
            DBref.child(self.username).setValue(workouts)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //loadUsername()
        loadWorkouts()
        tableview.reloadData()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }


}
