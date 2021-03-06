//
//  PlayerInfoViewController.swift
//  InTheGym
//
//  Created by Findlay Wood on 30/07/2019.
//  Copyright © 2019 FindlayWood. All rights reserved.
//

import UIKit
import Firebase
import Charts

class PlayerInfoViewController: UIViewController {
    
    var username:String = ""
    var adminKey:String = ""
    var gotArequest:Bool = false
    var requesters = [String]()
    var requestKeys = [String]()
    
    var score:[[String:AnyObject]] = []
    var scores:[Int] = []
    var counter:[String:Int] = [:]
    
    var numberOfScores = [PieChartDataEntry]()
    
    var DBRef:DatabaseReference!
    var ScoreRef:DatabaseReference!
    
    let userID = Auth.auth().currentUser?.uid
    
    @IBOutlet weak var nameLabel:UILabel!
    @IBOutlet weak var usernameLabel:UILabel!
    @IBOutlet weak var emailLabel:UILabel!
    @IBOutlet weak var coachNameLabel:UILabel!
    @IBOutlet weak var coachUsernameLabel:UILabel!
    @IBOutlet weak var coachEmailLabel:UILabel!
    @IBOutlet weak var countedLabel:UILabel!
    @IBOutlet weak var acceptRequestButton:UIButton!
    
    @IBOutlet weak var pieChart:PieChartView!

    
    @IBAction func viewPBs(_ sender:UIButton){
        sender.pulsate()
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        let SVC = Storyboard.instantiateViewController(withIdentifier: "PBsViewController") as! PBsViewController
        SVC.username = self.username
        self.navigationController?.pushViewController(SVC, animated: true)
    }
    
    @IBAction func viewRequests(_ sender:UIButton){
        sender.pulsate()
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        let SVC = Storyboard.instantiateViewController(withIdentifier: "RequestsViewController") as! RequestsViewController
        SVC.requesters = self.requesters
        SVC.requestKeys = self.requestKeys
        SVC.username = self.username
        self.navigationController?.pushViewController(SVC, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DBRef = Database.database().reference()
        
        
        self.username = PlayerActivityViewController.username
        self.usernameLabel.text = "@\(PlayerActivityViewController.username ?? "@username")"
        //self.acceptRequestButton.isHidden = true
    }
    
    
    func requests(){
        self.requesters.removeAll()
        self.requestKeys.removeAll()
        var requestCount = 0
        self.DBRef.child("users").observe(.childAdded, with: { (snapshot) in
            if let snap = snapshot.value as? [String:Any]{
                if snap["admin"] as! Bool == true{
                    if let playerSnap = snap["players"] as? [String:Any]{
                        if let requests = playerSnap["requested"] as? [String]{
                            if requests.contains(self.username){
                                requestCount = requestCount + 1
                                let coach = snap["username"] as! String
                                self.requesters.append(coach)
                                self.requestKeys.append(snapshot.key)
                                //self.adminLabel.text = "you have \(requestCount) new requests"
                                //self.acceptRequestButton.isHidden = false
                            }
                            else{
                                //self.adminLabel.text = "You don't have any new requests."
                               //self.acceptRequestButton.isHidden = true
                            }
                        }
                        else{
                            //self.adminLabel.text = "You don't have any new requests."
                            //self.acceptRequestButton.isHidden = true
                        }
                    }
                }
            }
        }, withCancel: nil)
    }
    
    func loadUserInfo(){
        var coachName:String!
        self.DBRef.child("users").child(userID!).observe(.value) { (snapshot) in
            if let snap = snapshot.value as? [String:Any]{
                let first = snap["firstName"] as? String ?? "FIRST"
                let last = snap["lastName"] as? String ?? "LAST"
                self.nameLabel.text = "\(first) \(last)"
                self.emailLabel.text = snap["email"] as? String
                let counted = snap["numberOfCompletes"] as? Int
                self.countedLabel.text = "\(counted ?? 0)"
                coachName = snap["coachName"] as? String ?? ""
                //self.coachUsernameLabel.text = "@\(coachName!)"
            }
        }
        
        self.DBRef.child("users").observe(.childAdded, with: { (snapshot) in
            if let snap = snapshot.value as? [String:Any]{
                let x = snap["username"] as! String
                if (x.contains(coachName)){
                    self.adminKey = snapshot.key
                    self.DBRef.child("users").child(self.adminKey).observe(.value, with: { (snapshot) in
                        if let snap = snapshot.value as? [String:Any]{
                            let first = snap["firstName"] as? String ?? "First"
                            let last = snap["lastName"] as? String ?? "Last"
                            self.coachNameLabel.text = "\(first) \(last)"
                            let username = snap["username"] as? String
                            self.coachUsernameLabel.text = "@\(username ?? "")"
                            self.coachEmailLabel.text = snap["email"] as? String
                        }
                    }, withCancel: nil)
                }
            }
        }, withCancel: nil)
        
    }
    
    func loadScores(){
        score.removeAll()
        if ScoreRef != nil {
            ScoreRef.observe(.value) { (snapshot) in
                self.ScoreRef.observe(.value, with: { (snapshot) in
                    if let snap = snapshot.value as? [String:AnyObject]{
                        self.score.append(snap)
                        self.calcValues()
                    }
                }, withCancel: nil)
            }
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
        if PlayerActivityViewController.coachName != nil {
            ScoreRef = Database.database().reference().child("Scores").child(PlayerActivityViewController.coachName).child(username)
        }
        loadUserInfo()
        requests()
        loadScores()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }


}
