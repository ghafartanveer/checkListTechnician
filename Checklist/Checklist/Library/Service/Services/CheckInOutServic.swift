//
//  CheckInOutServic.swift
//  Checklist
//
//  Created by Muaaz Ahmad on 23/06/2021.
//

import UIKit

class CheckInOutServic: BaseService {
    
    //MARK:- Shared Instance
    private override init() {}
    static func shared() -> CheckInOutServic {
        return CheckInOutServic()
    }
    
    //MARK:- checkInApiAPI
    func checkInApi(params:ParamsAny?, completion: @escaping (_ message:String, _ success:Bool, _ historyDetails: CheckInViewModel?)->Void) {
        let completeUrl = EndPoints.BASE_URL + EndPoints.CheckIn
        self.makePostAPICall(with: completeUrl, params: params, headers: self.getHeaders()) { (message, success, json, responseType) in
            if success{
                let info = CheckInViewModel(obj: json![KEY_RESPONSE_DATA])
                completion(message,success, info)
            }else{
                completion(message,success, nil)
            }
            
        }
    }
    
    //MARK: - CheckOut API
    func checkOutApi(params:ParamsAny?, completion: @escaping (_ message:String, _ success:Bool)->Void) {
        let completeUrl = EndPoints.BASE_URL + EndPoints.CheckOut
        self.makePostAPICall(with: completeUrl, params: params, headers: self.getHeaders()) { (message, success, json, responseType) in
            if success{
                completion(message,success)
            }else{
                completion(message,success)
            }
            
        }
    }
}
