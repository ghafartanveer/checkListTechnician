//
//  WorkListTableViewCell.swift
//  Checklist
//
//  Created by Rizwan Ali on 22/04/2021.
//

import UIKit

class WorkListTableViewCell: BaseTableViewCell {
    
    @IBOutlet weak var viewShadow: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCategoryTask(info: CategoryViewModel){
        self.lblTitle.text = info.name
    }
   

}
