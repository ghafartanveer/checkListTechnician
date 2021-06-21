//
//  HistoryDetailsViewController.swift
//  Checklist
//
//  Created by Muaaz Ahmad on 21/06/2021.
//

import UIKit

class HistoryDetailsViewController: BaseViewController, TopBarDelegate {
    
    @IBOutlet weak var checkInDetailsContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let container = self.mainContainer{
            container.delegate = self
           
            container.setMenuButton(true, true, title: TitleNames.History)
            container.viewTopColour.backgroundColor = .white
        }
        layoutSetup()
        setCheckinDetails()
        
    }
    
    func actionBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func layoutSetup() {
        checkInDetailsContainerView.addshadow()
    }
    
    func setCheckinDetails() {
        
    }

}


//MARK: - EXTENISON TABEL VIEW METHODS

extension HistoryDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.HistoryDetailsTaskListTableViewCell, for: indexPath) as! HistoryDetailsTaskListTableViewCell
        
        cell.shaowContainerView.dropShadow()
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
}
