//
//  WeightViewController.swift
//  InTheGym
//
//  Created by Findlay Wood on 11/07/2019.
//  Copyright © 2019 FindlayWood. All rights reserved.
//

import UIKit


class WeightViewController: UIViewController {
    
    var sets: String = ""
    var exercise: String = ""
    var reps: String = ""
    
    @IBOutlet var weightField: UITextField!
    
    @IBAction func addPressed(_ sender:Any){
        if let weighAmount = weightField.text{
            let dictData = ["exercise": self.exercise,
                            "sets": self.sets,
                            "reps": self.reps,
                            "weight": "\(weighAmount)"]
            
            AddWorkoutHomeViewController.exercises.append(dictData)
            
            
            let alert = UIAlertController(title: "Added!", message: "Exercise has been added to the list.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { (UIAlertAction) in
                let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
                self.navigationController?.popToViewController(viewControllers[viewControllers.count - 6], animated: true)
                
            }))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            let alert = UIAlertController(title: "Error!", message: "Please enter a weight for this exercise.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler:  nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()

        // Do any additional setup after loading the view.
    }

}
