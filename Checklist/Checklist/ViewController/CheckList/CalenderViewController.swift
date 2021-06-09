//
//  CalenderViewController.swift
//  Checklist
//
//  Created by Rizwan Ali on 22/04/2021.
//

import UIKit
import FSCalendar

class CalenderViewController: BaseViewController, TopBarDelegate {
    //MARK: - IBOUTLETS
    @IBOutlet weak var calender: FSCalendar!
    @IBOutlet weak var viewCalenderHeight: NSLayoutConstraint!
    
    
    //MARK: - OVERRIDE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.calender.delegate = self
        self.calender.setScope(.week, animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let container = self.mainContainer{
            container.delegate = self
            container.setMenuButton(true, true, title: TitleNames.Pending_Task)
        }
    }
    func actionBack() {
        self.navigationController?.popViewController(animated: true)
    }
}
//MARK: - FSCALENDER DELEGATE METHODS
extension CalenderViewController: FSCalendarDelegate{
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
       
        self.calender.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 110)
        self.view.layoutIfNeeded()
    }
}

//MARK: - EXTENISON TABEL VIEW METHODS
extension CalenderViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.CalenderTableViewCell) as! CalenderTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
}
