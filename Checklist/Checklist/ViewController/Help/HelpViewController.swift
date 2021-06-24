//
//  HelpViewController.swift
//  Checklist
//
//  Created by Muaaz Ahmad on 17/06/2021.
//

import Foundation

class HelpViewController: BaseViewController, TopBarDelegate {
    
    @IBOutlet weak var userDetailContainerView: UIView!
    @IBOutlet weak var nameFieldContainerView: UIView!
    @IBOutlet weak var emailFieldContainerView: UIView!
    @IBOutlet weak var subjectTextVContinerView: UIView!
    
    @IBOutlet weak var phoneNumberLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    
    @IBOutlet weak var subjectTxtV: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("this is aboutUs")
        setLayout()
        setUserData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let container = self.mainContainer{
            container.delegate = self
            container.setMenuButton(true, true, title: TitleNames.Help)
        }
    }
    
    //MARK: - IBOUTLETS
    
    @IBAction func submitBtnAction(_ sender: Any) {
        if self.checkValidations(){
            let userId = String(Global.shared.user.id)
            self.helpServerCall(params: [DictKeys.User_Id: userId ,DictKeys.email: self.emailTF.text!,
                                     DictKeys.name: self.nameTF.text!,
                                     DictKeys.Description: subjectTxtV.text])
        }
    }
    
    //MARK: - FUNCTIONS
    
    func actionBack() {
        self.loadHomeController()
    }
    
    func setLayout() {
                
        userDetailContainerView.dropShadow(radius: 5, opacity: 0.4)
        nameFieldContainerView.dropShadow(radius: 5, opacity: 0.4)
        emailFieldContainerView.dropShadow(radius: 5, opacity: 0.4)
        subjectTextVContinerView.dropShadow(radius: 5, opacity: 0.4)
    }
    
    func setUserData() {
        if let userData = UserDefaultsManager.shared.userInfo {
            
            phoneNumberLbl.text = userData.phoneNumber
            emailLbl.text = userData.email
            
        }
    }
    
    
    func checkValidations() -> Bool{
        var isValid: Bool = true
        let validEmail = Validations.emailValidation(self.emailTF.text!)
        let validName = Validations.nameValidation(self.nameTF.text!)
        
        if !validEmail.isValid{
            self.showAlertView(message: validEmail.message)
            isValid = false
            
        }else if !validName.isValid{
            self.showAlertView(message: validName.message)
            isValid = false
        }
        return isValid
    }
    
}

//MARK: - Server Calls

extension HelpViewController {
    
    func helpServerCall(params: ParamsString){
        self.startActivity()
        GCD.async(.Background) {
            CommonService.shared().helpApi(params: params) { (message, success) in
                GCD.async(.Main) { [self] in
                    self.stopActivity()
                    if success{
                        self.showAlertView(message: message)
                    }else{
                        self.showAlertView(message: message)
                    }
                }
            }
        }
    }
}
