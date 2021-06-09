//
//  TaskTypesTableViewCell.swift
//  Checklist
//
//  Created by Rizwan Ali on 20/04/2021.
//

import UIKit

class TaskTypesTableViewCell: BaseTableViewCell {
    
    @IBOutlet weak var viewShadow: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    
    func ConfigureTypes(index: Int){
        if index == 0{
            self.lblTitle.text = "In House Tasks"
            self.imgImage.image = UIImage(named: AssetNames.Box_Red)
        }else{
            self.lblTitle.text = "Field Work Tasks"
            self.imgImage.image = UIImage(named: AssetNames.Box_Blue)
        }
        //self.dropShadow(radius: 5, opacity: 0.4)
    }
    

}
