//
//  CheckListHistoryViewController.swift
//  Checklist
//
//  Created by Muaaz Ahmad on 18/06/2021.
//

import UIKit

class CheckListHistoryViewController: BaseViewController, TopBarDelegate {
    //MARK: - IBOUTLETS
    
    @IBOutlet weak var searchBarTF: UITextField!
    
    @IBOutlet weak var historyTableView: UITableView!
    
    //MARK: - OBJECT AND VERIABLES
    var historyObject = HistoryTaskListViewModel()
    var filteredObject = [HistoryTaskViewModel]()
    
//    var resturantFilterList = [RestaurantViewModel]()
//
//    var resturantObj = ResturantListViewModel()
    
    //MARK: - OVERRIDE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getHistoryListApi()
        searchBarTF.delegate = self
        
        searchBarTF.addTarget(self, action: #selector(yourHandler(textField:)), for: .editingChanged)

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
        
        let yesterDay = Utilities.getNextDateString(date: Date(), value: -1)
        
        SearchHistoryListApi(params: ["date":yesterDay])
        self.alertView?.close()
    }
    
    override func callBackLastWeekPressed() {
        
        let today = Utilities.getNextDateString(date: Date(), value: 0)
        let lastWeek = Utilities.getNextDateString(date: Date(), value: -7)

        SearchHistoryListApi(params: ["date":today+","+lastWeek])
        self.alertView?.close()
    }
    
    override func callBackLastMonthPressed() {
        
        let today = Utilities.getNextDateString(date: Date(), value: 0)
        let lastMonth = Utilities.getNextDateString(date: Date(), value: -30)
        
        SearchHistoryListApi(params: ["date":today+","+lastMonth])
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
    
    
    //MARK: - FUNCTIONS . Search
    
    @objc final private func yourHandler(textField: UITextField) {
        print("Text changed", textField.text)
    
        if(textField.text == ""){
            self.historyObject.historyTaskList = self.filteredObject
            self.historyTableView.reloadData()
        }
        else{
            let filterdItemsArray = self.filteredObject.filter({ ($0.activity?.customerName?.lowercased().contains(textField.text!.lowercased()))! || ($0.activity?.registrationNumber?.lowercased().contains(textField.text!.lowercased()))!
            })
            self.historyObject.historyTaskList = filterdItemsArray
            
            self.historyTableView.reloadData()
            print(filterdItemsArray)
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
}

//MARK: - EXTENISON TABEL VIEW METHODS
extension CheckListHistoryViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
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

//MARK: - Text field delegate
extension CheckListHistoryViewController : UITextFieldDelegate {
    
    
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
                            self.historyObject.historyTaskList.reverse()
                            self.filteredObject.append(contentsOf: self.historyObject.historyTaskList)
                            if historyObject.historyTaskList.count == 0 {
                                historyTableView.setNoDataMessage(LocalStrings.NoDataFound)
                                self.historyTableView.reloadData()

                            } else {
                                historyTableView.setNoDataMessage("")
                            self.historyTableView.reloadData()
                            }
                            
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
                            self.filteredObject.append(contentsOf: self.historyObject.historyTaskList)
                            if historyObject.historyTaskList.count == 0 {
                                historyTableView.setNoDataMessage(LocalStrings.NoDataFound)
                                self.historyTableView.reloadData()

                            } else {
                                historyTableView.setNoDataMessage("")
                                self.historyTableView.reloadData()
                            }
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
