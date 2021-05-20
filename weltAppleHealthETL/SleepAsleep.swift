//
//  SleepAsleep.swift
//  weltAppleHealthETL
//
//  Created by jo on 2021/05/08.
//

import Foundation

class SleepAsleep{
    var startDate:Date
    var endDate:Date
    var sleepTimeForOneDay:TimeInterval
    init(_ startDate:Date, _ endDate:Date, _ sleepTimeForOneDay:TimeInterval){
        self.startDate=startDate
        self.endDate=endDate
        self.sleepTimeForOneDay=sleepTimeForOneDay
    }
}

