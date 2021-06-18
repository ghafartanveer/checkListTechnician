//
//  SettingViewController.swift
//  Checklist
//
//  Created by Rizwan Ali on 22/04/2021.
//

import UIKit

class ProfileSettingViewController: BaseViewController, TopBarDelegate {
    
    @IBOutlet weak var imgProfile: UIImageView!
    
    @IBOutlet weak var fNameTF: UITextField!
    @IBOutlet weak var lNameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    
    @IBOutlet weak var fNameUnderLineView: UIView!
    @IBOutlet weak var lNameUnderLineView: UIView!
    @IBOutlet weak var emailUnderLineView: UIView!
    @IBOutlet weak var phoneUnderLineView: UIView!
    
    //MARK: - OVERRIDE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()

        setUsrData()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let container = self.mainContainer{
            container.delegate = self
            container.setMenuButton(true, title: TitleNames.Setting)
        }
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
       
    }
    
    //MARK: - FUNCTIONS
    func actionBack() {
        self.loadHomeController()
    }
    
    override func callBackActionSubmit() {
        self.alertView?.close()
    }
    
    func setUsrData() {
        if let userData = UserDefaultsManager.shared.userInfo {
            fNameTF.text = userData.firstName
            lNameTF.text = userData.lastName
            emailTF.text = userData.email
            phoneTF.text = userData.phoneNumber
            setImageWithUrl(imageView: imgProfile, url: userData.image)
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
    override func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        self.imgProfile.image = image
        picker.dismiss(animated: true, completion: nil)
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
