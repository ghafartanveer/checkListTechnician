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
    var taskSubCategory: TaskSubcategoryListViewModel?
    init() {
        self.id = 0
        self.name = ""
        self.deletedAt = ""
        self.createdAt = ""
        self.updatedAt = ""
        self.taskSubCategory = TaskSubcategoryListViewModel()
    }
    
    
    init(obj: JSON) {
        self.id = obj["id"].int ?? 0
        self.name = obj["name"].string ?? ""
        self.deletedAt = obj["deleted_at"].string ?? ""
        self.createdAt = obj["created_at"].string ?? ""
        self.updatedAt = obj["updated_at"].string ?? ""
        
        self.taskSubCategory = TaskSubcategoryListViewModel(list:obj["subcategories"])
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




/*
 
 {
 "message": "Record found",
 "code": 200,
 "data": [
 {
 "id": 6,
 "name": "Required Images",
 "has_images": 1,
 "deleted_at": null,
 "created_at": "2021-06-23 06:17:29",
 "updated_at": "2021-06-23 06:18:57",
 "subcategories": [
 {
 "id": 11,
 "category_id": 6,
 "subcategory_name": "Image 1 - Task",
 "subcategory_description": "null",
 "is_priority": 0,
 "not_applicable": 0,
 "deleted_at": null,
 "created_at": "2021-06-23 06:18:46",
 "updated_at": "2021-06-23 08:15:17"
 }
 ],
 "images": [
 {
 "id": 33,
 "category_id": 6,
 "type_name": "null",
 "image": null,
 "created_at": "2021-06-23 08:15:17",
 "updated_at": "2021-06-23 08:15:17"
 }
 ]
 },
 {
 "id": 5,
 "name": "car service",
 "has_images": 1,
 "deleted_at": null,
 "created_at": "2021-06-18 14:13:14",
 "updated_at": "2021-06-18 14:13:14",
 "subcategories": [
 {
 "id": 8,
 "category_id": 5,
 "subcategory_name": "car mates wash",
 "subcategory_description": "null",
 "is_priority": 1,
 "not_applicable": 1,
 "deleted_at": null,
 "created_at": "2021-06-18 14:14:30",
 "updated_at": "2021-06-23 08:15:22"
 }
 ],
 "images": [
 {
 "id": 34,
 "category_id": 5,
 "type_name": "null",
 "image": null,
 "created_at": "2021-06-23 08:15:22",
 "updated_at": "2021-06-23 08:15:22"
 }
 ]
 },
 {
 "id": 3,
 "name": "Large Vehicles Service Provider",
 "has_images": 1,
 "deleted_at": null,
 "created_at": "2021-06-17 13:40:02",
 "updated_at": "2021-06-17 13:40:02",
 "subcategories": [
 {
 "id": 9,
 "category_id": 3,
 "subcategory_name": "Oil Change",
 "subcategory_description": "null",
 "is_priority": 0,
 "not_applicable": 0,
 "deleted_at": null,
 "created_at": "2021-06-23 06:00:56",
 "updated_at": "2021-06-23 08:14:38"
 },
 {
 "id": 10,
 "category_id": 3,
 "subcategory_name": "Car Wash",
 "subcategory_description": "null",
 "is_priority": 0,
 "not_applicable": 0,
 "deleted_at": null,
 "created_at": "2021-06-23 06:00:56",
 "updated_at": "2021-06-23 08:14:38"
 }
 ],
 "images": [
 {
 "id": 31,
 "category_id": 3,
 "type_name": "null",
 "image": null,
 "created_at": "2021-06-23 08:14:38",
 "updated_at": "2021-06-23 08:14:38"
 },
 {
 "id": 32,
 "category_id": 3,
 "type_name": "null",
 "image": null,
 "created_at": "2021-06-23 08:14:38",
 "updated_at": "2021-06-23 08:14:38"
 }
 ]
 },
 {
 "id": 2,
 "name": "Car Wash",
 "has_images": 1,
 "deleted_at": null,
 "created_at": "2021-06-17 13:37:16",
 "updated_at": "2021-06-17 13:37:16",
 "subcategories": [
 {
 "id": 3,
 "category_id": 2,
 "subcategory_name": "Whole Car Wash",
 "subcategory_description": "null",
 "is_priority": 1,
 "not_applicable": 0,
 "deleted_at": null,
 "created_at": "2021-06-17 13:38:08",
 "updated_at": "2021-06-23 08:15:26"
 },
 {
 "id": 4,
 "category_id": 2,
 "subcategory_name": "Mirrors",
 "subcategory_description": "null",
 "is_priority": 1,
 "not_applicable": 1,
 "deleted_at": null,
 "created_at": "2021-06-17 13:38:44",
 "updated_at": "2021-06-23 06:57:38"
 },
 {
 "id": 5,
 "category_id": 2,
 "subcategory_name": "Doors",
 "subcategory_description": "null",
 "is_priority": 0,
 "not_applicable": 1,
 "deleted_at": null,
 "created_at": "2021-06-17 13:38:44",
 "updated_at": "2021-06-17 13:39:04"
 },
 {
 "id": 6,
 "category_id": 2,
 "subcategory_name": "Tyres",
 "subcategory_description": "null",
 "is_priority": 0,
 "not_applicable": 0,
 "deleted_at": null,
 "created_at": "2021-06-17 13:39:04",
 "updated_at": "2021-06-17 13:41:01"
 }
 ],
 "images": [
 {
 "id": 35,
 "category_id": 2,
 "type_name": "null",
 "image": null,
 "created_at": "2021-06-23 08:15:26",
 "updated_at": "2021-06-23 08:15:26"
 },
 {
 "id": 36,
 "category_id": 2,
 "type_name": "null",
 "image": null,
 "created_at": "2021-06-23 08:15:26",
 "updated_at": "2021-06-23 08:15:26"
 },
 {
 "id": 37,
 "category_id": 2,
 "type_name": "null",
 "image": null,
 "created_at": "2021-06-23 08:15:26",
 "updated_at": "2021-06-23 08:15:26"
 },
 {
 "id": 38,
 "category_id": 2,
 "type_name": "null",
 "image": null,
 "created_at": "2021-06-23 08:15:26",
 "updated_at": "2021-06-23 08:15:26"
 }
 ]
 },
 {
 "id": 1,
 "name": "Dev Matloob Category",
 "has_images": 0,
 "deleted_at": null,
 "created_at": "2021-06-17 12:18:30",
 "updated_at": "2021-06-17 12:18:30",
 "subcategories": [
 {
 "id": 2,
 "category_id": 1,
 "subcategory_name": "Task 0",
 "subcategory_description": "null",
 "is_priority": 1,
 "not_applicable": 1,
 "deleted_at": null,
 "created_at": "2021-06-17 12:18:43",
 "updated_at": "2021-06-23 08:15:29"
 }
 ],
 "images": [
 {
 "id": 39,
 "category_id": 1,
 "type_name": "null",
 "image": null,
 "created_at": "2021-06-23 08:15:29",
 "updated_at": "2021-06-23 08:15:29"
 }
 ]
 }
 ]
 }
 */
