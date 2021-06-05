//
//  ViewController.swift
//  weltAppleHealthETL
//
//  Created by SangHyuk Lee on 2021/04/20.
//

import UIKit
import HealthKit

import Foundation
	

class ViewController: UIViewController {
    
    //MARK: - Variable
    let healthStore = HKHealthStore()
    var inbedList = [SleepInBed]()//health앱에서 추출한 모든 inbed 시간들
    var asleepList = [SleepAsleep]()//health앱에서 추출한 모든 asleep 시간들
    var analysisList = [SleepAnalysis]()//최종 sleep 저장할 리스트
    var oneDayInbedList = [SleepInBed]()
    var oneDayAsleepList = [SleepAsleep]()
    var user = User()
    
    var asleepTemp = [SleepAsleep]()
    var asleepPost = [AsleepPost]()
    var sleepPost = [SleepPost]()
    
    let userURL = "https://api-prod.weltcorp.com/welt-i/v1/healthkit/users"
    let asleepURL = "https://api-prod.weltcorp.com/welt-i/v1/healthkit/asleeps/users/32"
    let inbedURL = "https://api-prod.weltcorp.com/welt-i/v1/healthkit/inbeds/users/32"
    let sleepURL = "https://api-prod.weltcorp.com/welt-i/v1/healthkit/sleeps/users/32"
    
