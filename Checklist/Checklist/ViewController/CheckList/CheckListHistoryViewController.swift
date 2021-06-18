//
//  CheckListHistoryViewController.swift
//  Checklist
//
//  Created by Muaaz Ahmad on 18/06/2021.
//

import UIKit

class CheckListHistoryViewController: BaseViewController, TopBarDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let container = self.mainContainer{
            container.delegate = self
            
                container.setMenuButton(true, true, title: TitleNames.History)
        }
    }
    
    func actionBack() {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: - EXTENISON TABEL VIEW METHODS
extension CheckListHistoryViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.TaskHistoryTableViewCell) as! TaskHistoryTableViewCell
        cell.containerView.dropShadow()
        cell.delegate = self
        cell.cellIndex = indexPath.row
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("nothing yet")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
}

extension CheckListHistoryViewController : TaskHistoryTableViewCellDelegate {
    
    func seeDetilsCallBack(index: Int) {
        print("See details of index: ", index)
    }
}
