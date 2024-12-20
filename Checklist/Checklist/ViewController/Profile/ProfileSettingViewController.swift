//
//  SettingViewController.swift
//  Checklist
//
//  Created by Rizwan Ali on 22/04/2021.
//

import UIKit
import CropViewController

class ProfileSettingViewController: BaseViewController, TopBarDelegate {
    
    @IBOutlet weak var imgProfile: UIImageView!
    
    @IBOutlet weak var imageContainerV: UIView!
    @IBOutlet weak var fNameTF: UITextField!
    @IBOutlet weak var lNameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    
    @IBOutlet weak var fNameUnderLineView: UIView!
    @IBOutlet weak var lNameUnderLineView: UIView!
    @IBOutlet weak var emailUnderLineView: UIView!
    @IBOutlet weak var phoneUnderLineView: UIView!
    
    @IBOutlet weak var ContainerView: UIView!
    //MARK: - OVERRIDE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()

        setUsrData()
        ContainerView.dropShadow()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let container = self.mainContainer{
            container.delegate = self
            container.setMenuButton(true, title: TitleNames.Setting)
        }
        imageContainerV.layer.cornerRadius = 60
        imageContainerV.clipsToBounds = true
        //imageContainerV.dropShadow()

    }
    //MARK: - IBACTION METHODS
    @IBAction func actionChangePassword(_ sender: UIButton){
        self.showChangePasswordPopUP()
        self.alertView?.show()
    }
    
    @IBAction func actionChoosePhoto(_ sender:UIButton){
        self.fetchProfileImage()
    }
    
    @IBAction func actionSave(_ sender:UIButton){
        
        let imageData = ((imgProfile.image) ?? #imageLiteral(resourceName: "user_image") ) .jpegData(compressionQuality: 1.0)
    
        if self.checkValidations(){
            let iss_payable = 0
            let storId = String(Global.shared.user.storeID)
            let userId = String(Global.shared.user.id)
            //let pasword = Global.shared.user.pass
            self.updateProfileServerCall(params: [DictKeys.email: self.emailTF.text!,
                                         DictKeys.first_name: self.fNameTF.text!,
                                                  DictKeys.login_type: LoginType.Technician, DictKeys.last_name: self.lNameTF.text!, DictKeys.phone_number: self.phoneTF.text!, DictKeys.Store_Id : storId, DictKeys.User_Id : userId , DictKeys.is_payable : iss_payable], imageDic: [DictKeys.image : imageData]  )
            
        }
        
    }
    
    //MARK: - FUNCTIONS
    
    func checkValidations() -> Bool{
        var isValid: Bool = true
        let validEmail = Validations.emailValidation(self.emailTF.text!)
        let validFName = Validations.nameValidation(self.fNameTF.text!)
        let validLName = Validations.nameValidation(self.lNameTF.text!)
        let validPhone = Validations.phoneNumberValidation(self.phoneTF.text!)
        
        if !validEmail.isValid{
            self.showAlertView(message: validEmail.message)
            isValid = false
        }else if !validFName.isValid{
            self.showAlertView(message: validFName.message)
            isValid = false
        }else if !validLName.isValid{
            self.showAlertView(message: validLName.message)
            isValid = false
        }else if !validPhone.isValid{
            self.showAlertView(message: validPhone.message)
            isValid = false
        }
        return isValid
    }

    
    func actionBack() {
        self.loadHomeController()
    }
    
    override func callBackActionSubmit(crntPswd : String , newPasword: String) {
        let params: ParamsAny = [DictKeys.Current_Password: crntPswd, DictKeys.New_Password: newPasword ]
        self.changePasswordApiCall(Params: params)
        
        self.alertView?.close()
    }
    
    func setUsrData() {
        if let userData = UserDefaultsManager.shared.userInfo {
            fNameTF.text = userData.firstName
            lNameTF.text = userData.lastName
            emailTF.text = userData.email
            phoneTF.text = userData.phoneNumber
            
            
            if !(userData.image.isEmpty) {
                setImageWithUrl(imageView: imgProfile, url: userData.image)
                imgProfile.backgroundColor = .white
            }else {
                //setBtnImageWithUrl(btn: container.btnRightMenu, urlStr: userData.image)
                imgProfile.backgroundColor = .gray
                imgProfile.image = UIImage(named: "user_image")
            }
            
        }
    }
    
    func setUnderLineBGColor(view: UIView) {
        
        let inativeBottomLinecolor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        
        fNameUnderLineView.backgroundColor = inativeBottomLinecolor
        lNameUnderLineView.backgroundColor = inativeBottomLinecolor
        emailUnderLineView.backgroundColor = inativeBottomLinecolor
        phoneUnderLineView.backgroundColor = inativeBottomLinecolor
        view.backgroundColor = UIColor(named: AssetColors.pinkThemeColor)
    }
    
    //MARK: - IMAGE PICKER CONTROLLER DELEGATE METHODS
//    override func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
//        self.imgProfile.image = image
//        picker.dismiss(animated: true, completion: nil)
//    }
    
    override func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        cropViewController.dismiss(animated: true, completion: nil)
        
        self.imgProfile.image = image
        // 'image' is the newly cropped version of the original image
    }
    
}

extension ProfileSettingViewController :  UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case fNameTF:
            setUnderLineBGColor(view: fNameUnderLineView)
        case lNameTF:
            setUnderLineBGColor(view: lNameUnderLineView)
        case emailTF:
            setUnderLineBGColor(view: emailUnderLineView)
        case phoneTF:
            setUnderLineBGColor(view: phoneUnderLineView)
        default:
            print("default not defined yet")
        }
    }
}

//MARK: - Server Calls
extension ProfileSettingViewController {
    
    func updateProfileServerCall(params: ParamsAny, imageDic: [String:Data?]){
        self.startActivity()
        GCD.async(.Background) {
            LoginService.shared().updateProfileApi(params: params,profileImg: imageDic) { (message, success, userInfo) in
                GCD.async(.Main) { [self] in
                    self.stopActivity()
                    if success{
                        self.showAlertView(message: message)
                        self.setUsrData()
//                        self.showAlertView(message: message, title: "", doneButtonTitle: "Ok") { (UIAlertAction) in
//                            self.loadHomeController()
//                            //self.navigationController?.popViewController(animated: true)
//                        }
                        
                        
                      //  self.showAlertView(message: message)
                    
                    }else{
                        self.showAlertView(message: message)
                    }
                }
                
            }
        }
    }
   
    func changePasswordApiCall(Params: ParamsAny){
        self.startActivity()
        GCD.async(.Background) {
            LoginService.shared().changePasswordApi(params: Params) { (message, success) in
                GCD.async(.Main) {
                    self.stopActivity()
                    
                    if success{
                        self.showAlertView(message: message, title: "", doneButtonTitle: "Ok") { (UIAlertAction) in
                            self.alertView?.close()
                        }
                        
                    }else{
                        self.showAlertView(message: message)
                    }
                }
            }
        }
    }

}
