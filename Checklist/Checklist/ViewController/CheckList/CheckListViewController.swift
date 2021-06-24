//
//  CheckListViewController.swift
//  Checklist
//
//  Created by Rizwan Ali on 20/04/2021.
//

import UIKit

class CheckListViewController: BaseViewController, TopBarDelegate {
    //MARK: - Outlets
    @IBOutlet weak var seachBarContainerView: UIView!
    @IBOutlet weak var topBarHeight: NSLayoutConstraint!
    @IBOutlet weak var saperationView: UIView!
    
    //MARK: - Variables/Objects
    var taskSubCategoryList:[CategoryViewModel] = []
    ////MARK: -  OverRide function
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

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
    }
    //MARK: - IBOutlets
    @IBAction func nextButton(_ sender: Any) {
        
        navigteToUploadFileVC()
    }
    //MARK: - fiunctions
    func actionBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func navigteToUploadFileVC() {
        let storyboard = UIStoryboard(name: StoryboardNames.Setting, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: ControllerIdentifier.UploadFileViewController) as! UploadFileViewController
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
            NSAttributedString.Key.font: UIFont(name: "Poppins SemiBold", size: 18.0)!
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
