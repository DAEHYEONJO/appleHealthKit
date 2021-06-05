//
//  InbedPost.swift
//  weltAppleHealthETL
//
//  Created by jo on 2021/05/26.
//

class InbedPost : Codable {
    var date:String
    var startTime: String
    var endTime: String
    init(date : String, s : String, e : String) {
        self.date = date
        self.startTime = s
        self.endTime = e
    }
}

