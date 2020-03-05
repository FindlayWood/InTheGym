//
//  GeneralWorkoutViewController.swift
//  InTheGym
//
//  Created by Findlay Wood on 21/02/2020.
//  Copyright © 2020 FindlayWood. All rights reserved.
//

import UIKit
import Firebase

//this class is for trying to let the coach create a workout that can be given to several players

@available(iOS 13.0, *)
class GeneralWorkoutViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableview1:UITableView!
    @IBOutlet weak var tableview2:UITableView!
    
    var yesPlayers : [String] = []
    var noPlayers : [String] = ["bob", "bryan", "jeff", "jim", "steve"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview1.rowHeight = 60
        tableview2.rowHeight = 60

        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableview1 {
            return yesPlayers.count
        }else if tableView == tableview2{
            return noPlayers.count
        }
        else {return 0}
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tableview1 {
            let cell = self.tableview1.dequeueReusableCell(withIdentifier: "cell1") as! GeneralTableViewCell
            cell.name.text = yesPlayers[indexPath.row]
            cell.imagec.image = UIImage(named: "Workout Completed")
            return cell
        }else{
            let cell = self.tableview2.dequeueReusableCell(withIdentifier: "cell2") as! GeneralTableViewCell
            cell.name.text = noPlayers[indexPath.row]
            cell.imagec.image = UIImage(named: "Workout UnCompleted")
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tableview2 {
            yesPlayers.append(noPlayers[indexPath.row])
            noPlayers.remove(at: indexPath.row)
        }
        tableview1.reloadData()
        tableview2.reloadData()
    }
    
    @IBAction func confirmed(){
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        let SVC = Storyboard.instantiateViewController(identifier: "AddWorkoutHomeViewController") as! AddWorkoutHomeViewController
        SVC.players = self.yesPlayers
        
        self.navigationController?.pushViewController(SVC, animated: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
        let textAttributes = [NSAttributedString.Key.foregroundColor:#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }

    

}
