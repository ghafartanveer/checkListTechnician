//
//  ForgetPasswordViewController.swift
//  Checklist
//
//  Created by Rizwan Ali on 19/04/2021.
//

import UIKit

class ForgetPasswordViewController: BaseViewController {
    //MARK: - IBOUTLETS
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var viewEmailShadow: UIView!
    
    
    //MARK: - OBJECT AND VERIABLES
    
    
    //MARK: - OVERRIDE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewEmailShadow.dropShadow(radius: 5, opacity: 0.4)
    }
    
    //MARK: - FUNCTIOND
    
    
    //MARK: - IBACTION METHODS
    @IBAction func actionBack(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionSendInstructions(_ sender: UIButton){
        let emailValidation = Validations.emailValidation(self.txtEmail.text!)
        if emailValidation.isValid{
            self.forgotPasswordApiCall(Params: [DictKeys.email: self.txtEmail.text!])
        }else{
            self.showAlertView(message: emailValidation.message)
        }
    }
    //MARK: - FUNCTIONS
    func moveToUpdatePasswordVC(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: ControllerIdentifier.UpdatePasswordViewController) as! UpdatePasswordViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


//MARK: - EXTENSION API CALLS
extension ForgetPasswordViewController{
    func forgotPasswordApiCall(Params: ParamsAny){
        self.startActivity()
        GCD.async(.Background) {
            LoginService.shared().forgetPassword(params: Params) { (message, success) in
                GCD.async(.Main) {
                    self.stopActivity()
                    
                    if success{
                        self.showAlertView(message: message, title: "", doneButtonTitle: "Ok") { (UIAlertAction) in
                            self.moveToUpdatePasswordVC()
                        }
                        
                    }else{
                        self.showAlertView(message: message)
                    }
                }
            }
        }
    }
}

