//
//  MainContainerViewController.swift
//  SimSwitch
//
//  Created by Gulfam Khan on 30/10/2019.
//  Copyright © 2019 Rapidzz. All rights reserved.
//

import UIKit

class MainContainerViewController: BaseViewController, SWRevealViewControllerDelegate{
    
    //MARK: - IBOUTLETS
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var btnRightMenu: UIButton!
    @IBOutlet weak var viewTopColour: UIView!
    
    
    //MARK: - OBJECT AND VERIABLES
    weak var delegate:TopBarDelegate?
    var baseNavigationController: BaseNavigationController?
    
    //MARK: - OVERRID METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        if revealViewController() != nil{
            revealViewController()?.panGestureRecognizer()
            revealViewController()?.tapGestureRecognizer()
            revealViewController()?.rearViewRevealWidth = 320
            revealViewController()?.delegate = self
            self.btnMenu.addTarget(revealViewController(), action: #selector(SWRevealViewController.revealToggle(_ :)), for: .touchUpInside)
        }
         self.showHomeController()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        if let container = self.mainContainer{
//            container.setTitle(title: "Settings")
//        }
//    }
    
    //MARK: - IBACTION METHODS
    @IBAction func actionSideMenu(_ sender: UIButton) {
        if revealViewController() != nil{
            revealViewController()?.panGestureRecognizer()
            revealViewController()?.tapGestureRecognizer()
            revealViewController()?.rearViewRevealWidth = 320
            revealViewController()?.delegate = self
            self.btnMenu.addTarget(revealViewController(), action: #selector(SWRevealViewController.revealToggle(_ :)), for: .touchUpInside)
        }
    }
    
    @IBAction func actionRightMenu(_ sender: Any) {
        
    }
    @IBAction func actionBack(_ sender: Any) {
        delegate?.actionBack()
    }
    
    //MARK:- FUNCTIONS
    func setMenuButton(_ isBack: Bool = false,_ isWhiteBtnBack: Bool = false, title: String)  {
        if(isBack){
            self.btnRightMenu.isHidden = true
            self.btnMenu.removeTarget(nil, action: nil, for: .allEvents)
            self.btnMenu.setImage(UIImage(named: AssetNames.Back_Icon)!, for: .normal)
            self.btnMenu.addTarget(self, action: #selector(MainContainerViewController.actionBack(_:)), for: .touchUpInside)
        }else{
            self.btnRightMenu.isHidden = false
            self.btnMenu.setImage(UIImage(named: AssetNames.sideLogo)!, for: .normal)
            self.btnMenu.addTarget(self, action: #selector(actionSideMenu(_:)), for: .touchUpInside)
        }
        if isWhiteBtnBack{
            self.viewTopColour.backgroundColor = UIColor.init(hexFromString: "#FA1100")
            self.titleLabel.textColor = .white
            self.btnMenu.tintColor = .white
        }else{
            self.viewTopColour.backgroundColor = UIColor.init(hexFromString: "#FA1100")
            self.titleLabel.textColor = .white
            self.btnMenu.tintColor = .white
//            self.viewTopColour.backgroundColor = UIColor.init(hexFromString: "#FAFAFA")
//            self.titleLabel.textColor = .black
//            self.btnMenu.tintColor = .black
        }
        self.titleLabel.text = title
    }
    
    func showHomeController()  {
        let storyBoard = UIStoryboard(name: StoryboardNames.Home, bundle: nil)
        var controller = BaseNavigationController()
        controller = storyBoard.instantiateViewController(withIdentifier: ControllerIdentifier.HomeVC) as! BaseNavigationController
        if let oldRef = self.baseNavigationController {
            oldRef.viewDidDisappear(true)
            oldRef.view.removeFromSuperview()
        }
        self.baseNavigationController = controller
        addChild(controller)
        controller.view.frame = self.viewContainer.bounds
        self.viewContainer.addSubview(controller.view)
        controller.didMove(toParent: self)
    }
    
    func showSettingController()  {
        let storyBoard = UIStoryboard(name: StoryboardNames.Setting, bundle: nil)
        var controller = BaseNavigationController()
        controller = storyBoard.instantiateViewController(withIdentifier: ControllerIdentifier.settingVC) as! BaseNavigationController
        if let oldRef = self.baseNavigationController {
            oldRef.viewDidDisappear(true)
            oldRef.view.removeFromSuperview()
        }
        self.baseNavigationController = controller
        addChild(controller)
        controller.view.frame = self.viewContainer.bounds
        self.viewContainer.addSubview(controller.view)
        controller.didMove(toParent: self)
    }
    
    func logoutUser()  {
        Global.shared.user = nil
        Global.shared.isLogedIn = false
        UserDefaultsManager.shared.clearUserData()
        UserDefaultsManager.shared.clearToken()
        
        let storyboard = UIStoryboard(name: StoryboardNames.Registration, bundle: nil)
        //        let vc = storyboard.instantiateViewController(withIdentifier: ControllerIdentifier.LoginViewController) as! LoginViewController
        //        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}



