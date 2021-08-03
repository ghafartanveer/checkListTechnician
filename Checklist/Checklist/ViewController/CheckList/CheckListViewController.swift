//
//  CheckListViewController.swift
//  Checklist
//
//  Created by Rizwan Ali on 20/04/2021.
//

import UIKit

class CheckListViewController: BaseViewController, TopBarDelegate {
    //MARK: - Outlets
    @IBOutlet weak var questionListTV: UITableView!
    @IBOutlet weak var searchBarTF: UITextField!
    
    @IBOutlet weak var seachBarContainerView: UIView!
    @IBOutlet weak var topBarHeight: NSLayoutConstraint!
    @IBOutlet weak var saperationView: UIView!
    
    //MARK: - Variables/Objects
    var taskSubCategoryList: [CategoryViewModel] = []
    var filteredDataList: [CategoryViewModel] = []
    
    var taskToBeSubmitedIDs = [Int]()
    
    var isNoDataToShow = true
    
    var taskObjViewModel: TaskViewModel? = nil
    var categoryObj:Category? = nil
    
    //MARK: -  OverRide function
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        questionListTV.reloadData()

        for id in taskToBeSubmitedIDs {
            print(id)
        }
        for task in taskSubCategoryList {
            filteredDataList.append(task)
        }
        
        addDefaultValues()
        searchBarTF.addTarget(self, action: #selector(searchFieldHandler(textField:)), for: .editingChanged)
        
        if taskSubCategoryList.count == 1 {
            seachBarContainerView.isHidden = true
            topBarHeight.constant = 40
            saperationView.backgroundColor = .clear
        } else {
            saperationView.backgroundColor = .white
            seachBarContainerView.isHidden = false
            topBarHeight.constant = 90
        }
        
        if let container = self.mainContainer{
            container.delegate = self
            container.setMenuButton(true, true, title: TitleNames.checklistTaskList)
            
        }
        
        for sectionNo in 0..<taskSubCategoryList.count {
            for rowData in 0..<(taskSubCategoryList[sectionNo].taskSubCategory?.taskSubCategoryList.count ?? 0) {
                if rowData > 0 {
                    isNoDataToShow = false
                    break
                }
            }
        }
        if isNoDataToShow {
            questionListTV.setNoDataMessage(LocalStrings.NoDataFound)
        } else {
            questionListTV.removeBackground()
            
        }
        
        addDefaultValues()
            
    }
    
    
    //MARK: - IBOutlets
    @IBAction func nextButton(_ sender: Any) {
        
        for sectionNo in 0..<taskSubCategoryList.count {
            for rowData in 0..<(taskSubCategoryList[sectionNo].taskSubCategory?.taskSubCategoryList.count ?? 0) {
                
                taskObjViewModel?.categories[sectionNo].checkListQuestions[rowData].status = taskSubCategoryList[sectionNo].taskSubCategory?.taskSubCategoryList[rowData].status ?? QuestionListOptions.defaultValue
                
            }
        }
        
        var isAllSelected: Bool = true
        
        for sectionNo in 0..<taskSubCategoryList.count {
            for rowNo in 0..<(taskSubCategoryList[sectionNo].taskSubCategory?.taskSubCategoryList.count ?? 0) {
                if  taskSubCategoryList[sectionNo].taskSubCategory?.taskSubCategoryList[rowNo].status == QuestionListOptions.defaultValue {
                    isAllSelected = false
                    break
                }
            }
        }
        
        if isAllSelected {
            navigteToUploadFileVC()
        } else {
            self.showAlertView(message: PopupMessages.SelectAllOptions)
        }
       
    }
    
    //MARK: - functions
    
    @objc final private func searchFieldHandler(textField: UITextField) {
       // print("Text changed", textField.text)
        
        if(textField.text == ""){
                        taskSubCategoryList.removeAll()
                        for task in filteredDataList {
                            taskSubCategoryList.append(task)
                        }
            
            //self.taskSubCategoryList = self.filteredDataList
            self.questionListTV.reloadData()
        }
        else{
            taskSubCategoryList.removeAll()
            for task in filteredDataList {
                taskSubCategoryList.append(task)
                
            }
            
            for task in 0..<taskSubCategoryList.count {
                
                let filterdItemsArray = taskSubCategoryList[task].taskSubCategory?.taskSubCategoryList.filter({ ($0.subcategoryName.lowercased().contains(textField.text!.lowercased())) })
                
                taskSubCategoryList[task].taskSubCategory?.taskSubCategoryList = filterdItemsArray!
               
                self.questionListTV.reloadData()
            }
        }
    }
    
    func addDefaultValues() {
        
        var checkListQuestionObjData : [CheckListQuestion] = []
        var categoryObjArr: [Category] = []
        for sec in 0..<taskSubCategoryList.count {
            
            for r in 0..<(taskSubCategoryList[sec].taskSubCategory!.taskSubCategoryList.count ) {
                
                checkListQuestionObjData.append(CheckListQuestion.init(id: (taskSubCategoryList[sec].taskSubCategory?.taskSubCategoryList[r].id)!, sub_category_name: (taskSubCategoryList[sec].taskSubCategory?.taskSubCategoryList[r].subcategoryName)!, status: "4"))
                
            }
            
            categoryObj = Category.init(id: taskSubCategoryList[sec].id, hasImages: taskSubCategoryList[sec].hasImages, name: taskSubCategoryList[sec].name, checkListQuestions: checkListQuestionObjData)
            
            checkListQuestionObjData.removeAll()
            categoryObjArr.append(categoryObj!)
            
        }
        taskObjViewModel = TaskViewModel.init(activity_id: Global.shared.checkInId, description: "", categories: categoryObjArr)
       // print("Cat obj: ",categoryObj! as Any)
        
    }
    
