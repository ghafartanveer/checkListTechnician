//
//  SideMenuViewController.swift
//  Checklist
//
//  Created by Rizwan Ali on 19/04/2021.
//

import UIKit

class SideMenuViewController: BaseViewController {
    //MARK: - IBOUTLETS
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var imgImageUser: UIImageView!
    @IBOutlet weak var logoutIcon: UIImageView!
    
    //MARK: - OVERRIDE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // setUsrData()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setUsrData()

    }
    //MARK: - IBACTION METHODS
    @IBAction func actionLogOut(_ sender: UIButton){
        
        if Global.shared.checkInId > 0 {
            self.showAlertView(message: PopupMessages.checkOutFirst, title: ALERT_TITLE_APP_NAME, doneButtonTitle: LocalStrings.ok, doneButtonCompletion: { (UIAlertAction) in
                self.revealViewController()?.revealToggle(nil)
            }, cancelButtonTitle: LocalStrings.Cancel) { (UIAlertAction) in
                
            }
        } else {
        
        self.showAlertView(message: PopupMessages.sureToLogout, title: ALERT_TITLE_APP_NAME, doneButtonTitle: LocalStrings.ok, doneButtonCompletion: { (UIAlertAction) in
            
            self.logoutApiCall()
        }, cancelButtonTitle: LocalStrings.Cancel) { (UIAlertAction) in
            
        }
            
        }
    }
    
    func setUsrData() {
        
        logoutIcon.tintColor = #colorLiteral(red: 0.9803921569, green: 0.06666666667, blue: 0, alpha: 1)
        if let userData = UserDefaultsManager.shared.userInfo {
           
            lblTitle.text = userData.firstName + " " + userData.lastName
            lblEmail.text = userData.email
            
            
            if !(userData.image.isEmpty) {
                setImageWithUrl(imageView: imgImageUser, url: userData.image)
                imgImageUser.backgroundColor = .white
            }else {
                //setBtnImageWithUrl(btn: container.btnRightMenu, urlStr: userData.image)
                imgImageUser.backgroundColor = .gray
                imgImageUser.image = UIImage(named: "user_image")
            }
            
            
            
            //setImageWithUrl(imageView: imgImageUser, url: userData.image)
        }
    }
    
}


//MARK: - EXTENISON TABEL VIEW METHODS
extension SideMenuViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SideMenu.MENULIST.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.SideMenuTableViewCell) as! SideMenuTableViewCell
        cell.configureMenu(info: SideMenu.MENULIST[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let container = self.revealViewController()?.frontViewController as? MainContainerViewController{
            self.revealViewController()?.revealToggle(nil)
            switch indexPath.item {
            case 0:
                container.showHomeController()
            case 1:
                container.showAboutUsController()
            case 2:
                container.showHelpController()
            case 3:
                container.showSettingController()
            default:
                print("Default case is not yet defined")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

//MARK: - EXTENSION API CALLS
extension SideMenuViewController{
    func logoutApiCall(){
        self.startActivity()
        GCD.async(.Background) {
            LoginService.shared().logoutUserApi(params: [:]) { (message, success) in
                GCD.async(.Main) {
                    self.stopActivity()
                    
                    if success{
                        self.showAlertView(message: message, title: "", doneButtonTitle: "Ok") { (UIAlertAction) in
                            self.logoutUserAccount()
                        }
                        
                    }else{
                        self.showAlertView(message: message)
                    }
                }
            }
        }
    }
    
}
