//
//  CommonService.swift
//  Checklist
//
//  Created by Muaaz Ahmad on 24/06/2021.
//

import Foundation

class CommonService: BaseService {
    //MARK:- Shared Instance
    private override init() {}
    static func shared() -> CommonService {
        return CommonService()
    }
    
    //MARK: - HelpApi
    func helpApi(params:ParamsAny?, completion: @escaping (_ message:String, _ success:Bool)->Void) {
        let completeUrl = EndPoints.BASE_URL + EndPoints.Help
        self.makePostAPICall(with: completeUrl, params: params, headers: self.getHeaders()) { (message, success, json, responseType) in
            if success{
                completion(message,success)
            }else{
                completion(message,success)
            }
            
        }
    }
    
    //MARK: - Submit task
    func submitTaskApi(params:ParamsAny?, completion: @escaping (_ message:String, _ success:Bool)->Void) {
        let completeUrl = EndPoints.BASE_URL + EndPoints.SubmitTasks
        self.makePostAPICall(with: completeUrl, params: params, headers: self.getHeaders()) { (message, success, json, responseType) in
            if success{
                completion(message,success)
            }else{
                completion(message,success)
            }
            
        }
    }
    
    //MARK: - Upload Image
    func uploadImagesApi(params:ParamsAny?,Img:[String:Data?], completion: @escaping (_ message:String, _ success:Bool)->Void) {
        let completeUrl = EndPoints.BASE_URL + EndPoints.UploaImage
        makePostAPICallWithMultipart(with: completeUrl, dict: Img ?? nil , params: params!, headers: self.getHeaders()) { (message, success, json, responseType) in
            if success{
                completion(message,success)
            }else{
                completion(message,success)
            }
            
        }
    }

    //MARK: - Submit task
    func deleteImageApi(params:ParamsAny?, completion: @escaping (_ message:String, _ success:Bool)->Void) {
        let completeUrl = EndPoints.BASE_URL + EndPoints.DeleteImage
        self.makePostAPICall(with: completeUrl, params: params, headers: self.getHeaders()) { (message, success, json, responseType) in
            if success{
                completion(message,success)
            }else{
                completion(message,success)
            }
            
        }
    }
}
