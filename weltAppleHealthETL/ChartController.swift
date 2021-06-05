//
//  ChartController.swift
//  weltAppleHealthETL
//
//  Created by jo on 2021/05/22.
//

import UIKit
import Charts

class ChartController : UIViewController, ChartViewDelegate {
    var combineChartView = CombinedChartView()
    var label = UILabel()
    var analysisList = [SleepAnalysis]()
    
    var graphArray = [String]()
    var barDataEntries = [BarChartDataEntry]()
    var lineDataEntries = [ChartDataEntry]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        combineChartView.delegate = self
        self.title = "TIB TST Graph"
         
       
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        label.frame = CGRect(x: 10, y: self.view.frame.size.width+250, width: self.view.frame.size.width-20, height: 150)
        label.text = "취침 및 수면시간 동향을 파악하고 싶으면\n일자별 그래프를 터치하세요"
        label.backgroundColor = .white
        label.layer.borderWidth = 2
        label.layer.borderColor = UIColor.black.cgColor
        label.textColor = .black
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.numberOfLines = 0
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 5.0
        label.shadowColor = .lightGray
        label.textAlignment = .center
        
        
        combineChartView.frame = CGRect(x: 0, y: 200, width: self.view.frame.size.width, height: self.view.frame.size.width)
        combineChartView.center = view.center
        view.addSubview(combineChartView)
        view.addSubview(label)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd"
       
        for i in 0..<analysisList.count {
            let component = Calendar.current.dateComponents([.month, .day, .hour, .minute], from: analysisList[i].sleepAsleepList[0].startDate)
            let xvalue = Double(component.day!)
       
            
            let barDataEntry = BarChartDataEntry(x: xvalue, y: calcTime(s: analysisList[i].TIB))
            let lineDataEntry = ChartDataEntry(x: xvalue, y: calcTime(s: analysisList[i].TST))
            let monthDay = dateFormatter.string(from: analysisList[i].sleepAsleepList[0].startDate)
            graphArray.append(monthDay)
            barDataEntries.append(barDataEntry)
            lineDataEntries.append(lineDataEntry)
            
        }
        
        let barChartDataSet = BarChartDataSet(entries: barDataEntries, label: "취침시간[hours]")
        barChartDataSet.highlightAlpha = .infinity
        barChartDataSet.colors = [.lightGray]
        let lineChartDataSet = LineChartDataSet(entries: lineDataEntries, label: "수면시간[hours]")
        lineChartDataSet.colors = [.red]
        lineChartDataSet.circleColors = [.red]
        lineChartDataSet.lineWidth = 2.0
        lineChartDataSet.circleHoleRadius = 3.0
        lineChartDataSet.circleRadius = 3.0
        lineChartDataSet.mode = .cubicBezier

        let data : CombinedChartData = CombinedChartData()
        data.barData = BarChartData(dataSet: barChartDataSet)
        data.lineData = LineChartData(dataSet: lineChartDataSet)
        combineChartView.data = data
        
        combineChartView.xAxis.labelPosition = .bottom
        combineChartView.drawGridBackgroundEnabled = false
        combineChartView.animate(xAxisDuration: 2.0,yAxisDuration: 2.0)
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        
        guard let dataSet = chartView.data?.dataSets[highlight.dataSetIndex] else {
            return
        }
        var entryIndex = dataSet.entryIndex(entry: entry)
        if entryIndex == -1{
            entryIndex=analysisList.count-1
        }
            
        let tibStr = String(format: "%.2f",calcTime(s: Int(analysisList[entryIndex].TIB)))
        let tstStr = String(format: "%.2f", (entry.y))
        let str1 = "취침시간 : 침대에 누워있던 시간\n수면시간 : 실제 잠에 든 시간\n"
        let str = String(Int(entry.x)).appending("일").appending(" 취침시간은 약 ").appending(tibStr).appending("시간\n수면시간은 약 ").appending(tstStr).appending("시간 입니다.")
        let result = str1.appending(str)
        label.text = result
        print(entry)
    }
    
    func calcTime(s : Int) -> Double {
        let total = Double(s)
        let hour = total / 3600
        let min = (hour.truncatingRemainder(dividingBy: 60)) / 60
        
        return hour + min
    }
    
}
