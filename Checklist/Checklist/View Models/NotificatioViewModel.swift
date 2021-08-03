//
//  NotificatioViewModel.swift
//  Checklist
//
//  Created by Muaaz Ahmad on 28/07/2021.
//

import Foundation
import SwiftyJSON

class NotificatioViewModel {
    var categoryId : Int
    var notificationId : Int
    var title : String
    var id: Int
    
    init() {
        self.categoryId = 0
        self.notificationId = 0
        self.id = 0
        self.title = ""
    }
    
    init(info: JSON) {
        self.categoryId = info["data"]["category_id"].int ?? 0
        self.notificationId = info["data"]["notification_id"].int ?? 0
        self.title = info["aps"]["alert"]["title"].string ?? ""
        self.id = info["id"].int ?? 0
    }
}
