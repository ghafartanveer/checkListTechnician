//
//  BaseService.swift
//  OrderAte
//
//  Created by Gulfam Khan on 17/02/2020.
//  Copyright © 2020 Rapidzz. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class BaseService {
    //MARK:- Shared data
    private var dataRequest:DataRequest?
    
    init() {}
    
    fileprivate var sessionManager:SessionManager {
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 60
        return manager
    }
    
    func getHeaders() -> HTTPHeaders {
        let headers: HTTPHeaders = ["Authorization": "Bearer \(Global.shared.user.token)"]
        return headers
    }
    
    //MARK:- POST API Call
    func makePostAPICall(with completeURL:String, params:Parameters?,headers:HTTPHeaders? = nil, completion: @escaping (_ error: String, _ success: Bool, _ jsonData:JSON?, _ responseType:ServiceResponseType?)->Void){
        
        print("URL: \(completeURL)")
        print("Params: \(params)")
        print(headers as Any)
        
        dataRequest = sessionManager.request(completeURL, method: .post, parameters: params!, encoding: JSONEncoding.default, headers: headers)
        
        dataRequest?
            .validate(statusCode: 200...501)
            .responseJSON(completionHandler: { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    let parsedResponse = ResponseHandler.handleResponse(json)
                    
                    if parsedResponse.serviceResponseType == .Success {
                        completion(parsedResponse.message,true, parsedResponse.swiftyJsonData, parsedResponse.serviceResponseType)
                    }else if(parsedResponse.serviceResponseType == .Invalid){
                        completion(parsedResponse.message,false,nil, parsedResponse.serviceResponseType)
                    }
                    else {
                        completion(parsedResponse.message,false,nil, parsedResponse.serviceResponseType)
                    }
                    
                case .failure(let error):
                    let errorMessage:String = error.localizedDescription
                    print(errorMessage)
                    completion(PopupMessages.SomethingWentWrong, false,nil, .Failure)
                }
            })
    }
    
    //MARK:- Get API Call
    func makeGetAPICall(with completeURL:String, params:Parameters?,headers:HTTPHeaders? = nil,completion: @escaping (_ error: String, _ success: Bool, _ resultList:JSON?, _ responseType:ServiceResponseType)->Void){
        
        print("URL: \(completeURL)")
        print("Params: \(params)")
        print(headers as Any)
        
        dataRequest = sessionManager.request(completeURL, method: .get, parameters: params, encoding: URLEncoding.default, headers: headers)
        dataRequest?
            .validate(statusCode: 200...500)
            .responseJSON(completionHandler: { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    let parsedResponse = ResponseHandler.handleResponse(json)
                    
                    if parsedResponse.serviceResponseType == .Success {
                        completion(parsedResponse.message,true, parsedResponse.swiftyJsonData, parsedResponse.serviceResponseType)
                    }else {
                        completion(parsedResponse.message,false,nil,parsedResponse.serviceResponseType)
                    }
                    
                case .failure(let error):
                    let errorMessage:String = error.localizedDescription
                    print(errorMessage)
                    completion(PopupMessages.SomethingWentWrong, false, nil, .Failure)
                }
            })
        
    }
    
    //MARK:- Multipart Post API Call
    func makePostAPICallWithMultipart(with completeURL:String, dict:[String:Data?]?, params:ParamsAny, headers:HTTPHeaders? = nil, completion: @escaping (_ error: String, _ success: Bool, _ jsonData:JSON?, _ responseType:ServiceResponseType)->Void) {
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            
            
            for (key, value) in params {
                let newValue = "\(value)"
                multipartFormData.append((newValue).data(using: .utf8)!, withName: key)
            }
            
            // import image to request
            for (key, value) in dict ?? [:] {
                multipartFormData.append(value!, withName: key,fileName: "image.jpg", mimeType: "image/jpg")
            }
            
        }, to: completeURL, headers:headers, encodingCompletion: {
            encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { (response) -> Void in
                    
                    switch response.result {
                    
                    case .success(let value):
                        let json = JSON(value)
                        let parsedResponse = ResponseHandler.handleResponse(json)
                        
                        if parsedResponse.serviceResponseType == .Success {
                            completion(parsedResponse.message,true, parsedResponse.swiftyJsonData,parsedResponse.serviceResponseType)
                        }else {
                            completion(parsedResponse.message,false,nil, parsedResponse.serviceResponseType)
                        }
                        
                    case .failure(let error):
                        let errorMessage:String = error.localizedDescription
                        print(errorMessage)
                        completion(PopupMessages.SomethingWentWrong, false, nil, .Failure)
                    }
                    
                }
            case .failure(let encodingError):
                print(encodingError.localizedDescription)
            }
        })
        
    }
    
    //Mark:- PostCall with json Data
    //MARK:- POST API Call
    func makePostAPICallWithJson(with completeURL:String, params:TaskViewModel,headers:HTTPHeaders? = nil, completion: @escaping (_ error: String, _ success: Bool, _ jsonData:JSON?, _ responseType:ServiceResponseType?)->Void){
        
        print("URL: \(completeURL)")
        print("Params: \(params)")
        print(headers as Any)
        
//
        
        
//        let encoder = JSONEncoder()
//        //do {
//            let jsonData = try! encoder.encode(params)
//            var request = URLRequest(url: URL(string: completeURL)!)
//            request.httpMethod = HTTPMethod.post.rawValue
//        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "" )
//            request.httpBody = jsonData
        
//        dataRequest = sessionManager.request(completeURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
        
        //        } catch let err  {
//            print("jsonBody Error: ",err)
//        }
        
//        do {
//            let jsonBody = try JSONEncoder().encode(params)
//            request.httpBody = jsonBody
//            print("jsonBody:",jsonBody)
//            let jsonBodyString = String(data: jsonBody, encoding: .utf8)
//            print("JSON String : ", jsonBodyString!)
//        } catch let err  {
//            print("jsonBody Error: ",err)
//        }
        
        dataRequest?
            .validate(statusCode: 200...501)
            .responseJSON(completionHandler: { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    let parsedResponse = ResponseHandler.handleResponse(json)
                    
                    if parsedResponse.serviceResponseType == .Success {
                        completion(parsedResponse.message,true, parsedResponse.swiftyJsonData, parsedResponse.serviceResponseType)
                    }else if(parsedResponse.serviceResponseType == .Invalid){
                        completion(parsedResponse.message,false,nil, parsedResponse.serviceResponseType)
                    }
                    else {
                        completion(parsedResponse.message,false,nil, parsedResponse.serviceResponseType)
                    }
                    
                case .failure(let error):
                    let errorMessage:String = error.localizedDescription
                    print(errorMessage)
                    completion(PopupMessages.SomethingWentWrong, false,nil, .Failure)
                }
            })
    }
    
    
