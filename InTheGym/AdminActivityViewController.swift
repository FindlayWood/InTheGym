//
//  AdminActivityViewController.swift
//  InTheGym
//
//  Created by Findlay Wood on 29/07/2019.
//  Copyright © 2019 FindlayWood. All rights reserved.
//

import UIKit
import Firebase

class AdminActivityViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableview:UITableView!
    
    var username:String = ""
    var activities : [[String:AnyObject]] = []
    
    var DBRef:DatabaseReference!
    var ActRef:DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableview.rowHeight = 90
        let userID = Auth.auth().currentUser?.uid
        ActRef = Database.database().reference().child("users").child(userID!).child("activities")
        self.navigationController?.setNavigationBarHidden(true, animated: true)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadActivities()
        tableview.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableview.dequeueReusableCell(withIdentifier: "cell") as! ActivityTableViewCell
        let dateStamp = self.activities[indexPath.row]["time"] as? TimeInterval
        let date = NSDate(timeIntervalSince1970: dateStamp!/1000)
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        let final = formatter.string(from: date as Date)
        let type = self.activities[indexPath.row]["type"] as? String
        cell.type.text = type
        cell.time.text = final
        cell.message.text = self.activities[indexPath.row]["message"] as? String
        cell.pic.image = UIImage(named: type!)
        
        return cell
    }
    
    func loadActivities(){
        activities.removeAll()
        self.ActRef.observe(.childAdded, with: { (snapshot) in
            if let snap = snapshot.value as? [String:AnyObject]{
                self.activities.append(snap)
                self.tableview.reloadData()
            }
        }, withCancel: nil)
    }
    

}