    //MARK: - Outlet
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var getHKPermissionButton: UIButton!
    @IBOutlet weak var HKPermissionCheckButton: UIButton!
    @IBOutlet weak var showDataButton: UIButton!
    @IBOutlet weak var goToAnalysisBtn: UIButton!
    @IBOutlet weak var sleepChartBtn: UIButton!
    @IBOutlet weak var seChartBtn: UIButton!
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
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKObjectType.workoutType(),
            HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepChanges)!,
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!,
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
            HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.restingHeartRate)!,
            HKObjectType.quantityType(forIdentifier: .walkingStepLength)!,
            HKObjectType.quantityType(forIdentifier: .walkingSpeed)!,
            HKObjectType.quantityType(forIdentifier: .walkingDoubleSupportPercentage)!
        ]
        healthStore.requestAuthorization(toShare: healthKitTypes, read: healthKitTypes) { (Bool, error) in
            if let error = error {
                print("Health Kit authorisation error : \(error)")
            } else {
                print("Health Kit authorisation complete")
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
    
    @IBAction func moveSleepAnalysis(_ sender: Any) {
        print("zmffsdfdafs")
        //storyboard find controller
        guard let vc = storyboard?.instantiateViewController(identifier: "AnalysisController") as? AnalysisController else {return}
        
        vc.analysisList = self.analysisList
        
        self.navigationController?.pushViewController(vc, animated: true)
        
//        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "AnalysisController") {
//            //push controller -> navi
//            self.navigationController?.pushViewController(controller, animated: true)
//        }
    }
    @IBAction func moveSleepChart(_ sender: Any) {
        guard let vc = storyboard?.instantiateViewController(identifier: "ChartController") as? ChartController else {return}
        vc.analysisList = self.analysisList
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func moveSEChart(_ sender: Any) {
        guard let vc = storyboard?.instantiateViewController(identifier: "SEChartController") as? SEChartController else {return}
        vc.analysisList = self.analysisList
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //TODO: - Health Kit을 이용하여 Sleep Analysis 권한으로 가져올 수 있는 데이터 Query 로 가져오기
    //TODO: - Health Kit에 Sleep Analysis 외 다른 권한을 요청하고, Query 로 데이터 가져오기
    

    
    func postToServer(parameters : String, url : String){

        let semaphore = DispatchSemaphore (value: 0)

        let postData = parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: url)!,timeoutInterval: Double.infinity)
        request.addValue("Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOjEsImlhdCI6MTYyMDg3NDkyNSwiZXhwIjoxODAwODc0OTI1LCJ0eXBlIjoiYWNjZXNzIn0.6VD5ZJPWGlgzKj8AKND8dllxmnOl4qFlD8WUac7NlMY", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            semaphore.signal()
            
            return
          }
            print("postToServer()")
          print(String(data: data, encoding: .utf8)!)
          semaphore.signal()
        }

        task.resume()
        semaphore.wait()

    }
    
    func calcEffeciency(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        var sum = 0
        var index = 0
        
        while index < inbedList.count {
            print("-------------------------------------")
            print(index)
            print(inbedList.count)
            let dateString = dateFormatter.string(from: inbedList[index].startDate)//한국시간으로 변경
            let dateString2 = dateFormatter.string(from: inbedList[index].endDate)//한국시간으로 변경
            
            let component = Calendar.current.dateComponents([.month, .day, .hour, .minute], from: inbedList[index].startDate)
            var j = index + 1
            var sameIndex = 0
            loop: while j < inbedList.count {
                print("j : \(j) index : \(index)")
                let dateString1 = dateFormatter.string(from: inbedList[j].startDate)//한국시간으로 변경
                let dateString3 = dateFormatter.string(from: inbedList[j].endDate)//한국시간으로 변경
                print("원래 : \(dateString) \(dateString2)// index : \(index)")
                print("비교: \(dateString1) \(dateString3)// j : \(j)")
                if j == index + 1{
                    sum+=Int(inbedList[j-1].sleepTimeForOneDay)
                }
                let component2 = Calendar.current.dateComponents([.month, .day, .hour, .minute], from: inbedList[j].startDate)
                if component.day == component2.day {
                    sameIndex+=1
                    if(j == inbedList.count-1){//마지막전껀데도 같으면 밑에 else에서 index+=(j-index-1)을 안해줌
                        index+=(j-index)
                    }
                    print("같음 day : \(component.day)\\\(component2.day) same Index : \(sameIndex)")
                    print("더할값 : \(inbedList[j].sleepTimeForOneDay)")
                    print("\(component2.day),\(component2.hour),\(component2.minute)")
                    sum += Int(inbedList[j].sleepTimeForOneDay)
                    print("sum : \(sum)")
                }else{
                    print("j-index-1 \(j-index-1)")
                    print("다름 day : \(component.day)\\\(component2.day)")
                    index+=(j-index-1)
                    print("index : \(index) ")
                    break loop
                }
                j+=1
            }
            print("sum전 index : \(index)")
            if sameIndex != 0 {
                print("같은거 있음 index-sameIndex : \(index-sameIndex) j-1 : \(j-1) sameIndex : \(sameIndex)")
                oneDayInbedList.append(SleepInBed(inbedList[index-sameIndex].startDate, inbedList[j-1].endDate, TimeInterval(sum)))
                let dateString5 = dateFormatter.string(from: oneDayInbedList.last!.startDate)//한국시간으로 변경
                let dateString6 = dateFormatter.string(from: oneDayInbedList.last!.endDate)//한국시간으로 변경
                print("temp : \(dateString5) end : \(dateString6) interval : \(oneDayInbedList.last!.sleepTimeForOneDay)")
                sum = 0
            }else{
                print("같은거없음")
                oneDayInbedList.append(SleepInBed(inbedList[index].startDate, inbedList[index].endDate, TimeInterval(inbedList[index].sleepTimeForOneDay)))
                let dateString5 = dateFormatter.string(from: inbedList[index].startDate)//한국시간으로 변경
                let dateString6 = dateFormatter.string(from: inbedList[index].endDate)//한국시간으로 변경
                print("temp : \(dateString5) end : \(dateString6) interval : \(inbedList[index].sleepTimeForOneDay)")
                sum = 0
            }
            index+=1
        }
        for i in oneDayInbedList{
            //하루하루 inbed에 대한 시작시간, 끝시간, 각 interval들의 합산값 저장된 리스트
            let dateString5 = dateFormatter.string(from: i.startDate)//한국시간으로 변경
            let dateString6 = dateFormatter.string(from: i.endDate)//한국시간으로 변경
            print("\(dateString5) ~ \(dateString6) : \(i.sleepTimeForOneDay)")
        }
        for i in asleepList{
            //health앱에서 추출한 asleep데이터들
            print("--------------------asleepList-------------------------")
            let dateString5 = dateFormatter.string(from: i.startDate)//한국시간으로 변경
            let dateString6 = dateFormatter.string(from: i.endDate)//한국시간으로 변경
            print("\(dateString5) ~ \(dateString6) : \(i.sleepTimeForOneDay)")
        }
        
        
        var asleepIndex = 0
        for i in 0 ..< oneDayInbedList.count{
            print("--------------------inbed & asleep find same day-------------------------")
            let component = Calendar.current.dateComponents([.month, .day, .hour, .minute], from: oneDayInbedList[i].startDate)
            let dateString5 = dateFormatter.string(from: oneDayInbedList[i].startDate)//한국시간으로 변경
            let dateString6 = dateFormatter.string(from: oneDayInbedList[i].endDate)//한국시간으로 변경
            var sameIndex = 0
            var analysis6 = 0
            var analysis4 = 0
            var analysis2 = 0
            var sum = 0
            asleepTemp.removeAll()
            whileLoop : while(asleepIndex < asleepList.count){
                let dateString7 = dateFormatter.string(from: asleepList[asleepIndex].startDate)//한국시간으로 변경
                print("비교 날짜 inbed: \(dateString5) asleep :\(dateString7) asleepIndex : \(asleepIndex)")
                let component2 = Calendar.current.dateComponents([.month, .day, .hour, .minute], from: asleepList[asleepIndex].startDate)
                if(component.month == component2.month && component.day == component2.day){
                    asleepTemp.append(SleepAsleep(asleepList[asleepIndex].startDate,asleepList[asleepIndex].endDate,asleepList[asleepIndex].sleepTimeForOneDay))//inbed에 대한 모든 asleep 시간들 저장 리스트
                    sum += Int(asleepList[asleepIndex].endDate.timeIntervalSince(asleepList[asleepIndex].startDate))
                    if(sameIndex == 0){
                        analysis6 = Int(asleepList[asleepIndex].startDate.timeIntervalSince(oneDayInbedList[i].startDate))//첫 inbed~ 첫 asleep
                        print("analysis6 : \(analysis6)")
                    }else{
                        
                    }
                    print("같은 날짜임 inbed: \(dateString5) asleep :\(dateString7)")
                    sameIndex+=1
                }else{
                    print("다른 asleepIndex : \(asleepIndex)")
                    if(sameIndex == 0){
                        //아무것도 같은게 없었던 경우
                        
                    }else{
                        //같은게 있었던 경우
                        let ds1 = dateFormatter.string(from: oneDayInbedList[i].endDate)//한국시간으로 변경
                        let ds2 = dateFormatter.string(from: asleepList[asleepIndex-1].endDate)//한국시간으로 변경
                        analysis4 = Int(oneDayInbedList[i].endDate.timeIntervalSince(asleepList[asleepIndex-1].endDate))//마지막 asleep ~ 마지막 inbed
                        analysis2 = sum
                        print("analysis4 마지막 asleep : \(ds2) 마지막 inbed : \(ds1) interval : \(analysis4) 총 asleep : \(analysis2)")
                        print("같은게 있었던 경우 asleepIndex: \(asleepIndex) sameIndex :\(sameIndex)")
                        oneDayAsleepList.append(SleepAsleep(asleepTemp[0].startDate,asleepTemp.last!.endDate,TimeInterval(analysis2)))
                        var isum = 0
                        for t in 0 ..< asleepTemp.count - 1{
                            var interval = Int(asleepTemp[t+1].startDate.timeIntervalSince(asleepTemp[t].startDate))//asleep~asleep사이시간
                            isum += interval
                            let ds1 = dateFormatter.string(from: asleepTemp[t+1].startDate)//한국시간으로 변경
                            let ds2 = dateFormatter.string(from: asleepTemp[t].endDate)//한국시간으로 변경
                            print("지금끝시간 : \(ds2) 다음시작 : \(ds1) interval : \(interval)")
                        }
                       
                        let dse = Double(analysis6+analysis2+isum+analysis4)
                        let se = Double(analysis2)/dse
                        print("se : \(se)")
                        analysisList.append(SleepAnalysis(inbed: oneDayInbedList[i], asleepList: asleepTemp, tib: Int(oneDayInbedList[i].sleepTimeForOneDay), tst: analysis2, sol: analysis6, tasafa: analysis4, frequncy: sameIndex-1, waso: isum ,eff: se))
                    }
                    //0 1 2 3 4
                    break whileLoop
                }
                if(asleepIndex == asleepList.count - 1){
                    let ds1 = dateFormatter.string(from: oneDayInbedList[i].endDate)//한국시간으로 변경
                    let ds2 = dateFormatter.string(from: asleepList[asleepIndex].endDate)//한국시간으로 변경
                    analysis4 = Int(oneDayInbedList[i].endDate.timeIntervalSince(asleepList[asleepIndex].endDate))//마지막 asleep ~ 마지막 inbed
                    analysis2 = sum
                    print("analysis4 마지막 asleep : \(ds2) 마지막 inbed : \(ds1) interval : \(analysis4) 총 asleep : \(analysis2)")
                    print("같은게 있었던 경우 asleepIndex: \(asleepIndex) sameIndex :\(sameIndex)")
                    var isum=0
                    for t in 0 ..< asleepTemp.count - 1{
                        var interval = Int(asleepTemp[t+1].startDate.timeIntervalSince(asleepTemp[t].startDate))//asleep~asleep사이시간
                        isum += interval
                        let ds1 = dateFormatter.string(from: asleepTemp[t+1].startDate)//한국시간으로 변경
                        let ds2 = dateFormatter.string(from: asleepTemp[t].endDate)//한국시간으로 변경
                        print("지금끝시간 : \(ds2) 다음시작 : \(ds1) interval : \(interval)")
                    }
                    let dse = Double(analysis6+analysis2+isum+analysis4)
                    let se = Double(analysis2)/dse
                    print("se : \(se)")
                    analysisList.append(SleepAnalysis(inbed: oneDayInbedList[i], asleepList: asleepTemp, tib: Int(oneDayInbedList[i].sleepTimeForOneDay), tst: analysis2, sol: analysis6, tasafa: analysis4, frequncy: sameIndex-1, waso: isum ,eff: se))
                   
                }
                asleepIndex += 1
            }
        }
        
        for i in analysisList{
            print("==============================수면분석==============================")
            let ds1 = dateFormatter.string(from: i.sleepInBed.startDate)//한국시간으로 변경
            let ds2 = dateFormatter.string(from: i.sleepInBed.endDate)//한국시간으로 변경
            print("inbed : \(ds1) ~ \(ds2) interval : \(i.sleepInBed.sleepTimeForOneDay) s")
            for j in i.sleepAsleepList{
                let ds3 = dateFormatter.string(from: j.startDate)//한국시간으로 변경
                let ds4 = dateFormatter.string(from: j.endDate)//한국시간으로 변경
                asleepPost.append(AsleepPost(d: String(ds3.split(separator: " ").first!), s: ds3, e: ds4))
                
                //----------------------------------------------//----------------------------------------------
                let encoder : JSONEncoder = JSONEncoder()
                encoder.outputFormatting = .prettyPrinted
                var returnValue : String = ""
                
                do {
                    let jsonData : Data = try encoder.encode(asleepPost.last)
                    if let jsonString = String(data: jsonData, encoding: .utf8){
                        returnValue = jsonString
                        print(returnValue)
                    }
                } catch {
                    print(error)
                }

                //postToServer(parameters: returnValue, url: asleepURL)
                

                //----------------------------------------------//----------------------------------------------
                print("asleep : \(ds3) ~ \(ds4) interval : \(j.sleepTimeForOneDay) s")
            }
            sleepPost.append(SleepPost(date: String(ds1.split(separator: " ").first!), tib: i.TIB, tst: i.TST, sol: i.SOL, tasafa: i.TASAFA, freqWake: i.frequencyWakeUp, waso: i.WASO, se: i.sleepEfficiency))
            
            let encoder : JSONEncoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            var returnValue2 : String = ""
            
            do {
                let jsonData : Data = try encoder.encode(sleepPost.last)
                if let jsonString = String(data: jsonData, encoding: .utf8){
                    returnValue2 = jsonString
                    print(returnValue2)
                }
            } catch {
                print(error)
            }
            //postToServer(parameters: returnValue2, url: sleepURL)
            print("불끄고 잠들때까지(SOL) : \(i.SOL)")
            print("완전히 깼는데 침대에 누워있던 시간(TASAFA) : \(i.TASAFA) s")
            print("중간에 깼다가 잠들때 까지 걸린 시간 합(WASO) : \(i.WASO) s")
            print("Asleep 시간 합(TST) : \(i.TST) s")
            print("Inbed 시간 합(TIB) : \(i.TIB) s")
            print("중간에 깬 횟수(frequencyWakeUp) : \(i.frequencyWakeUp) 번")
            print("수면효율[ TST/(SOL + TST + WASO + TASAFA) ] : \(i.sleepEfficiency * 100) %")
            showToast(message: "Request Complete")
        }
        
        for ast in asleepTemp {
            print("asleep Temp : \(ast.startDate)")
        }
    }
    
    func showToast(message : String) {
        let width_variable:CGFloat = 10
        let toastLabel = UILabel(frame: CGRect(x: width_variable, y: self.view.frame.size.height-100, width: view.frame.size.width-2*width_variable, height: 35))
            // 뷰가 위치할 위치를 지정해준다. 여기서는 아래로부터 100만큼 떨어져있고, 너비는 양쪽에 10만큼 여백을 가지며, 높이는 35로
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }

    
    @IBAction func showData(_ sender: Any) {
         
        inbedList.removeAll()
        asleepList.removeAll()
        analysisList.removeAll()
        oneDayInbedList.removeAll()
        oneDayAsleepList.removeAll()
        
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
        let sleepQuery = HKSampleQuery(sampleType: sleepType, predicate: nil, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]){(query, tmpResult, error) in
            if error != nil{
                print(error!)
                return
            }
            if let result = tmpResult {
                
                for item in result {
                    if let sample = item as? HKCategorySample {
                        print("--------------------------------")
                        var startDate = sample.startDate
                        //startDate.addTimeInterval(32400) 진짜 한국 시간 안넣은것임
                        var endDate = sample.endDate
                        //endDate.addTimeInterval(32400)
                        let sleepTimeForOneDay = sample.endDate.timeIntervalSince(sample.startDate)
                        if(sample.value == HKCategoryValueSleepAnalysis.inBed.rawValue){
                            print("inbed time")
                            self.inbedList.append(SleepInBed(startDate,endDate,sleepTimeForOneDay))
                        }else{
                            print("asleep time")
                            self.asleepList.append(SleepAsleep(startDate,endDate,sleepTimeForOneDay))
                        }
                        //print("start date : \(startDate)")
                        //print("endDate date : \(endDate)")
                        //print("interval : \(sleepTimeForOneDay)")
                    }
                }
            }
            
        }
        healthStore.execute(sleepQuery)
        
        //
        //            let encoder = JSONEncoder()
        //            encoder.outputFormatting = .prettyPrinted
        //            let data = try! encoder.encode(sleepInBedList[0])
        //            print(String(data: data, encoding: .utf8)!)
        // sleepAnalysissleepAnalysissleepAnalysissleepAnalysissleepAnalysissleepAnalysissleepAnalysissleepAnalysissleepAnalysis
        
        guard let walkRunDisttype = HKSampleType.quantityType(forIdentifier: .distanceWalkingRunning) else { return}
        guard let stepType = HKSampleType.quantityType(forIdentifier: .stepCount) else {return}
        guard let activeEnergy = HKSampleType.quantityType(forIdentifier: .activeEnergyBurned) else {return}
        guard let activeTime = HKSampleType.quantityType(forIdentifier: .appleExerciseTime) else {return}
        guard let heartRate = HKSampleType.quantityType(forIdentifier: .heartRate) else {return}
        guard let walkingStepLength = HKSampleType.quantityType(forIdentifier: .walkingStepLength)else{return}//보폭
        guard let walkingSpeed = HKSampleType.quantityType(forIdentifier: .walkingSpeed) else {return}//보행속도
        guard let walkingDoubleSupportPercentage = HKSampleType.quantityType(forIdentifier: .walkingDoubleSupportPercentage) else {return} //이중지지시간
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard var date = dateFormatter.date(from: "2021-01-01 00:00:00") else {return}
        print("hihi : \(date)")
        guard var date2 = dateFormatter.date(from: "2021-01-02 01:00:00") else {return}
        print("hihi : \(date2)")
        var itv = date2.timeIntervalSince(date)
        print(itv)
        date2.addTimeInterval(32400)
        print("hihi : \(date2)")
        
        for i in 1 ... 300{
            guard let start=Calendar.current.date(byAdding: .day, value: i, to: date) else {return}
            guard let end = Calendar.current.date(byAdding: .day, value: i+1, to: date) else {return}
            //print("start \(start) end \(end)")
            let s1 = dateFormatter.string(from: start)//한국시간으로 변경
            let e1 = dateFormatter.string(from: end)//한국시간으로 변경
            let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: [])
            let query = HKStatisticsQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum){ query, results, error in
                if let result = results{
                    let sum = result.sumQuantity()
                    guard let total = sum?.doubleValue(for: HKUnit.count()) else {return}
                }
            }
            
            //healthStore.execute(query)
            let walkRunQuery = HKStatisticsQuery(quantityType: walkRunDisttype, quantitySamplePredicate: predicate, options: [.cumulativeSum]) {
                (query, statistics, error) in
                var value: Double = 0
                if error != nil {
                    return
                } else if let quantity = statistics?.sumQuantity(){
                    value = quantity.doubleValue(for: HKUnit.meter())
                    print("start date : \(s1)")
                    print("걷고 달린 거리 : \(value/1000)")
                    print("end date : \(e1)")
                    print("---------------------------------\n")
                }
                
            }
            //healthStore.execute(walkRunQuery)
            
            let activeEnergyQuery = HKStatisticsQuery(quantityType: activeEnergy, quantitySamplePredicate: predicate, options: [.cumulativeSum]) {
                (query, statistics, error) in
                var value : Double = 0
                if error != nil {
                    return
                }else if let quantity = statistics?.sumQuantity(){
                    value = quantity.doubleValue(for: HKUnit.largeCalorie())
                    
                    print("start date : \(s1)")
                    print("칼로리소모량 : \(value)")
                    print("end date : \(e1)")
                    print("---------------------------------\n")
                    
                }
            }
            //healthStore.execute(activeEnergyQuery)
            
            let heartRateQuery = HKSampleQuery(sampleType: heartRate, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: []){
                (query, results, error) in
                guard error == nil else { print("error"); return }
                
                for (_, sample) in results!.enumerated() {
                    guard let currData:HKQuantitySample = sample as? HKQuantitySample else { return }
                    let s = dateFormatter.string(from: currData.startDate)//한국시간으로 변경
                    let e = dateFormatter.string(from: currData.endDate)//한국시간으로 변경
                    print("심박수: \(currData.quantity.doubleValue(for: HKUnit(from: "count/min")))")
                    print("Start Date: \(s)")
                    print("End Date: \(e)")
                    print("---------------------------------\n")
                    }
                
            }
            healthStore.execute(heartRateQuery)
            
            let walkingStepLengthQuery = HKSampleQuery(sampleType: walkingStepLength, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: []) {
                (query, results, error) in
                guard error == nil else { print("walking step length query error"); return }
                
                for (_, sample) in results!.enumerated() {
                    guard let currData:HKQuantitySample = sample as? HKQuantitySample else { return }
                    let s = dateFormatter.string(from: currData.startDate)//한국시간으로 변경
                    let e = dateFormatter.string(from: currData.endDate)//한국시간으로 변경
                    print("보폭 : \(currData.quantity.doubleValue(for: HKUnit.meter()))")
                    print("Start Date: \(s)")
                    print("End Date: \(e)")
                    print("---------------------------------\n")
                }
               
            }
            //healthStore.execute(walkingStepLengthQuery)
            
            let walkingSpeedQuery = HKSampleQuery(sampleType: walkingSpeed, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: []){
                (query, results, error) in
                guard error == nil else { print("walking Speed Query error"); return }
                
                for (_, sample) in results!.enumerated() {
                    
                    guard let currData:HKQuantitySample = sample as? HKQuantitySample else { return }
                    let s = dateFormatter.string(from: currData.startDate)//한국시간으로 변경
                    let e = dateFormatter.string(from: currData.endDate)//한국시간으로 변경
                    print("보행속도 : \(currData.quantity.doubleValue(for: HKUnit(from: "m/s")))")
                    print("Start Date: \(s)")
                    print("End Date: \(e)")
                    print("---------------------------------\n")
                }
            }
            //healthStore.execute(walkingSpeedQuery)
        
            let walkingDoubleSupportPercentageQuery = HKSampleQuery(sampleType: walkingDoubleSupportPercentage, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: []){
                (query, results, error) in
                guard error == nil else { print("walking Double Support Percentage Query error"); return }
                
                for (_, sample) in results!.enumerated() {
                    
                    guard let currData:HKQuantitySample = sample as? HKQuantitySample else { return }
                    let s = dateFormatter.string(from: currData.startDate)//한국시간으로 변경
                    let e = dateFormatter.string(from: currData.endDate)//한국시간으로 변경
                    //print("이중지지시간 : \(currData.quantity.doubleValue(for: HKUnit.percent()))")
                    //print("Start Date: \(s)")
                    //print("End Date: \(e)")
                    //print("---------------------------------\n")
                   
                    //print("device name : \(sample.sourceRevision.source.name)")
                    //print("bundle : \(sample.sourceRevision.source.bundleIdentifier)")
                    guard let deviceType = sample.device?.name else {return}
                    //print("device type : \(deviceType)")
                    self.user = User(id:sample.sourceRevision.source.name, device: deviceType)
                
                }
                
            }
            healthStore.execute(walkingDoubleSupportPercentageQuery)
        }
        

        guard let stepCountType = HKObjectType.quantityType(forIdentifier: .stepCount) else {return}
        let Source = HKSourceQuery(sampleType: stepCountType, samplePredicate: nil){(query, sourcesOrNil, errorOrNil) in
            guard let sources = sourcesOrNil else { return}
                
            for s in sources {
                print(s.name)
                print(s)
            }
                   
        }
        healthStore.execute(Source)
        
        calcEffeciency()
        //print(encodeToJson())
        changeToInbedPost()
        //postToServer(parameters: encodeToJson(), url: userURL)

       
        
    }
    
    func changeToInbedPost() {
        let encoder : JSONEncoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        var returnValue : String = ""
        
        var inbedPost = [InbedPost]()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        for i in oneDayInbedList {
            let startTime = dateFormatter.string(from: i.startDate)//한국시간으로 변경
            let endTime = dateFormatter.string(from: i.endDate)
            let date = startTime.split(separator: " ").first!
            print("한국날짜 : \(date)")
            inbedPost.append(InbedPost(date: String(date), s: startTime, e: endTime))
            
            do {
                let jsonData : Data = try encoder.encode(inbedPost.last)
                if let jsonString = String(data: jsonData, encoding: .utf8){
                    returnValue = jsonString
                    print("inbed json \(returnValue)")
                }
            } catch {
                print(error)
            }
            //postToServer(parameters: returnValue, url: inbedURL)
        }
      
    }
    
    func encodeToJson() -> String {
        let encoder : JSONEncoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        var returnValue : String = ""
        do {
            let jsonData : Data = try encoder.encode(user)
            if let jsonString = String(data: jsonData, encoding: .utf8){
                returnValue = jsonString
            }
        } catch {
            print(error)
        }
        return returnValue
    }
    
}


