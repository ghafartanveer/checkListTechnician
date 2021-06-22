//
//  TaskHistoryTableViewCell.swift
//  Checklist
//
//  Created by Muaaz Ahmad on 18/06/2021.
//

import UIKit

protocol TaskHistoryTableViewCellDelegate: NSObjectProtocol {
    func seeDetilsCallBack(index:Int)
}

class TaskHistoryTableViewCell: BaseTableViewCell {

    @IBOutlet weak var customeNameLbl: UILabel!
    @IBOutlet weak var regNoLbl: UILabel!
    
    @IBOutlet weak var containerView: UIView!
    
    weak var delegate: TaskHistoryTableViewCellDelegate?
    var cellIndex = -1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

    func configureHistoryList(info: HistoryTaskViewModel) {
        self.customeNameLbl.text = info.activity?.customerName
        self.regNoLbl.text = info.activity?.registrationNumber
    }
    
    @IBAction func seeDetails(_ sender: Any) {
        delegate?.seeDetilsCallBack(index: cellIndex)
    }
    
}
