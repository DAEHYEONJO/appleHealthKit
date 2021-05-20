//
//  AnalysisController.swift
//  weltAppleHealthETL
//
//  Created by jo on 2021/05/15.
//

import UIKit

class AnalysisController : UIViewController {
  
    
    @IBOutlet var tableView:UITableView!
    
    var analysisList = [SleepAnalysis]()
    
    override func viewDidLoad() {
        print("전달받음 : \(analysisList.count)")
        
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension AnalysisController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("tap ")
    }
}

extension AnalysisController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 450
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return analysisList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        let ds1 = dateFormatter.string(from: analysisList[indexPath.row].sleepInBed.startDate)//한국시간으로 변경
        let ds2 = dateFormatter.string(from: analysisList[indexPath.row].sleepInBed.endDate)//한국시간으로 변경
        
        cell.inbedText.text = " inbed (start date ~ end date)"
        cell.inbedInfo.text = ds1.appending(" ~ ").appending(ds2)
        cell.asleepText.text = " asleep (start date ~ end date)"
        
        var text = ""
        for i in analysisList[indexPath.row].sleepAsleepList{
            let start = dateFormatter.string(from: i.startDate)
            let end = dateFormatter.string(from: i.endDate)
            text.append("\(start) ~ \(end) \n")
        }
        cell.asleepInfo.text = text
        cell.inbedTotalTime.text = "TIB : ".appending(String(analysisList[indexPath.row].TIB)).appending("[s]")
        cell.asleepTotalTime.text = "TST : ".appending(String(analysisList[indexPath.row].TST)).appending("[s]")
        cell.sol.text = "SOL : ".appending( String(analysisList[indexPath.row].SOL)).appending("[s]")
        cell.waso.text = "WASO : ".appending(String(analysisList[indexPath.row].WASO)).appending("[s]")
        cell.frequency.text = "Freq : ".appending(String(analysisList[indexPath.row].frequencyWakeUp)).appending("번")
        cell.tasafa.text = "TASAFA : ".appending(String(analysisList[indexPath.row].TASAFA)).appending("[s]")
        cell.se.text = "SE : ".appending(String(analysisList[indexPath.row].sleepEfficiency*100)).appending("[%]")
        
        return cell
    }
    
}