    func actionBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func navigteToUploadFileVC() {
        let storyboard = UIStoryboard(name: StoryboardNames.Setting, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: ControllerIdentifier.UploadFileViewController) as! UploadFileViewController
        vc.taskSubCategoryList = taskSubCategoryList
        vc.taskViewModel = taskObjViewModel
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
//MARK: - EXTENISON TABEL VIEW METHODS

extension CheckListViewController: UITableViewDelegate, UITableViewDataSource{
    //        func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    //            taskSubCategoryList[section].name
    //        }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return taskSubCategoryList.count
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if taskSubCategoryList.count == 1 {
            return 10
        }
        return 70
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if taskSubCategoryList.count == 1 {
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 10))
            headerView.backgroundColor = .clear
            return headerView
        }
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
        headerView.backgroundColor = .clear
        let label = UILabel(frame: CGRect(x: 20, y: 7, width: headerView.frame.width, height: headerView.frame.height))
        label.text = taskSubCategoryList[section].name
        let boldAttribute = [
            NSAttributedString.Key.font: UIFont(name: "Poppins SemiBold", size: 18.0) ?? UIFont.systemFont(ofSize: 18)
        ]
        let boldTitleText = NSAttributedString(string: taskSubCategoryList[section].name, attributes: boldAttribute)
        label.attributedText = boldTitleText
        headerView.addSubview(label)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (taskSubCategoryList[section].taskSubCategory?.taskSubCategoryList.count ?? 0) > 0 {
            self.isNoDataToShow = false
        }
        return taskSubCategoryList[section].taskSubCategory?.taskSubCategoryList.count ?? 0 //taskSubCategoryList.taskSubCategory?.taskSubCategoryList.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.CheckListTableViewCell) as! CheckListTableViewCell
        let data = taskSubCategoryList[indexPath.section].taskSubCategory?.taskSubCategoryList[indexPath.row]
        cell.delegate = self
        
        cell.btnYes.tag = (indexPath.section*1000) + indexPath.row
        cell.btnNo.tag = (indexPath.section*1000) + indexPath.row
        cell.btnNotAvailable.tag = (indexPath.section*1000) + indexPath.row
        cell.cofigureCellData(info: data!, index: indexPath.row)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenSize.SCREEN_WIDTH, height: 2))
        let inerView = UIView(frame: CGRect(x: (footerView.frame.origin.x + 80), y: 0, width: footerView.frame.size.width - 160, height: 2))
        inerView.backgroundColor = .black
        footerView.backgroundColor = .clear
        footerView.addSubview(inerView)
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 2
    }
}

extension CheckListViewController: CheckListTableViewCellDelegate {
    
    func yesBtn(btn: UIButton) {
        let btnTag = btn.tag
        
        let btnRow = btnTag % 1000
        let btnSection = btnTag / 1000
       
        taskSubCategoryList[btnSection].taskSubCategory?.taskSubCategoryList[btnRow].status = QuestionListOptions.yes
        //print("Section: ", btnSection, "Row : ",btnRow )
        questionListTV.reloadData()
        
    }
    
    func noBtn(btn: UIButton) {
        let btnTag = btn.tag
        
        let btnRow = btnTag % 1000
        let btnSection = btnTag / 1000
        
        taskSubCategoryList[btnSection].taskSubCategory?.taskSubCategoryList[btnRow].status = QuestionListOptions.no
       // print("Section: ", btnSection, "Row : ",btnRow )
        questionListTV.reloadData()
        
    }
    
    func notAvalable(btn: UIButton) {
        let btnTag = btn.tag
        
        let btnRow = btnTag%1000
        let btnSection = btnTag/1000
        
        taskSubCategoryList[btnSection].taskSubCategory?.taskSubCategoryList[btnRow].status = QuestionListOptions.notAvilAble
    
       // print("Section: ", btnSection, "Row : ",btnRow )
        questionListTV.reloadData()
        
    }
}

//======================================
// to create Params for submit_Task Api
// MARK: - TaskViewModel
struct TaskViewModel {
    var activity_id: Int
    var description: String
    var categories: [Category]
    
    func getParams() -> ParamsAny {
        
        var categoryParam = [ParamsAny]()
        
        for cat in categories {
            var listParam = [ParamsAny]()
            for list in cat.checkListQuestions{
                let listquesParam : ParamsAny = ["id":list.id, "sub_category_name": list.sub_category_name,"status": list.status]
                listParam.append(listquesParam)
            }
            
            let innerCategoryParam : ParamsAny = ["id" : cat.id,"name" : cat.name,"hasImages": cat.hasImages,"checkListQuestions" :listParam ]
            categoryParam.append(innerCategoryParam)
            
        }
        let param: ParamsAny = ["activity_id" : activity_id, "description" : description, "categories" : categoryParam]
        return param
    }
    
}

// MARK: - Category
struct Category {
    var id,hasImages : Int
    var name : String
    var checkListQuestions: [CheckListQuestion]
}

// MARK: - CheckListQuestion
struct CheckListQuestion {
    var id : Int
    var sub_category_name, status: String
}
