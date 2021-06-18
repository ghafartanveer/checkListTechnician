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
    
    func actionBack() {
        self.loadHomeController()
    }
    
    func setLayout() {
        userDetailContainerView.addshadow()
        nameFieldContainerView.addshadow()
        emailFieldContainerView.addshadow()
        subjectTextVContinerView.addshadow()
    }
    
    func setUserData() {
        if let userData = UserDefaultsManager.shared.userInfo {
            
            phoneNumberLbl.text = userData.phoneNumber
            emailLbl.text = userData.email
            
        }
    }
    
}