//    func assignSlotsList (url: String, params: CreateNewSlots, onSuccess success: @escaping ( response: UpdateSlotResponse ) -> Void, onFailure failure: @escaping ( error: Error?) -> Void, onError message: @escaping (_ mess: String?) -> Void) {
//
//        print(url, params)
//        if Utilites.isInternetAvailable() {
//
//            let encoder = JSONEncoder()
//            do {
//                let jsonData = try encoder.encode(params)
//                var request = URLRequest(url: URL(string: url)!)
//                request.httpMethod = HTTPMethod.post.rawValue
//                request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
//                request.httpBody = jsonData
//
//            } catch let err  {
//                print("jsonBody Error: ",err)
//            }
//
//            do {
//                let jsonBody = try JSONEncoder().encode(params)
//                request.httpBody = jsonBody
//                print("jsonBody:",jsonBody)
//                let jsonBodyString = String(data: jsonBody, encoding: .utf8)
//                print("JSON String : ", jsonBodyString!)
//            } catch let err  {
//                print("jsonBody Error: ",err)
//            }
//            AF.request(request).responseDecodable(of: UpdateSlotResponse.self) { (response) in
//                switch response.result {
//                case .success(let value):
//                    success(value)
//                case .failure(let error):
//                    failure(error)
//                }
//            }
//        } else {
//            message(AlertConstants.InternetNotReachable)
//        }
//    }

 //===========
    
//    func makePostAPICallImage(with completeURL:String, params:Parameters?,headers:HTTPHeaders? = nil, completion: @escaping (_ error: String, _ success: Bool, _ jsonData:Data? , _ responseType : Int?)->Void){
//
//        print("URL: \(completeURL)")
//        print("Params: \(params)")
//        dataRequest = sessionManager.request(completeURL, method: .post, parameters: params!, encoding: URLEncoding.default, headers: headers)
//
//        dataRequest?
//            .validate(statusCode: 200...500)
//            .responseJSON(completionHandler: { response in
//                if(response.response?.statusCode == 200){
//                    completion("success",true, response.data, response.response?.statusCode)
//                }
//                else{
//                    completion("failure",false, response.data, response.response?.statusCode)
//                }
//                // let response = response.response?.statusCode
//                //                   switch response.result {
//                //                   case .success(let value):
//                //                       let json = JSON(value)
//                //                       let parsedResponse = ResponseHandler.handleResponse(json)
//                //
//                //                       if parsedResponse.serviceResponseType == .Success {
//                //                           completion(parsedResponse.message,true, value, parsedResponse.serviceResponseType)
//                //                       }else {
//                //                           completion(parsedResponse.message,false,nil, parsedResponse.serviceResponseType)
//                //                       }
//                //
//                //                   case .failure(let error):
//                //                       let errorMessage:String = error.localizedDescription
//                //                       print(errorMessage)
//                //                       completion(PopupMessages.SomethingWentWrong, false,nil, .Failure)
//                //                   }
//            })
//    }
    
    
}

