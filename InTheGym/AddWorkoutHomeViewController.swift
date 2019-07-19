//
//  AddWorkoutHomeViewController.swift
//  InTheGym
//
//  Created by Findlay Wood on 04/07/2019.
//  Copyright © 2019 FindlayWood. All rights reserved.
//

import UIKit
import Firebase

class AddWorkoutHomeViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var titleField:UITextField!
    @IBOutlet weak var tableview:UITableView!
    
    var userName:String!
    var DBRef:DatabaseReference!
    
    static var exercises : [[String:String]] = []
    static var workouts :[[String:Any]] = []
    
    
    @IBAction func savePressed(_ sender:UIButton){
        if titleField.text == ""{
            let alert = UIAlertController(title: "Oops!", message: "Please enter a title.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler:  nil))
            self.present(alert, animated: true, completion: nil)
        }else if AddWorkoutHomeViewController.exercises.count == 0{
            let alert = UIAlertController(title: "Oops!", message: "You must add atleast one exercise.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler:  nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            let exerciseData = ["title": titleField.text!,
                                "completed": false,
                                "exercises": AddWorkoutHomeViewController.exercises] as [String : Any]
            
            
            AddWorkoutHomeViewController.workouts.append(exerciseData)
            DBRef.setValue(AddWorkoutHomeViewController.workouts)
            titleField.text = ""
            AddWorkoutHomeViewController.exercises.removeAll()
            tableview.reloadData()
            let alert = UIAlertController(title: "Uploaded!", message: "This workout has been uploaded and the player can now view it.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler:  nil))
            self.present(alert, animated: true, completion: nil)
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        
        DBRef = Database.database().reference().child("Workouts").child(userName)
        
        DBRef.observe(.childAdded, with: { (snapshot) in
            if let snap = snapshot.value as? [String:AnyObject]{
                AddWorkoutHomeViewController.workouts.append(snap)
            }
        }, withCancel: nil)

        // Do any additional setup after loading the view.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AddWorkoutHomeViewController.exercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = AddWorkoutHomeViewController.exercises[indexPath.row]["exercise"]
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            AddWorkoutHomeViewController.exercises.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableview.reloadData()
    }

}
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
