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
    var id, categoryID: Int?
    var typeName: String?
    var image: String?
    var createdAt, updatedAt: String?
    
    init() {
        
        self.id = 0
        self.categoryID = 0
        self.typeName = ""
        self.image = ""
        self.createdAt = ""
        self.updatedAt = ""
    }
    
    init(obj: JSON) {
        self.id = obj["id"].int ?? 0
        self.categoryID = obj["category_id"].int ?? 0
        
        self.typeName = obj["type_name"].string ?? ""
        
        self.image = obj["image"].string ?? ""
        self.createdAt = obj["created_at"].string ?? ""
        self.updatedAt = obj["updated_at"].string ?? ""
    }
}

