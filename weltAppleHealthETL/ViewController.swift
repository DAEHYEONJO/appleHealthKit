//
//  ViewController.swift
//  weltAppleHealthETL
//
//  Created by SangHyuk Lee on 2021/04/20.
//

import UIKit
import HealthKit

class ViewController: UIViewController {
    
    //MARK: - Variable
    let healthStore = HKHealthStore()
    var sleepInBedList=[SleepInBed]()
    
    //MARK: - Outlet
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var getHKPermissionButton: UIButton!
    @IBOutlet weak var HKPermissionCheckButton: UIButton!
    @IBOutlet weak var showDataButton: UIButton!
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setView()
    }
    
    //MARK: - Function
    
    /// # 뷰의 기본 세팅
    ///
    /// - Authors: Jack
    /// - Date: 2021-04-20
    /// - Requires: View 에 초기 상태를 설정한다.
    /// - Important: View 에 처음 진입할 때 한 번만 실행된다.
    /// - Returns: 라벨과 버튼의 UI가 설정한대로 변경된다.
    func setView() {
        // resultLabel
        resultLabel.text = "-"
        resultLabel.textAlignment = .center
        
        // getHKPermissionButton
        getHKPermissionButton.setTitle("GET HK PERMISSION", for: .normal)
        getHKPermissionButton.setTitleColor(.white, for: .normal)
        getHKPermissionButton.backgroundColor = .black
        
        //HKPermissionCheckButton
        HKPermissionCheckButton.setTitle("PERMISSION CHECK", for: .normal)
        HKPermissionCheckButton.setTitleColor(.white, for: .normal)
        HKPermissionCheckButton.backgroundColor = .black
        
    }
    
    /// # 결과 라벨 세팅
    ///
    /// - Authors: Jack
    /// - Date: 2021-04-20
    /// - Requires: resultLabel 의 텍스트와 텍스트 색상을 지정한다.
    /// - Parameters:
    ///     - text: 텍스트 내용을 입력한다.
    ///     - color : 텍스트의 색상을 지정한다.
    /// - Returns: result 라벨의 텍스트와 색상이 지정한대로 변경된다.
    func setResultLabel(_ text: String, _ color: UIColor) {
        resultLabel.text = text
        resultLabel.textColor = color
    }

    //MARK: - Action
    
    /// # 헬스킷 권한 얻어오기
    ///
    /// - Authors: Jack
    /// - Date: 2021-04-20
    /// - Requires: 버튼을 눌러 Health Kit 데이터의 읽기/쓰기 권한을 요청한다.
    @IBAction func getHKPermission (_ sender: UIButton) {
        let healthKitTypes: Set = [
            HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis)!,
            HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepChanges)!,
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!,
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
            HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.restingHeartRate)!,
        ]
        healthStore.requestAuthorization(toShare: healthKitTypes, read: healthKitTypes) { (Bool, error) in
            if let error = error {
                print("Health Kit authorisation error : \(error)")
            } else {
                print("Health Kit authorisation complete")
                //TODO: - 이미 권한을 거부했다면 설정 페이지로 이동시켜 권한을 허락하도록 하면 좋다.
            }
        }
    }
    
    /// # 헬스킷 권한 확인
    ///
    /// - Authors: Jack
    /// - Date: 2021-04-20
    /// - Requires: Health Kit 데이터에 대한 권한이 있는지 확인한다.
    /// - Returns: 확인 결과가 Alert 로 출력되며, result Label 의 텍스트와 색상이 변경된다.
    @IBAction func HKPermissionCheckAction (_ sender: UIButton) {
        if HKHealthStore.isHealthDataAvailable() {
            var title = ""
            var message = ""
            let authorizationStatus = healthStore.authorizationStatus(for: HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis)!)
            
            if authorizationStatus == .sharingAuthorized {
                title = "SUCCESS"
                message = "Permission Granted to Access Sleep Analysis"
                setResultLabel(title, .green)
            } else {
                title = "FAIL"
                message = "Permission Denied to Access Sleep Analysis"
                setResultLabel(title, .red)
            }
            let alert = UIAlertController.alertWithMessage(title, message)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //TODO: - Health Kit을 이용하여 Sleep Analysis 권한으로 가져올 수 있는 데이터 Query 로 가져오기
    //TODO: - Health Kit에 Sleep Analysis 외 다른 권한을 요청하고, Query 로 데이터 가져오기
    

    @IBAction func showData(_ sender: Any) {
        print("ㅇㅇ")
        let calendar = NSCalendar.current
        let now = Date(timeIntervalSinceReferenceDate: 0)
        let components = calendar.dateComponents([.year, .month, .day], from: now)
            
        guard let startDate = calendar.date(from: components) else {
            return
        }
         
        guard let endDate = calendar.date(byAdding: .day, value: 1, to: startDate) else {
            return
        }

        let today = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [])
        guard let sleepType = HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis) else {
            return
        }
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
        let sleepQuery = HKSampleQuery(sampleType: sleepType, predicate: nil, limit: Int(HKObjectQueryNoLimit), sortDescriptors: [sortDescriptor]){(query, tmpResult, error) in

            if error != nil{
                print(error)
                return
            }
            if let result = tmpResult {
                for item in result {

                    if let sample = item as? HKCategorySample {
                        let startDate = sample.startDate
                        let endDate = sample.endDate
                        print(startDate)
                        print(endDate)
                        let sleepTimeForOneDay = sample.endDate.timeIntervalSince(sample.startDate)
                        print(sleepTimeForOneDay)
                        self.sleepInBedList.append(SleepInBed(startDate: startDate, endDate: endDate, sleepTimeForOneDay: sleepTimeForOneDay))

                    }
                }
            }
//
//            let encoder = JSONEncoder()
//            encoder.outputFormatting = .prettyPrinted
//            let data = try! encoder.encode(sleepInBedList[0])
//            print(String(data: data, encoding: .utf8)!)
        }
        healthStore.execute(sleepQuery)
        // sleepAnalysissleepAnalysissleepAnalysissleepAnalysissleepAnalysissleepAnalysissleepAnalysissleepAnalysissleepAnalysis
        
        guard let walkRunDisttype = HKSampleType.quantityType(forIdentifier: .distanceWalkingRunning) else { return}
        guard let stepType = HKSampleType.quantityType(forIdentifier: .stepCount) else {return}
      
        let now2 = Date(timeIntervalSinceReferenceDate: 0)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let date = dateFormatter.date(from: "2021-01-01 00:00:00") else {return}
        print("hihi : \(date)")
       
        for i in 1 ... 300{
            guard let start=Calendar.current.date(byAdding: .day, value: i, to: date) else {return}
            guard let end = Calendar.current.date(byAdding: .day, value: i+1, to: date) else {return}
            let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: [])
            let query = HKStatisticsQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum){ query, results, error in
                    if let result = results{
                        let sum = result.sumQuantity()
                        let total = sum?.doubleValue(for: HKUnit.count())
                        print(start)
                        print(end)
                        print(total)
                    }
            } //HKSampleQuery()
            healthStore.execute(query)
            let walkRunQuery = HKStatisticsQuery(quantityType: walkRunDisttype, quantitySamplePredicate: predicate, options: [.cumulativeSum]) {
                (query, statistics, error) in
                var value: Double = 0
                if error != nil {
                    return
                } else if let quantity = statistics?.sumQuantity() {
                    value = quantity.doubleValue(for: HKUnit.meter())
                    print("distanceWalkingRunning : \(value/1000)")
                }
            
            }
            healthStore.execute(walkRunQuery)
            
        }
        
    }
    

}

