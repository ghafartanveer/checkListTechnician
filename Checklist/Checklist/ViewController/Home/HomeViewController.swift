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
            container.setMenuButton(false, title: TitleNames.Home)
        }
    }
    
    
    //MARK: - IBACTION METHODS
    @IBAction func actionAddTask(_ sender: UIButton){
        
    }
    
    //MARK: - FUNCTIONS
    func moveToWorkListVC(indexPath: Int){
        var isHistory = false
        if indexPath == 3{
            isHistory = true
        }
        let vc = self.storyboard?.instantiateViewController(withIdentifier: ControllerIdentifier.WorkListViewController) as! WorkListViewController
        vc.isFromHistory = isHistory
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
//MARK: - EXTENSION TABEL VIEW METHODS
extension HomeViewController: UITableViewDelegate, UITableViewDataSource, TaskCategoryTableViewCellDelegate{
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1{
            return 2
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.TaskCategoryTableViewCell) as! TaskCategoryTableViewCell
            cell.delegate = self
            cell.viewCollection.reloadData()
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.TaskTypesTableViewCell) as! TaskTypesTableViewCell
            cell.ConfigureTypes(index: indexPath.row)
            
            return cell
        }
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
        if indexPath.section == 0{
            return 420
            
        }else{
            return 80
        }
    }
    
    //MARK: - DELEGATE METHODS
    func callBackMoveOnContoller(index: Int) {
        if index == 1 || index == 3{
            self.moveToWorkListVC(indexPath: index)
        }else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: ControllerIdentifier.CalenderViewController) as! CalenderViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    
    
}
