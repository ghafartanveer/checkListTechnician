//
//  WorkListViewController.swift
//  Checklist
//
//  Created by Rizwan Ali on 22/04/2021.
//

import UIKit


class WorkListViewController: BaseViewController, TopBarDelegate {
    //MARK: - IBOUTLETS
    @IBOutlet weak var viewTabel: UITableView!
    
    //MARK: - OBJECT AND VERIABLES
    var categoryObject = CategoryListViewModel()
    var isFromHistory: Bool = false
    
    
    //MARK: - OVERRIDE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getCategoryListApi()
        //  FSCalendarScope.week
        // self.calender.to
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let container = self.mainContainer{
            container.delegate = self
            if self.isFromHistory{
                container.setMenuButton(true, true, title: TitleNames.History)
            }else{
                container.setMenuButton(true, true, title: TitleNames.Work_List)
            }
            
        }
    }
    //MARK: - FUNCTIONS
    
    func actionBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: - VehicleDetailPopUpViewController DELEGATE MEHTHOD
    override func callBackActionSave() {
        self.alertView?.close()
        GCD.async(.Main, delay: 0.3) {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: ControllerIdentifier.CheckListViewController) as! CheckListViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}


//MARK: - EXTENISON TABEL VIEW METHODS
extension WorkListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categoryObject.categoryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.WorkListTableViewCell) as! WorkListTableViewCell
        cell.configureCategoryTask(info: self.categoryObject.categoryList[indexPath.row])
        cell.viewShadow.dropShadow(radius: 4, opacity: 0.3)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !self.isFromHistory{
            self.showVehicleDetailPopUP()
            self.alertView?.show()
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    
}
//MARK: - EXTENSION API CALLS
extension WorkListViewController{
    func getCategoryListApi(){
        self.startActivity()
        GCD.async(.Background) {
            CategoryServices.shared().categoryListApi(params: [:]) { (message, success, catInfo) in
                GCD.async(.Main) {
                    self.stopActivity()
                    if success{
                        if let category = catInfo{
                            self.categoryObject = category
                            self.viewTabel.reloadData()
                        }
                        
                    }else{
                        self.showAlertView(message: message)
                    }
                }
            }
        }
    }
}
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//
//        let size = tableView.cellForRow(at: indexPath)!.frame.size.height
//        let backView = UIView(frame: CGRect(x: 0, y: 15, width: 72, height: 75))
//        backView.backgroundColor = .white
//        backView.cornerRadius = 5
//        backView.dropShadow(radius: 2, opacity: 0.1)
//        let myImage = UIImageView(frame: CGRect(x: 15, y: 25, width: 40, height: 40))
//        myImage.contentMode = .scaleAspectFill
//        myImage.image = UIImage(named: AssetNames.Delete_Icon)
//        backView.addSubview(myImage)
//
//        //    myImage.translatesAutoresizingMaskIntoConstraints = false
//        //    myImage.centerXAnchor.constraint(equalTo: backView.centerXAnchor).isActive = true
//        //    myImage.centerYAnchor.constraint(equalTo: backView.centerYAnchor).isActive = true
//        //
//        let imgSize: CGSize = tableView.frame.size
//        UIGraphicsBeginImageContextWithOptions(imgSize, false, UIScreen.main.scale)
//        let context = UIGraphicsGetCurrentContext()
//        backView.layer.render(in: context!)
//        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
//        UIGraphicsEndImageContext()
//        let delete = UITableViewRowAction(style: .normal, title: "") { (action, indexPath) in
//            print("Delete")
//           // self.deletePatient(index: indexPath.row)
//        }
//        delete.backgroundColor = UIColor(patternImage: newImage)
//        let backView1 = UIView(frame: CGRect(x: 0, y: 15, width: 72, height: 75))
//        backView1.backgroundColor = .white
//        backView1.cornerRadius = 5
//        backView1.dropShadow(radius: 2, opacity: 0.1)
//        let myImage1 = UIImageView(frame: CGRect(x: 15, y: 25, width: 40, height: 40))
//        myImage1.image = UIImage(named: AssetNames.Edit_Icon)
//        myImage1.contentMode = .scaleAspectFit
//        myImage1.tintColor = .white
//        backView1.addSubview(myImage1)
//        myImage1.translatesAutoresizingMaskIntoConstraints = false
//        myImage1.centerXAnchor.constraint(equalTo: backView1.centerXAnchor).isActive = true
//        myImage1.centerYAnchor.constraint(equalTo: backView1.centerYAnchor).isActive = true
//        let imgSize1: CGSize = tableView.frame.size
//        UIGraphicsBeginImageContextWithOptions(imgSize1, false, UIScreen.main.scale)
//        let context1 = UIGraphicsGetCurrentContext()
//        backView1.layer.render(in: context1!)
//        let newImage1: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
//        UIGraphicsEndImageContext()
//        let Edit = UITableViewRowAction(style: .destructive, title: "") { (action, indexPath) in
////            let storyboard = UIStoryboard.init(name: "Patient", bundle: nil)
////            let vc = storyboard.instantiateViewController(withIdentifier: ControllerIdentifier.AddPatientViewController) as! AddPatientViewController
////            vc.isForEditPatient = true
////            if(self.isDataFound){
////                vc.patientData = self.searchData[indexPath.row]
////            }
////            else if(!self.isFromSearch){
////                vc.patientData = self.pateintList.pateintList[indexPath.row]
////            }
////            self.navigationController?.pushViewController(vc, animated: true)
//        }
//        Edit.backgroundColor = UIColor(patternImage: newImage1)
//        return [delete,Edit]
//    }



