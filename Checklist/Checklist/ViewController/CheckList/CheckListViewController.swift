//
//  CheckListViewController.swift
//  Checklist
//
//  Created by Rizwan Ali on 20/04/2021.
//

import UIKit

class CheckListViewController: BaseViewController, TopBarDelegate {
    
    var taskSubCategoryList:[CategoryViewModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(taskSubCategoryList[0].name)
        if let container = self.mainContainer{
            container.delegate = self
            container.setMenuButton(true, true, title: TitleNames.Check_List)
            
        }
    }
    
     
    func actionBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextButton(_ sender: Any) {
        navigteToUploadFileVC()
    }
    
    func navigteToUploadFileVC() {
        let storyboard = UIStoryboard(name: StoryboardNames.Setting, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: ControllerIdentifier.UploadFileViewController) as! UploadFileViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
//MARK: - EXTENISON TABEL VIEW METHODS

extension CheckListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        taskSubCategoryList[section].name
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return taskSubCategoryList.count //taskSubCategoryList.taskSubCategory?.//taskSubCategoryList.count ?? 0
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
        let storyboard = UIStoryboard(name: StoryboardNames.Setting, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: ControllerIdentifier.UploadFileViewController) as! UploadFileViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    
}
