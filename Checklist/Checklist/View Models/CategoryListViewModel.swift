//
//  TaskListViewModel.swift
//  Checklist
//
//  Created by Rizwan Ali on 20/05/2021.
//

import Foundation
import SwiftyJSON


class CategoryListViewModel {
    var categoryList: [CategoryViewModel]
    
    
    init() {
        self.categoryList = [CategoryViewModel]()
    }
    
    convenience init(list: JSON) {
        self.init()
        if let jsonList = list.array{
          let list = jsonList.map({CategoryViewModel(obj: $0)})
            self.categoryList.append(contentsOf: list)
        }
    }
    
//    func getCategoryDetailAganistID(CategoryID: Int) -> CategoryViewModel{
//        var object = CategoryViewModel()
//        for each in self.categoryList{
//            if each.id == CategoryID{
//                object = each
//            }
//        }
//        return object
//    }
}


