//
//  PlayerViewController.swift
//  InTheGym
//
//  Created by Findlay Wood on 04/07/2019.
//  Copyright © 2019 FindlayWood. All rights reserved.
//

import UIKit
import Charts
import Firebase

class PlayerViewController: UIViewController {
    
    // outlet variables for user info
    @IBOutlet weak var userName:UILabel!
    @IBOutlet weak var userEmail:UILabel!
    @IBOutlet weak var firstName:UILabel!
    @IBOutlet weak var lastName:UILabel!
    // string variables foe user info
    var userNameString:String = ""
    var userEmailString:String = ""
    var firstNameString:String = ""
    var lastNameString:String = ""
    
    // outlet view for pie chart of scores
    @IBOutlet weak var pieChart:PieChartView!
    
    var score:[[String:AnyObject]] = []
    var scores:[Int] = []
    var counter:[String:Int] = [:]
    
    var DBRef:DatabaseReference!
    
    
    var numberOfScores = [PieChartDataEntry]()
    
    
    //function for when the user taps add workout
    @IBAction func addWorkoutPressed(_ sender:UIButton){
        sender.pulsate()
        let StoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let SVC = StoryBoard.instantiateViewController(withIdentifier: "AddWorkoutHomeViewController") as! AddWorkoutHomeViewController
        SVC.userName = self.userNameString
        self.navigationController?.pushViewController(SVC, animated: true)
    }
    
    //function for when the user taps view pbs
    @IBAction func viewPBsPressed(_ sender:UIButton){
        sender.pulsate()
        let StoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let SVC = StoryBoard.instantiateViewController(withIdentifier: "PBsViewController") as! PBsViewController
        SVC.username = self.userNameString
        self.navigationController?.pushViewController(SVC, animated: true)
    }
    
    //function for when the user taps view workouts
    @IBAction func viewWorkoutsPressed(_ sender:UIButton){
        sender.pulsate()
        let StoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let SVC = StoryBoard.instantiateViewController(withIdentifier: "ViewWorkoutViewController") as! ViewWorkoutViewController
        SVC.username = self.userNameString
        self.navigationController?.pushViewController(SVC, animated: true)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        userName.text = "Username: \(userNameString)"
        userEmail.text = "Email: \(userEmailString)"
        firstName.text = "First Name: \(firstNameString)"
        lastName.text = "Last Name: \(lastNameString)"
        navigationItem.title = "Player Info"
        
        pieChart.backgroundColor = .white

        // Do any additional setup after loading the view.
        DBRef = Database.database().reference().child("Scores").child(AdminActivityViewController.username).child(userNameString)
        
    }
    
    func loadScores(){
           score.removeAll()
           DBRef.observe(.value) { (snapshot) in
               print(snapshot.childrenCount)
               print("made it here")
               self.DBRef.observe(.value, with: { (snapshot) in
                   if let snap = snapshot.value as? [String:AnyObject]{
                       print("and hereeeee")
                       self.score.append(snap)
                       self.calcValues()
                   }
               }, withCancel: nil)
           }
       }
    
    func calcValues(){
        scores.removeAll()
        for x in score{
            for (_, value) in x{
                let sval = value as! String
                let ival = Int(sval)
                scores.append(ival!)
            }
        }
        countOccur()
        calcAverage()
    }
    
    func countOccur(){
        counter.removeAll()
        for item in scores{
            counter[String(item)] = (counter[String(item)] ?? 0) + 1
        }
        print(counter)
        setChartData()
    }
    
    func calcAverage(){
        var total = 0.0
        for num in scores{
            total += Double(num)
        }
        let average = String(round(total/Double(scores.count)*10)/10)
        let myAttribute = [NSAttributedString.Key.font: UIFont(name: "Menlo-Bold", size: 15)!]
        let myAttrString = NSAttributedString(string: average, attributes: myAttribute)
        pieChart.centerAttributedText = myAttrString
    }
    
