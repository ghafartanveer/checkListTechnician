//
//  WorkListViewController.swift
//  Checklist
//
//  Created by Rizwan Ali on 22/04/2021.
//

import UIKit


class WorkListViewController: BaseViewController, TopBarDelegate {
    //MARK: - IBOUTLETS
    @IBOutlet weak var searchBarTF: UITextField!
    @IBOutlet weak var viewTabel: UITableView!
    @IBOutlet weak var nextBtn: UIButton!
    
    //MARK: - OBJECT AND VERIABLES
    var categoryObject = CategoryListViewModel()
    var filteredList = [CategoryViewModel]()
    
    var selectedItems = [Int]()
    var notificationVM = NotificatioViewModel()
    //MARK: - OVERRIDE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBarTF.addTarget(self, action: #selector(searchFieldHandler(textField:)), for: .editingChanged)
        //Long Press
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPressGesture.minimumPressDuration = 0.5
        self.viewTabel.addGestureRecognizer(longPressGesture)
        //  FSCalendarScope.week
        // self.calender.to
        // Do any additional setup after loading the view.
        viewTabel.estimatedRowHeight = 90
        viewTabel.rowHeight = UITableView.automaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getCategoryListApi()
        //viewTabel.reloadData()
        nextBtn.isHidden = true
        selectedItems.removeAll()
        
