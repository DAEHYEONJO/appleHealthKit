//
//  SleepInBed.swift
//  weltAppleHealthETL
//
//  Created by jo on 2021/04/28.
//

import Foundation

class SleepInBed{
    var startDate:Date
    var endDate:Date
    var sleepTimeForOneDay:TimeInterval
    init(_ startDate:Date,_ endDate:Date,_ sleepTimeForOneDay:TimeInterval){
        self.startDate=startDate
        self.endDate=endDate
        self.sleepTimeForOneDay=sleepTimeForOneDay
    }
}
