//
//  CheckInViewModel.swift
//  Checklist
//
//  Created by Muaaz Ahmad on 23/06/2021.
//

import Foundation
import SwiftyJSON

class CheckInViewModel {
    
    var id: Int
    var userId : Int
    var customerName : String
    var registrationNumber : String
    var checkIn : String
    var checkOut : String
    var createdAt : String
    
    init() {
        self.id = 0
        self.userId = 0
        self.customerName = ""
        self.registrationNumber = ""
        self.checkIn = ""
        self.checkOut = ""
        self.createdAt = ""
    }
    
    init(obj: JSON) {
        self.id = obj["id"].int ?? 0
        self.userId = obj["user_id"].int ?? 0
        self.customerName = obj["customer_name"].string ?? ""
        self.registrationNumber = obj["registration_number"].string ?? ""
        self.checkIn = obj["check_in"].string ?? ""
        self.checkOut = obj["check_out"].string ?? ""
        self.createdAt = obj["created_at"].string ?? ""
    }
}



/*
 {
 "message": "Technician check in Successfully!",
 "code": 200,
 "data": {
 "id": 27,
 "user_id": 13,
 "customer_name": "JohnVick",
 "registration_number": "5435311",
 "check_in": "2021-06-23 10:27:23",
 "check_out": null,
 "created_at": "June, 2021"
 }
 }
 
 */
