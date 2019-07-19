//
//  SetsViewController.swift
//  InTheGym
//
//  Created by Findlay Wood on 07/07/2019.
//  Copyright © 2019 FindlayWood. All rights reserved.
//

import UIKit

class SetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var sets = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
    
    var exercise: String = ""
    var type: String = "weights"
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print(exercise)
        self.navigationItem.title = "Sets"

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = sets[indexPath.row] as String
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sets.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let StoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let SVC = StoryBoard.instantiateViewController(withIdentifier: "RepsViewController") as! RepsViewController
        
        SVC.sets = sets[indexPath.row]
        SVC.exercise = self.exercise
        SVC.type = self.type
        
        self.navigationController?.pushViewController(SVC, animated: true)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
