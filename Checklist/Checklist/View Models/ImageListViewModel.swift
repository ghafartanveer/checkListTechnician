//
//  ImageListViewModel.swift
//  Checklist
//
//  Created by Muaaz Ahmad on 28/06/2021.
//

import Foundation
import SwiftyJSON

//MARK: - imageList Vie Model

struct ImageListViewModel {
    var imagelist = [ImageViewVodel]()
    
    init() {
        self.imagelist = [ImageViewVodel]()
    }
    
    //convenience
    init(list: JSON) {
        self.init()
        if let jsonList = list.array{
            let list = jsonList.map({ImageViewVodel(obj: $0)})
            self.imagelist.append(contentsOf: list)
        }
    }
    
}


// MARK: - Image
struct ImageViewVodel {
    var id, categoryID, activityId: Int?
    var typeName: String?
    var image: String?
    var createdAt, updatedAt: String?
    var description: String?
    
    var imageToUpload = UIImage()
    init() {
        
        self.id = 0
        self.categoryID = 0
        self.activityId = 0
        self.typeName = ""
        self.image = ""
        self.createdAt = ""
        self.updatedAt = ""
        self.description = ""
    }
    
    init(obj: JSON) {
        self.id = obj["id"].int ?? 0
        self.categoryID = obj["category_id"].int ?? 0
        self.typeName = obj["type_name"].string ?? ""
        self.image = obj["image"].string ?? ""
        self.createdAt = obj["created_at"].string ?? ""
        self.updatedAt = obj["updated_at"].string ?? ""
        self.activityId = obj["activity_id"].int ?? 0
        self.description = obj["description"].string ?? ""
        
    }
}


