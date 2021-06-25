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
    
    //MARK: - OVERRIDE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUsrData()
        
    }
    //MARK: - IBACTION METHODS
    @IBAction func actionLogOut(_ sender: UIButton){
        self.showAlertView(message: PopupMessages.sureToLogout, title: ALERT_TITLE_APP_NAME, doneButtonTitle: LocalStrings.ok, doneButtonCompletion: { (UIAlertAction) in
            self.logoutApiCall()
        }, cancelButtonTitle: LocalStrings.Cancel) { (UIAlertAction) in
            
        }
    }
    
    func setUsrData() {
        if let userData = UserDefaultsManager.shared.userInfo {
           
            lblTitle.text = userData.firstName + " " + userData.lastName
            lblEmail.text = userData.email
            setImageWithUrl(imageView: imgImageUser, url: userData.image)
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
