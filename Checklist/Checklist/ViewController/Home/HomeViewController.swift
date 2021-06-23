//
//  HomeViewController.swift
//  Checklist
//
//  Created by Rizwan Ali on 20/04/2021.
//

import UIKit

class HomeViewController: BaseViewController {
    //MARK: - IBOUTLETS
    @IBOutlet weak var btnPlusShadow: UIButton!
    @IBOutlet weak var tabelView: UITableView!
    
    //MARK: - OVERRIDE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // self.btnPlusShadow.dropShadow(radius: 3, opacity: 0.2)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let container = self.mainContainer{
            container.setMenuButton(false, title: "")//TitleNames.Home)
            
            container.btnRightMenu.cornerRadius = container.btnRightMenu.frame.height/2
            container.btnRightMenu.clipsToBounds = true
        
            if let userData = UserDefaultsManager.shared.userInfo {
            setBtnImageWithUrl(btn: container.btnRightMenu, urlStr: userData.image)
            }
        }
    }
    
    override func callBackActionSave(txtVehicleNumber : String, txtCustomerName :String) {
        let userId = String(UserDefaultsManager.shared.userInfo.id)
        
        self.checkInServerCall(params: [DictKeys.User_Id: userId,
                                 DictKeys.customer_name: txtCustomerName,
                                 DictKeys.registration_number: txtVehicleNumber])
        self.alertView?.close()
    }
    
    //MARK: - IBACTION METHODS
    @IBAction func actionAddTask(_ sender: UIButton){
        
    }
    
    //MARK: - FUNCTIONS
    func moveToWorkListVC(indexPath: Int){
        //var isHistory = false
        //if indexPath == 3{
//        if indexPath == 1 {
//            isHistory = true
//        }
        let vc = self.storyboard?.instantiateViewController(withIdentifier: ControllerIdentifier.WorkListViewController) as! WorkListViewController
       // vc.isFromHistory = isHistory
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func moveToTaskListHistiryVC() {
               
        let vc = self.storyboard?.instantiateViewController(withIdentifier: ControllerIdentifier.CheckListHistoryViewController) as! CheckListHistoryViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
//MARK: - EXTENSION TABEL VIEW METHODS
extension HomeViewController: UITableViewDelegate, UITableViewDataSource, TaskCategoryTableViewCellDelegate{
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        //return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1

//        if section == 1{
//            return 2
//        }else{
//            return 1
//        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.TaskCategoryTableViewCell) as! TaskCategoryTableViewCell
        
            cell.delegate = self
            cell.viewCollection.reloadData()
            return cell
        //}
//        else{
//            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.TaskTypesTableViewCell) as! TaskTypesTableViewCell
//            cell.ConfigureTypes(index: indexPath.row)
//
//            return cell
//        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        if indexPath.section == 1{
//            if indexPath.row == 0 || indexPath.row == 3{
//                self.moveToWorkListVC(indexPath: indexPath.row)
//               
//            }else{
//                let vc = self.storyboard?.instantiateViewController(withIdentifier: ControllerIdentifier.WorkListViewController) as! WorkListViewController
//                self.navigationController?.pushViewController(vc, animated: true)
//            }
//        }
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
//        if indexPath.section == 0{
//            return 420
//
//        }else{
//            return 80
//        }
    }
    
    //MARK: - DELEGATE METHODS
    func callBackMoveOnContoller(index: Int) {
        switch index {
        case 0:
            moveToWorkListVC(indexPath: index)
            print("Check In")
        case 1:
            moveToTaskListHistiryVC()
            print("History")
        case 2:
            showVehicleDetailPopUP()
            self.alertView?.show()
            print("Show check in popUp")
        case 3:
            print("Check Out")

        default:
            print("Default case")
        }
        
//        if index == 1 || index == 3{
//            self.moveToWorkListVC(indexPath: index)
//        }else{
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: ControllerIdentifier.CalenderViewController) as! CalenderViewController
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
        
    }
}

//MARK: - CheckInApiCall
extension HomeViewController {
    
    func checkInServerCall(params: ParamsString){
        self.startActivity()
        GCD.async(.Background) {
            CheckInOutServic.shared().checkInApi(params: params) { (message, success, checkInInfo) in
                GCD.async(.Main) { [self] in
                    self.stopActivity()
                    if success{
                        if let chinInDetail = checkInInfo{
                           
                           
                                self.showAlertView(message: message)
                                Global.shared.checkInId = chinInDetail.id
                            
                            // use data here
                          
                        }
                    }else{
                        self.showAlertView(message: message)
                    }
                }
            }
        }
    }
}
