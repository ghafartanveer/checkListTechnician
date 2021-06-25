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
    var hasImages: Int
    var deletedAt: String
    var createdAt: String
    var updatedAt: String
    var taskSubCategory: TaskSubcategoryListViewModel?
    var images : ImageListViewModel?
    init() {
        self.id = 0
        self.name = ""
        self.hasImages = 0
        self.deletedAt = ""
        self.createdAt = ""
        self.updatedAt = ""
        self.taskSubCategory = TaskSubcategoryListViewModel()
        self.images = ImageListViewModel()
    }
    
    
    init(obj: JSON) {
        self.id = obj["id"].int ?? 0
        self.name = obj["name"].string ?? ""
        self.hasImages = obj["has_images"].int ?? 0
        self.deletedAt = obj["deleted_at"].string ?? ""
        self.createdAt = obj["created_at"].string ?? ""
        self.updatedAt = obj["updated_at"].string ?? ""
        
        self.taskSubCategory = TaskSubcategoryListViewModel(list:obj["subcategories"])
        self.images = ImageListViewModel(list: obj["images"])

    }
}


//MARK: - subCategoryList
class TaskSubcategoryListViewModel {
    var taskSubCategoryList = [TaskSubcatgoryViewModel]()
    
    init() {
        self.taskSubCategoryList = [TaskSubcatgoryViewModel]()
    }
    
    convenience init(list: JSON) {
        self.init()
        if let jsonList = list.array{
            let list = jsonList.map({TaskSubcatgoryViewModel(obj: $0)})
            self.taskSubCategoryList.append(contentsOf: list)
        }
    }
    
}

class TaskSubcatgoryViewModel {
   
    var id : Int
    var categoryId : Int
    var subcategoryName : String
    var subcategoryDescription : String
    var isPriority : Int
    var notApplicable : Int
    var deletedAt : String
    var createdAt : String
    var updatedAt : String
    
    init() {
        self.id = 0
        self.categoryId = 0
        self.subcategoryName = ""
        self.subcategoryDescription = ""
        self.isPriority = 0
        self.notApplicable = 0
        self.deletedAt = ""
        self.createdAt = ""
        self.updatedAt = ""
    }
    
    init(obj: JSON) {
        self.id = obj["id"].int ?? 0
        self.categoryId = obj["category_id"].int ?? 0
        self.subcategoryName = obj["subcategory_name"].string ?? ""
        self.subcategoryDescription =  obj["subcategory_description"].string ?? ""
        self.isPriority = obj["is_priority"].int ?? 0
        self.notApplicable = obj["not_applicable"].int ?? 0
        self.deletedAt = obj["deleted_at"].string ?? ""
        self.createdAt = obj["created_at"].string ?? ""
        self.updatedAt = obj["updated_at"].string ?? ""
    }
}
