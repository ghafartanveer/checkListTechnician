//
//  ChangePasswordPopUpViewController.swift
//  Checklist
//
//  Created by Rizwan Ali on 22/04/2021.
//

import UIKit

protocol ChangePasswordPopUpViewControllerDelegate: NSObjectProtocol {
    func callBackActionSubmit(crntPswd:String, newPasword: String)
    func closePopUP()
}

class ChangePasswordPopUpViewController: BaseViewController {

    //MARK: - OUTLETS
    @IBOutlet weak var currentPasswordFildContainerView: UIView!
    @IBOutlet weak var newPasswordContainerView: UIView!
    
    @IBOutlet weak var currentPasswordTF: UITextField!
    @IBOutlet weak var newPasswordTF: UITextField!
    
    //MARK: - OBJECT AND VERIABLES
    weak var delegate: ChangePasswordPopUpViewControllerDelegate?
    
    //MARK: - OVERRIDE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        currentPasswordFildContainerView.dropShadow(radius: 5, opacity: 0.4)//.addshadow()
        newPasswordContainerView.dropShadow(radius: 5, opacity: 0.4)//.addshadow()
        // Do any additional setup after loading the view.
    }
    
     
    //MARK: - IBACTION METHODS
    @IBAction func actionSubmit(_ sender: UIButton){
        if checkValidations() {
            delegate?.callBackActionSubmit(crntPswd: self.currentPasswordTF.text!, newPasword: self.newPasswordTF.text!)
        }
    }
    
    @IBAction func actionClose(_ sender: UIButton){
        //self.alertView?.close()
        delegate?.closePopUP()
    }

    func checkValidations() -> Bool{
        var isValid: Bool = true
        
        let validPassword = Validations.passwordValidation(self.newPasswordTF.text!,shouldCheckLength: true)

        if self.currentPasswordTF.text!.isEmpty{
            self.showAlertView(message: PopupMessages.Enter_Current_Password)
            isValid = false
        } else if self.newPasswordTF.text!.isEmpty{
            self.showAlertView(message: PopupMessages.Enter_New_Password)
            isValid = false
        } else if !validPassword.isValid{
            self.showAlertView(message: validPassword.message)
            isValid = false
        }
        
        return isValid
    }
}
