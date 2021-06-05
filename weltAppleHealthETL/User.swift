//
//  User.swift
//  weltAppleHealthETL
//
//  Created by jo on 2021/05/26.
//

class User:Codable{
    var sourceId : String
    var device : String
    init(id : String = "", device : String = "") {
        self.sourceId = id
        self.device = device
    }
}