    func setChartData(){
        let zeroEntry = PieChartDataEntry(value: Double(counter["0"] ?? 0))
        zeroEntry.label = "0"
        let oneEntry = PieChartDataEntry(value: Double(counter["1"] ?? 0))
        oneEntry.label = "1"
        let twoEntry = PieChartDataEntry(value: Double(counter["2"] ?? 0))
        twoEntry.label = "2"
        let threeEntry = PieChartDataEntry(value: Double(counter["3"] ?? 0))
        threeEntry.label = "3"
        let fourEntry = PieChartDataEntry(value: Double(counter["4"] ?? 0))
        fourEntry.label = "4"
        let fiveEntry = PieChartDataEntry(value: Double(counter["5"] ?? 0))
        fiveEntry.label = "5"
        let sixEntry = PieChartDataEntry(value: Double(counter["6"] ?? 0))
        sixEntry.label = "6"
        let sevenEntry = PieChartDataEntry(value: Double(counter["7"] ?? 0))
        sevenEntry.label = "7"
        let eightEntry = PieChartDataEntry(value: Double(counter["8"] ?? 0))
        eightEntry.label = "8"
        let nineEntry = PieChartDataEntry(value: Double(counter["9"] ?? 0))
        nineEntry.label = "9"
        let tenEntry = PieChartDataEntry(value: Double(counter["10"] ?? 0))
        tenEntry.label = "10"
        
        
        
        numberOfScores = [zeroEntry,oneEntry,twoEntry,threeEntry,fourEntry,fiveEntry,sixEntry,sevenEntry,eightEntry,nineEntry,tenEntry]
        
        
        
        updateChartData()
        
        
    }
    
    func updateChartData(){
        let chartDataSet = PieChartDataSet(entries: numberOfScores, label: nil)
        
        let noZeroFormatter = NumberFormatter()
        noZeroFormatter.zeroSymbol = ""
        chartDataSet.valueFormatter = DefaultValueFormatter(formatter: noZeroFormatter)
        
        let chartData = PieChartData(dataSet: chartDataSet)
        
        let colors = [#colorLiteral(red: 0.3021106021, green: 0.4654112241, blue: 1, alpha: 0.3329141695), #colorLiteral(red: 0.3021106021, green: 0.4654112241, blue: 1, alpha: 0.549604024), #colorLiteral(red: 0.3021106021, green: 0.4654112241, blue: 1, alpha: 0.7467893836), #colorLiteral(red: 0.3021106021, green: 0.4654112241, blue: 1, alpha: 0.8184931507), #colorLiteral(red: 0.3021106021, green: 0.4654112241, blue: 1, alpha: 0.9183433219), #colorLiteral(red: 0.004983612501, green: 0.1452928051, blue: 0.7435358503, alpha: 1), #colorLiteral(red: 0.004527620861, green: 0.131998773, blue: 0.6755036485, alpha: 1), #colorLiteral(red: 0.003697771897, green: 0.107805262, blue: 0.5516933693, alpha: 1),#colorLiteral(red: 0.003351292677, green: 0.09770396748, blue: 0.5, alpha: 1), #colorLiteral(red: 0.00270232527, green: 0.07878389795, blue: 0.4031765546, alpha: 1), #colorLiteral(red: 0.00198916551, green: 0.05799235728, blue: 0.2967758566, alpha: 1)]
        chartDataSet.colors = colors
        
    
        chartDataSet.drawValuesEnabled = true
        chartDataSet.valueFont = UIFont(name: "Menlo-Bold", size: 15)!
        pieChart.drawEntryLabelsEnabled = false
        
        pieChart.data = chartData
    }
    

    override func viewWillAppear(_ animated: Bool) {
        loadScores()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        let textAttributes = [NSAttributedString.Key.foregroundColor:#colorLiteral(red: 0, green: 0.4618991017, blue: 1, alpha: 1)]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0, green: 0.4618991017, blue: 1, alpha: 1)
        
    }

}
