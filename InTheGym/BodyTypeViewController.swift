//
//  BodyTypeViewController.swift
//  InTheGym
//
//  Created by Findlay Wood on 07/07/2019.
//  Copyright © 2019 FindlayWood. All rights reserved.
//

import UIKit

class BodyTypeViewController: UIViewController {
    
    @IBAction func buttonTapped(_ sender:UIButton){
        let StoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let SVC = StoryBoard.instantiateViewController(withIdentifier: "ExerciseViewController") as! ExerciseViewController
        
        SVC.exerciseType = sender.titleLabel!.text as! String
        
        self.navigationController?.pushViewController(SVC, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
