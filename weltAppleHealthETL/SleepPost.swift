//
//  SleepPost.swift
//  weltAppleHealthETL
//
//  Created by jo on 2021/05/26.
//

class SleepPost : Codable {
    var date : String
    var tib : Int
    var tst : Int
    var sol : Int
    var tasafa : Int
    var freqWake : Int
    var waso : Int
    var se : Double
    
    init(date : String, tib : Int, tst : Int, sol : Int, tasafa : Int, freqWake : Int, waso : Int, se : Double) {
        self.date = date
        self.tib = tib
        self.tst = tst
        self.sol = sol
        self.tasafa = tasafa
        self.freqWake = freqWake
        self.waso = waso
        self.se = se
    }
}

