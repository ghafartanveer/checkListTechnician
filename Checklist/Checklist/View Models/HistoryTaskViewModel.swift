//
//  HistoryTaskViewModel.swift
//  Checklist
//
//  Created by Muaaz Ahmad on 22/06/2021.
//

import Foundation
import SwiftyJSON

// MARK: - COMPLETE Responce
struct HistoryTaskListViewModel {
    var historyTaskList: [HistoryTaskViewModel]
       
    init() {
        self.historyTaskList = [HistoryTaskViewModel]()
    }
    
    //convenience
    init(list: JSON) {
        self.init()
        if let jsonList = list.array{
            let list = jsonList.map({
                                        HistoryTaskViewModel(obj: $0)})
            self.historyTaskList.append(contentsOf: list)
        }
    }
}

//MARK: - TaskList

struct HistoryTaskViewModel {
    
    var id, userID, categoryID, activityID: Int?
    var categoryName: String?
    var datumDescription: String?
    var deletedAt: String?
    var createdAt, updatedAt: String?
    var technician: TechnicianViewModel?
    var activity: Activity?
    var subcategories: SubcategoryListViewModel?
    var images: ImageListViewModel?
    
    init() {
        self.id = 0
        self.userID = 0
        self.categoryID = 0
        self.activityID = 0
        self.categoryName = ""
        self.datumDescription = ""
        self.deletedAt = ""
        self.createdAt = ""
        self.updatedAt = ""
        self.technician = TechnicianViewModel()
        self.activity = Activity()
        self.subcategories = SubcategoryListViewModel()
        self.images = ImageListViewModel()
    }
    
    init(obj: JSON) {
        self.id = obj["id"].int ?? 0
        self.userID =  obj["user_id"].int ?? 0
        self.categoryID =  obj["category_id"].int ?? 0
        self.activityID =  obj["activity_id"].int ?? 0
        self.categoryName =  obj["category_name"].string ?? ""
        self.datumDescription =  obj["description"].string ?? ""
        self.deletedAt =  obj["deleted_at"].string ?? ""
        self.createdAt =  obj["created_at"].string ?? ""
        self.updatedAt =  obj["updated_at"].string ?? ""
                  
        
        self.technician = TechnicianViewModel(obj: obj["technician"])
        self.activity = Activity(obj: obj["activity"])
        
        self.subcategories = SubcategoryListViewModel(list:obj["subcategories"])
        self.images = ImageListViewModel(list: obj["images"])
    }
}
//--------------------------------------------------
// MARK: - Activity
struct Activity {
    var id, userID: Int?
    var customerName, registrationNumber, checkIn: String?
    var checkOut: String?
    var deletedAt: String?
    var createdAt, updatedAt: String?
    
    init() {
        self.id = 0
        self.userID = 0
        self.customerName = ""
        self.registrationNumber = ""
        self.checkIn = ""
        self.checkOut = ""
        self.deletedAt = ""
        self.createdAt = ""
        self.updatedAt = ""
    }
    
    init(obj: JSON) {
        self.id = obj["id"].int ?? 0
        self.userID = obj["user_id"].int ?? 0
        self.customerName = obj["customer_name"].string ?? ""
        self.registrationNumber = obj["registration_number"].string ?? ""
        self.checkIn = obj["check_in"].string ?? ""
        self.checkOut = obj["check_out"].string ?? ""
        self.deletedAt = obj["deleted_at"].string ?? ""
        self.createdAt = obj["created_at"].string ?? ""
        self.updatedAt = obj["updated_at"].string ?? ""
    }
}

//----------------------------------------------
// MARK: - Subcategory
struct SubcategoryViewModel {
    var id, taskID, subCatID: Int?
    var subCategoryName: String?
    var status: Int?
    var createdAt, updatedAt: String?
    
    init() {
        self.id = 0
        self.taskID = 0
        self.subCatID = 0
        self.subCategoryName = ""
        self.status = 0
        self.createdAt = ""
        self.updatedAt = ""
    }
    
    init(obj: JSON) {
        self.id = obj["id"].int ?? 0
        self.taskID = obj["task_id"].int ?? 0
        self.subCatID = obj["sub_cat_id"].int ?? 0
        self.subCategoryName = obj["sub_category_name"].string ?? ""
        self.status = obj["status"].int ?? 0
        self.createdAt = obj["created_at"].string ?? ""
        self.updatedAt = obj["updated_at"].string ?? ""
    }
}

//MARK: - subCategoryList
struct SubcategoryListViewModel {
    var subCategoryList = [SubcategoryViewModel]()
    
    init() {
        self.subCategoryList = [SubcategoryViewModel]()
    }
    
    //convenience
    init(list: JSON) {
        self.init()
        if let jsonList = list.array{
            let list = jsonList.map({SubcategoryViewModel(obj: $0)})
            self.subCategoryList.append(contentsOf: list)
        }
    }
    
}

//----------------------------------------------------
// MARK: - Technician
struct TechnicianViewModel {
    var id, storeID: Int?
    var firstName, lastName, email, phoneNumber: String?
    var image: String?
    var referencePassword: Int?
    var fcmToken: String?
    var loginType: String?
    var isBlock: Int?
    
    init() {
        self.id = 0
        self.storeID = 0
        self.firstName = ""
        self.lastName = ""
        self.email = ""
        self.phoneNumber = ""
        self.image = ""
        self.referencePassword = 0
        self.fcmToken = ""
        self.loginType = ""
        self.isBlock = 0
    }
    
    init(obj: JSON) {
        self.id = obj["id"].int ?? 0
        self.storeID = obj["store_id"].int ?? 0
        self.firstName = obj["first_name"].string ?? ""
        self.lastName = obj["last_name"].string ?? ""
        self.email = obj["email"].string ?? ""
        self.phoneNumber = obj["phone_number"].string ?? ""
        self.image = obj["image"].string ?? ""
        self.referencePassword = obj["reference_password"].int ?? 0
        self.fcmToken = obj["fcm_token"].string ?? ""
        self.loginType = obj["login_type"].string ?? ""
        self.isBlock = obj["is_block"].int ?? 0
    }
}
