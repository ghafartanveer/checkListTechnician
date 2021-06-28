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
    var categoryListViewModel = CategoryListViewModel()
    var taskSubCategoryList: [CategoryViewModel] = [] //.
    var filteredDataList: [CategoryViewModel] = []
    
    var checkinObj = CheckInViewModel()
    var taskObj: TaskViewModel? = nil
    var categoryObj:Category? = nil //.
    var checkListQuestionObj:CheckListQuestion? = nil
    
    
    //MARK: -  OverRide function
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        questionListTV.reloadData()
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
            container.setMenuButton(true, true, title: TitleNames.Check_List)
            
        }
        
        addDefaultValues()
    }
    //MARK: - IBOutlets
    @IBAction func nextButton(_ sender: Any) {
        var isAllSelected: Bool = true

        for i in 0..<(taskObj?.categories.count ?? 0) {
            let filteredDates = taskObj?.categories[i].checkListQuestions.filter { $0.status == QuestionListOptions.defaultValue
            }
            if filteredDates?.count ?? 0 > 0 {
                self.showAlertView(message: PopupMessages.SelectAllOptions)
                isAllSelected = false
                break
            }
        }
        
        if isAllSelected {
            navigteToUploadFileVC()
        }
       
    }
    
    //MARK: - fiunctions
    
    @objc final private func searchFieldHandler(textField: UITextField) {
        print("Text changed", textField.text)
        
        if(textField.text == ""){
            self.categoryListViewModel.categoryList = self.filteredDataList
            self.questionListTV.reloadData()
        }
        else{
            let filterdItemsArray = self.filteredDataList.filter({ ($0.name.lowercased().contains(textField.text!.lowercased())) })
            
            self.categoryListViewModel.categoryList = self.filteredDataList
            self.questionListTV.reloadData()
            print(filterdItemsArray)
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
        taskObj = TaskViewModel.init(activity_id: Global.shared.checkInId, description: "", categories: categoryObjArr)
        print("Cat obkj: ",categoryObj! as Any)
        
    }
    
    func actionBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func navigteToUploadFileVC() {
        let storyboard = UIStoryboard(name: StoryboardNames.Setting, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: ControllerIdentifier.UploadFileViewController) as! UploadFileViewController
        vc.taskSubCategoryList = taskSubCategoryList
        vc.categoryListViewModel = categoryListViewModel
        vc.taskViewModel = taskObj
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
//MARK: - EXTENISON TABEL VIEW METHODS

extension CheckListViewController: UITableViewDelegate, UITableViewDataSource{
    //    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    //        taskSubCategoryList[section].name
    //    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return taskSubCategoryList.count //taskSubCategoryList.taskSubCategory?.//taskSubCategoryList.count ?? 0
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
        //label.text = taskSubCategoryList[section].name
        let boldAttribute = [
            NSAttributedString.Key.font: UIFont(name: "Poppins SemiBold", size: 18.0) ?? UIFont.systemFont(ofSize: 18)
        ]
        let boldTitleText = NSAttributedString(string: taskSubCategoryList[section].name, attributes: boldAttribute)
        label.attributedText = boldTitleText
        headerView.addSubview(label)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskSubCategoryList[section].taskSubCategory?.taskSubCategoryList.count ?? 0 //taskSubCategoryList.taskSubCategory?.taskSubCategoryList.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.CheckListTableViewCell) as! CheckListTableViewCell
        let data = taskSubCategoryList[indexPath.section].taskSubCategory?.taskSubCategoryList[indexPath.row]
        cell.delegate = self
        
        cell.btnYes.tag = (indexPath.section*1000) + indexPath.row
        cell.btnNo.tag = (indexPath.section*1000) + indexPath.row
        cell.btnNotAvailable.tag = (indexPath.section*1000) + indexPath.row
        
        
        let status = taskObj?.categories[indexPath.section].checkListQuestions[indexPath.row].status
        switch status {
        case QuestionListOptions.yes:
            cell.setBtnState(yes: true, no: false, notAvailable: false, default: false)
        case QuestionListOptions.no:
            cell.setBtnState(yes: false, no: true, notAvailable: false, default: false)
        case QuestionListOptions.notAvilAble:
            cell.setBtnState(yes: false, no: false, notAvailable: true, default: false)
        case QuestionListOptions.defaultValue:
            cell.setBtnState(yes: false, no: false, notAvailable: false, default: true)
        default:
            print("Default condition not defined yet")
        }
        
        
        cell.cofigureCellData(info: data!, index: indexPath.row)
        cell.dropShadow(radius: 3, opacity: 0.2)
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
        
        taskObj?.categories[btnSection].checkListQuestions[btnRow].status = QuestionListOptions.yes
        //print(taskObj as Any)
        //print("Section: ", btnSection, "Row : ",btnRow )
        questionListTV.reloadData()
        
    }
    
    func noBtn(btn: UIButton) {
        let btnTag = btn.tag
        
        let btnRow = btnTag % 1000
        let btnSection = btnTag / 1000
        taskObj?.categories[btnSection].checkListQuestions[btnRow].status = QuestionListOptions.no

        //print("Section: ", btnSection, "Row : ",btnRow )
        questionListTV.reloadData()

    }
    
    func notAvalable(btn: UIButton) {
        let btnTag = btn.tag
        
        let btnRow = btnTag%1000
        let btnSection = btnTag/1000
        taskObj?.categories[btnSection].checkListQuestions[btnRow].status = QuestionListOptions.notAvilAble

        //print("Section: ", btnSection, "Row : ",btnRow )
        questionListTV.reloadData()

    }
}

//======================================

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
