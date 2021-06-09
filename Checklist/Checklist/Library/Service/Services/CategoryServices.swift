//
//  TaskServices.swift
//  Checklist
//
//  Created by Rizwan Ali on 20/05/2021.
//

import Foundation
import SwiftyJSON
import Alamofire

class CategoryServices: BaseService {
    
    //MARK:- Shared Instance
    private override init() {}
    static func shared() -> CategoryServices {
        return CategoryServices()
    }
    
    //MARK:- CATEGORY LIST API
    func categoryListApi(params: Parameters?,completion: @escaping (_ error: String, _ success: Bool, _ object: CategoryListViewModel?)->Void){
        
        let completeURL = EndPoints.BASE_URL + EndPoints.categories_List
        self.makeGetAPICall(with: completeURL, params: params, headers: self.getHeaders()) { (message, success, json, responseType) in
            if success{
                let info = CategoryListViewModel(list: json![KEY_RESPONSE_DATA])
                completion(message,success, info)
            }else{
                completion(message,success, nil)
            }
           
        }
    }
    
    
}
