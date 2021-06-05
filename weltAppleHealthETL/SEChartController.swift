//
//  SEChartController.swift
//  weltAppleHealthETL
//
//  Created by jo on 2021/05/22.
//

import Charts
import UIKit

class SEChartController: UIViewController, ChartViewDelegate, UITextViewDelegate {
    var textView = UITextView()
    var lineChartView = LineChartView()
    var analysisList = [SleepAnalysis]()
    var graphArray = [String]()
    var label = UILabel()
    var lineChartDataSet = LineChartDataSet()
    var average = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
        lineChartView.delegate = self
        textView.delegate = self
        self.title = "SE Graph"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        label.frame = CGRect(x: 10, y: self.view.frame.size.width+250, width: self.view.frame.size.width-20, height: 150)
        label.text = "수면효율 동향을 파악하고 싶으면\n일자별 그래프를 터치하세요"
        label.backgroundColor = .white
        label.layer.borderWidth = 2
        label.layer.borderColor = UIColor.black.cgColor
        label.textColor = .black
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.numberOfLines = 0
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 5.0
        label.shadowColor = .lightGray
        label.textAlignment = .center
        
        //textView.frame = CGRect(x: 0, y: self.view.frame.size.width+100, width: self.view.frame.size.width, height: 100)
        lineChartView.frame = CGRect(x: 0, y: 200, width: self.view.frame.size.width, height: self.view.frame.size.width)
        //lineChartView.center = view.center
        view.addSubview(lineChartView)
        view.addSubview(label)
        
        
        var entries = [ChartDataEntry]()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd"
  
        var sum  = 0.0
        for x in 0..<analysisList.count{
            let component = Calendar.current.dateComponents([.month, .day, .hour, .minute], from: analysisList[x].sleepAsleepList[0].startDate)
            let xvalue = Double(component.day!)
            print(xvalue)
            let rand = Int.random(in: 0...10)
            let lineDataEntry = BarChartDataEntry(x: xvalue, y: analysisList[x].sleepEfficiency*100)
            let monthDay = dateFormatter.string(from: analysisList[x].sleepAsleepList[0].startDate)
            graphArray.append(monthDay)
            print(graphArray.last)
            entries.append(lineDataEntry)
            sum += analysisList[x].sleepEfficiency*100
        }
        average = (sum)/Double(analysisList.count)
        
        lineChartDataSet = LineChartDataSet(entries: entries, label: "수면효율[%]")
        lineChartDataSet.colors = [.gray]
        lineChartDataSet.circleColors = [.gray]
        lineChartDataSet.lineWidth = 3.0
        lineChartDataSet.circleHoleRadius = 3.0
        lineChartDataSet.circleRadius = 3.0
        lineChartDataSet.mode = .cubicBezier
        
        let ll = ChartLimitLine(limit: average, label: "수면효율 평균")
        
        
        let lineChartData = LineChartData(dataSet: lineChartDataSet)
        lineChartView.data = lineChartData
        lineChartView.leftAxis.addLimitLine(ll)
        lineChartView.leftAxis.axisMaximum = 100
        lineChartView.leftAxis.axisMinimum = 0
        
        lineChartView.animate(xAxisDuration: 2.0,yAxisDuration: 2.0)
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        guard let dataSet = chartView.data?.dataSets[highlight.dataSetIndex] else {
            return
        }
        let entryIndex = dataSet.entryIndex(entry: entry)
        print(lineChartDataSet.entries[entryIndex].y)
        let calc = average-lineChartDataSet.entries[entryIndex].y
        if calc<0 {
            let calcStr = String(abs(Int(calc)))
            let str = String(Int(lineChartDataSet.entries[entryIndex].x)).appending("일").appending(" 평균보다 \n").appending(calcStr).appending("% 높습니다\n현재 패턴을 유지하세요!")
            label.text = str
        }else if calc>0{
            let calcStr = String(abs(Int(calc)))
            
            let freq = String(analysisList[entryIndex].frequencyWakeUp)
            let str = String(Int(lineChartDataSet.entries[entryIndex].x)).appending("일").appending(" 평균보다 \n").appending(calcStr).appending("% 낮습니다\n")
                .appending("취침중 ").appending(freq).appending("번 깼습니다.\n 운동을 해보세요!")
            label.text = str
        }else{
            let calcStr = String(abs(Int(calc)))
            let str = String(Int(lineChartDataSet.entries[entryIndex].x)).appending("일").appending(" 평균입니다. \n").appending(calcStr).appending("% 낮습니다")
            label.text = str
        }
       
        
    }
    
}
