//
//  SideMenuTableViewCell.swift
//  Checklist
//
//  Created by Rizwan Ali on 22/04/2021.
//

import UIKit

class SideMenuTableViewCell: BaseTableViewCell {
    //MARK: - IBOUTLETS
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgImage: UIImageView!
    
    //MARK: - OVERRIDE METHODS
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureMenu(info: [String: String]){
        self.lblTitle.text = info["title"]
        self.imgImage.image = UIImage(named: info["image"]!)
    }
}
