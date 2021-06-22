//
//  CheckListHistoryViewController.swift
//  Checklist
//
//  Created by Muaaz Ahmad on 18/06/2021.
//

import UIKit

class CheckListHistoryViewController: BaseViewController, TopBarDelegate {
    //MARK: - IBOUTLETS
    @IBOutlet weak var historyTableView: UITableView!
    
    //MARK: - OBJECT AND VERIABLES
    var historyObject = HistoryTaskListViewModel()
    
    //MARK: - OVERRIDE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getHistoryListApi()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let container = self.mainContainer{
            container.delegate = self
            
            container.setMenuButton(true, true, title: TitleNames.History)
        }
    }
    
    override func callBackYesterdayPressed() {
        SearchHistoryListApi(params: ["date":"2021-07-16,2021-07-22"])
        self.alertView?.close()
    }
    
    override func callBackLastWeekPressed() {
        SearchHistoryListApi(params: ["date":"2021-07-16,2021-07-22"])
        self.alertView?.close()
    }
    
    override func callBackLastMonthPressed() {
        SearchHistoryListApi(params: ["date":"2021-07-16,2021-07-22"])
        self.alertView?.close()
    }
    
    override func callBackAllListPressed() {
        getHistoryListApi()
        self.alertView?.close()
    }
    
    
    //MARK: - IBACTIONS
    @IBAction func showFilterPopUp(_ sender: Any) {
        showHistorySlectionPopup()
        self.alertView?.show()
    }
    
    
    //MARK: - FUNCTIONS
    func actionBack() {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: - EXTENISON TABEL VIEW METHODS
extension CheckListHistoryViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.historyObject.historyTaskList.count == 0 {
        historyTableView.setNoDataMessage(LocalStrings.NoDataFound)
        }
        return self.historyObject.historyTaskList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.TaskHistoryTableViewCell) as! TaskHistoryTableViewCell
        
        cell.configureHistoryList(info: self.historyObject.historyTaskList[indexPath.row])
        
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

//MARK: - Get task list History
extension CheckListHistoryViewController{
    func getHistoryListApi(){
        self.startActivity()
        GCD.async(.Background) {
            HistoryService.shared().getHistoryApi(params: [:]) { (message, success, historyInfo) in
                GCD.async(.Main) { [self] in
                    self.stopActivity()
                    if success{
                        if let history = historyInfo{
                            
                            self.historyObject = history
                            self.historyTableView.reloadData()
                            
                        }
                        
                    }else{
                        self.showAlertView(message: message)
                    }
                }
            }
        }
    }
    
    //MARK: - Search task list History
    func SearchHistoryListApi(params: ParamsString){
        self.startActivity()
        GCD.async(.Background) {
            HistoryService.shared().searcHistoryApi(params: params) { (message, success, historyInfo) in
                GCD.async(.Main) { [self] in
                    self.stopActivity()
                    if success{
                        if let history = historyInfo{
                            
                            self.historyObject = history
                            self.historyTableView.reloadData()
                        }
                    }else{
                        self.showAlertView(message: message)
                    }
                }
            }
        }
    }
    
}

// MARK: - See details History delegate

extension CheckListHistoryViewController : TaskHistoryTableViewCellDelegate {
    
    func seeDetilsCallBack(index: Int) {
        let storyboard = UIStoryboard(name: StoryboardNames.Home, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: ControllerIdentifier.HistoryDetailsViewController) as! HistoryDetailsViewController
        vc.historyDetailObject = self.historyObject.historyTaskList[index]
        self.navigationController?.pushViewController(vc, animated: true)
        
        print("See details of index: ", index)
    }
}
