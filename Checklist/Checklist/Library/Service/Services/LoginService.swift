
import Foundation
import Alamofire
import SwiftyJSON

class LoginService: BaseService {
    
    //MARK:- Shared Instance
    private override init() {}
    static func shared() -> LoginService {
        return LoginService()
    }
    
    fileprivate func saveUserInfo(_ userInfo:UserViewModel) {
        Global.shared.user = userInfo
        UserDefaultsManager.shared.isUserLoggedIn = true
        UserDefaultsManager.shared.userInfo = userInfo
    }
    
    //MARK: - Forget password API
    func forgetPassword(params:Parameters?,completion: @escaping (_ error: String, _ success: Bool)->Void){
        
        let completeURL = EndPoints.BASE_URL + EndPoints.Forgot_Password
        self.makePostAPICall(with: completeURL, params: params) { (message, success, json, responseType) in
            completion(message,success)
        }
    }
    
    
    //MARK: - UPDATE PASSWORD API
    func updatePasswordApi(params: Parameters?,completion: @escaping (_ error: String, _ success: Bool)->Void){
        let completeURL = EndPoints.BASE_URL + EndPoints.Update_Password
        self.makePostAPICall(with: completeURL, params: params) { (message, success, json, responseType) in
            completion(message,success)
        }
    }
    
    //MARK: - LOGOUT API
    func logoutUserApi(params: Parameters?,completion: @escaping (_ error: String, _ success: Bool)->Void){
        let completeURL = EndPoints.BASE_URL + EndPoints.Logout_User
        self.makeGetAPICall(with: completeURL, params: params, headers: self.getHeaders()) { (message, success, json, responseType) in
            
            completion(message,success)
        }
    }
    
    //MARK:- Change Password API
    func loginApiCall(params:ParamsAny?, completion: @escaping (_ message:String, _ success:Bool, _ userInfo: UserViewModel?)->Void) {
        let completeUrl = EndPoints.BASE_URL + EndPoints.login
        self.makePostAPICall(with: completeUrl, params: params) { (message, success, json, responseType) in
            
            if success{
                let userObj = UserViewModel(obj: json![KEY_RESPONSE_DATA])
                self.saveUserInfo(userObj)
                completion(message,success, userObj)
            }else{
                completion(message,success, nil)
            }
            
        }
    }
    
   
    //MARK: - UpdateProfile Api
    func updateProfileApi(params:ParamsAny?, completion: @escaping (_ message:String, _ success:Bool, _ userInfo: UserViewModel?)->Void) {
        let completeUrl = EndPoints.BASE_URL + EndPoints.Profile_Update
        makePostAPICallWithMultipart(with: completeUrl, dict: nil, params: params!, headers: self.getHeaders()) { (message, success, json, responseType) in
            if success{
                let userObj = UserViewModel(obj: json![KEY_RESPONSE_DATA])
                self.saveUserInfo(userObj)
                completion(message,success, userObj)
            }else{
                completion(message,success, nil)
            }
            
        }
    }
}
