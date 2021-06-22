//
//  HistoryDetailsTaskListTableViewCell.swift
//  Checklist
//
//  Created by Muaaz Ahmad on 21/06/2021.
//

import UIKit

class HistoryDetailsTaskListTableViewCell: BaseTableViewCell {

    @IBOutlet weak var shaowContainerView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(info: SubcategoryViewModel) {
        titleLbl.text = info.subCategoryName
    }

}
