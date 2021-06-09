//
//  SettingViewController.swift
//  Checklist
//
//  Created by Rizwan Ali on 22/04/2021.
//

import UIKit

class ProfileSettingViewController: BaseViewController, TopBarDelegate {
   
    @IBOutlet weak var imgProfile: UIImageView!
    
    
    //MARK: - OVERRIDE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    //MARK: - IMAGE PICKER CONTROLLER DELEGATE METHODS
    override func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        self.imgProfile.image = image
        picker.dismiss(animated: true, completion: nil)
    }
}
