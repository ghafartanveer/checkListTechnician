//
//  UserViewModel.swift
//  GirlsChase
//
//  Created by Rapidzz Macbook on 14/06/2019.
//  Copyright © 2019 Rapidzz. All rights reserved.
//

import Foundation
import SwiftyJSON

class UserViewModel: NSObject, NSCoding {
    
    var id: Int
    var storeID: Int
    var isBlock: Int
    var firstName: String
    var lastName: String
    var email : String
    var phoneNumber: String
    var image: String
    var loginType: String
    var token: String
    var createdAt: String
    var fcmToken: String
    
    
    override init(){
        self.id = 0
        self.storeID = 0
        self.isBlock = 0
        self.firstName = ""
        self.lastName = ""
        self.email = ""
        self.phoneNumber = ""
        self.image = ""
        self.loginType = ""
        self.token = ""
        self.createdAt = ""
        self.fcmToken = ""
    }
    
    convenience init(obj: JSON){
        self.init()
        self.id = obj["id"].int ?? 0
        
        //self.storeID = obj["store_id"].int ?? 0
        if let id = obj["store_id"].int{
            storeID = id
        }
        if let id = obj["store_id"].string{
            storeID = Int(id) ?? 0
        }
        self.isBlock = obj["is_block"].int ?? 0
        self.firstName = obj["first_name"].string ?? ""
        self.lastName = obj["last_name"].string ?? ""
        self.email = obj["email"].string ?? ""
        self.phoneNumber = obj["phone_number"].string ?? ""
        self.image = obj["image"].string ?? ""
        self.loginType = obj["login_type"].string ?? ""
        self.token = obj["token"].string ?? ""
        self.createdAt = obj["created_at"].string ?? ""
        self.fcmToken = obj["fcm_token"].string ?? ""
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.storeID, forKey: "storeID")
        aCoder.encode(self.isBlock, forKey: "isBlock")
        aCoder.encode(self.firstName, forKey: "firstName")
        aCoder.encode(self.lastName, forKey: "lastName")
        aCoder.encode(self.email, forKey: "email")
        aCoder.encode(self.phoneNumber, forKey: "phoneNumber")
        aCoder.encode(self.image, forKey: "image")
        aCoder.encode(self.loginType, forKey: "loginType")
        aCoder.encode(self.token, forKey: "token")
        aCoder.encode(self.createdAt, forKey: "createdAt")
        aCoder.encode(self.fcmToken, forKey: "fcmToken")
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        self.init()
        self.id = aDecoder.decodeInteger(forKey: "id")
        self.storeID = aDecoder.decodeInteger(forKey: "storeID")
        self.isBlock = aDecoder.decodeInteger(forKey: "isBlock")
        self.firstName = aDecoder.decodeObject(forKey: "firstName") as? String ?? ""
        self.lastName = aDecoder.decodeObject(forKey: "lastName") as? String ?? ""
        self.email = aDecoder.decodeObject(forKey: "email") as? String ?? ""
        self.phoneNumber = aDecoder.decodeObject(forKey: "phoneNumber") as? String ?? ""
        self.image = aDecoder.decodeObject(forKey: "image") as? String ?? ""
        self.loginType = aDecoder.decodeObject(forKey: "loginType") as? String ?? ""
        self.token = aDecoder.decodeObject(forKey: "token") as? String ?? ""
        self.createdAt = aDecoder.decodeObject(forKey: "createdAt") as? String ?? ""
        self.fcmToken = aDecoder.decodeObject(forKey: "fcmToken") as? String ?? ""
    }
    
    
}


