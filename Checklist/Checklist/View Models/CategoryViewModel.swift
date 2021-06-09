//
//  TaskViewModel.swift
//  Checklist
//
//  Created by Rizwan Ali on 20/05/2021.
//

import Foundation
import SwiftyJSON


class CategoryViewModel {
    
    var id: Int
    var name: String
    var deletedAt: String
    var createdAt: String
    var updatedAt: String
    
    init() {
        self.id = 0
        self.name = ""
        self.deletedAt = ""
        self.createdAt = ""
        self.updatedAt = ""
    }
    
    
    init(obj: JSON) {
        self.id = obj["id"].int ?? 0
        self.name = obj["name"].string ?? ""
        self.deletedAt = obj["deleted_at"].string ?? ""
        self.createdAt = obj["created_at"].string ?? ""
        self.updatedAt = obj["updated_at"].string ?? ""
        
    }
}