        if let container = self.mainContainer {
            container.delegate = self
            
            container.setMenuButton(true, true, title: TitleNames.Work_List)
            
        }
    }
    //MARK: - FUNCTIONS
    
    @objc final private func searchFieldHandler(textField: UITextField) {
        print("Text changed", textField.text)
        
        if(textField.text == ""){
            self.categoryObject.categoryList = self.filteredList
            self.viewTabel.reloadData()
        }
        else{
            let filterdItemsArray = self.filteredList.filter({ ($0.name.lowercased().contains(textField.text!.lowercased()))
            })
            self.categoryObject.categoryList = filterdItemsArray
            
            self.viewTabel.reloadData()
            print(filterdItemsArray)
        }
    }
    
    @objc func handleLongPress(longPressGesture: UILongPressGestureRecognizer) {
        let p = longPressGesture.location(in: self.viewTabel)
        let indexPath = self.viewTabel.indexPathForRow(at: p)
        if indexPath == nil {
            print("Long press on table view, not row.")
        } else if longPressGesture.state == UIGestureRecognizer.State.began {
            let cell = viewTabel.cellForRow(at: indexPath!) as! WorkListTableViewCell
            viewTabel.beginUpdates()
            if cell.isSelected {
                cell.setSelected(false, animated: true)
                cell.viewShadow.borderColor = .clear
                print("Unselected row, at \(indexPath!.row)")
                if selectedItems.contains(indexPath!.row) {  selectedItems = selectedItems.filter { $0 != indexPath!.row } }
                
                if !selectedItems.isEmpty {
                    nextBtn.isHidden = false
                } else {
                    nextBtn.isHidden = true
                }
            } else {
                
                if Global.shared.checkInTaskSubmitions.contains(categoryObject.categoryList[indexPath!.row].id) {
                    
                    self.showAlertView(message: PopupMessages.taskIsSubmittedWithSameCheckIn)
                    
                }else if self.categoryObject.categoryList[indexPath!.row].taskSubCategory?.taskSubCategoryList.count == 0 {
                    self.showAlertView(message: PopupMessages.taskAreNotAddedYet)
                }  else {
                cell.setSelected(true, animated: true)
                cell.viewShadow.borderWidth = 5
                cell.viewShadow.borderColor = .gray
                print("Selected row, at \(indexPath!.row)")
                if !(selectedItems.contains(indexPath!.row)) { selectedItems.append(indexPath!.row) }
                }
            }
            if selectedItems.isEmpty {
                nextBtn.isHidden = true
            } else {
                nextBtn.isHidden = false
            }
            viewTabel.endUpdates()
        }
    }
    
    func actionBack() {
        if Global.shared.isFromNotification{
            if let contianer = self.mainContainer{
                Global.shared.isFromNotification = false
                Global.shared.notificationId = 0
                contianer.showHomeController()
            }
        }else{
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    func moveTocheckListVC() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: ControllerIdentifier.CheckListViewController) as! CheckListViewController
        print("Seleted items are : ")
        for item in selectedItems {
            vc.taskSubCategoryList.append(self.categoryObject.categoryList[item])
            vc.taskToBeSubmitedIDs.append(self.categoryObject.categoryList[item].id)

            print(item)
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //MARK: - IBUTlETS
    @IBAction func nextBtnAction(_ sender: Any) {
        // moveTocheckListVC()
        
        if Global.shared.checkInId > 0 {
            moveTocheckListVC()
        } else {
            self.showAlertView(message: PopupMessages.CheckInFirst)
        }
    }
    
    //MARK: - VehicleDetailPopUpViewController DELEGATE MEHTHOD
    override func callBackActionSave(txtVehicleNumber : String, txtCustomerName : String) {
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
        cell.isSelected = false
        cell.viewShadow.borderColor = .clear
        if selectedItems.contains(indexPath.row) {
            cell.setSelected(true, animated: true)
            cell.viewShadow.borderWidth = 5
            cell.viewShadow.borderColor = .gray
        } else {
            cell.setSelected(false, animated: true)
            cell.viewShadow.borderColor = .clear
        }
        cell.configureCategoryTask(info: self.categoryObject.categoryList[indexPath.row])
        cell.viewShadow.dropShadow(radius: 4, opacity: 0.3)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        self.categoryObject.categoryList[indexPath.row].isOpenOnce = true
        if Global.shared.checkInId > 0 {
            
            if Global.shared.checkInTaskSubmitions.contains(categoryObject.categoryList[indexPath.row].id) {
                
                self.showAlertView(message: PopupMessages.taskIsSubmittedWithSameCheckIn)
                
            } else if self.categoryObject.categoryList[indexPath.row].taskSubCategory?.taskSubCategoryList.count == 0 {
                tableView.deselectRow(at: [0,indexPath.row], animated: false)
                self.showAlertView(message: PopupMessages.taskAreNotAddedYet)
            } else {
            if selectedItems.isEmpty {
                selectedItems.append(indexPath.row)
                moveTocheckListVC()
            }
        }
        }else {
            self.showAlertView(message: PopupMessages.CheckInFirst)
        }
        //        if Global.shared.checkInId > 0 {
        //            moveTocheckListVC(index: indexPath.row)
        //        } else {
        //            self.showAlertView(message: PopupMessages.CheckInFirst)
        ////            self.showVehicleDetailPopUP()
        ////            self.alertView?.show()
        //        }
        //}
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//
//        if self.categoryObject.categoryList[indexPath.row].id == notificationVM.categoryId && Global.shared.isFromNotification && self.categoryObject.categoryList[indexPath.row].isOpenOnce{
//
//            cell.layer.transform = CATransform3DMakeScale(1,1,1)
//
//            Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true) {_ in
//                UIView.animate(withDuration: 1.5, animations: {
//                    cell.layer.transform = CATransform3DMakeScale(0.5,0.5,1)
//                                UIView.animate(withDuration: 1, animations: {
//                                    cell.layer.transform = CATransform3DMakeScale(1,1,1)
//                                        })
//                })
//            }
//
//
//
//
//        }
//
//    }
}
//MARK: - EXTENSION API CALLS
extension WorkListViewController{
    func getCategoryListApi(){
        self.startActivity()
        GCD.async(.Background) {
            CategoryServices.shared().categoryListApi(params: [:]) { (message, success, catInfo) in
                GCD.async(.Main) { [self] in
                    self.stopActivity()
                    if success{
                        if let category = catInfo{
                            self.categoryObject = category
                            self.filteredList.append(contentsOf: categoryObject.categoryList)
                            
                            if self.categoryObject.categoryList.count == 0 {
                                viewTabel.setNoDataMessage(LocalStrings.NoDataFound)
                            } else {
                                viewTabel.setNoDataMessage("")
                            }
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



