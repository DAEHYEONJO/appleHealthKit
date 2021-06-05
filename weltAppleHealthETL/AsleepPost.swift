//
//  AsleepPost.swift
//  weltAppleHealthETL
//
//  Created by jo on 2021/05/26.
//

class AsleepPost:Codable {
    var date : String
    var startTime : String
    var endTime : String
    
    init(d : String, s : String, e : String) {
        self.date = d
        self.startTime = s
        self.endTime = e
    }
}
