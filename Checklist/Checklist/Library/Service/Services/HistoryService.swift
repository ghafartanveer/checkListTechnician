//
//  HistoryService.swift
//  Checklist
//
//  Created by Muaaz Ahmad on 22/06/2021.
//

import UIKit

class HistoryService: BaseService {

    //MARK:- Shared Instance
    private override init() {}
    static func shared() -> HistoryService {
        return HistoryService()
    }
    
    //MARK:- Change Password API
    func getHistoryApi(params:ParamsAny?, completion: @escaping (_ message:String, _ success:Bool, _ historyDetails: HistoryTaskListViewModel?)->Void) {
        let completeUrl = EndPoints.BASE_URL + EndPoints.History
        self.makePostAPICall(with: completeUrl, params: params, headers: self.getHeaders()) { (message, success, json, responseType) in
            if success{
                let info = HistoryTaskListViewModel(list: json![KEY_RESPONSE_DATA])
                completion(message,success, info)
            }else{
                completion(message,success, nil)
            }
            
        }
    }
    
    //MARK:- Search History Api
    func searcHistoryApi(params:ParamsString?, completion: @escaping (_ message:String, _ success:Bool, _ historyDetails: HistoryTaskListViewModel?)->Void) {
        let completeUrl = EndPoints.BASE_URL + EndPoints.Search
        self.makePostAPICall(with: completeUrl, params: params, headers: self.getHeaders()) { (message, success, json, responseType) in
            if success{
                let info = HistoryTaskListViewModel(list: json![KEY_RESPONSE_DATA])
                completion(message,success, info)
            }else{
                completion(message,success, nil)
            }
            
        }
    }
}
