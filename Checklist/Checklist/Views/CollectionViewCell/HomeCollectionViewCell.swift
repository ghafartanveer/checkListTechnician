//
//  HomeCollectionViewCell.swift
//  Checklist
//
//  Created by Rizwan Ali on 20/04/2021.
//

import UIKit

class HomeCollectionViewCell: BaseCollectionViewCell {
    @IBOutlet weak var viewShadow: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgImage: UIImageView!
    
    @IBOutlet weak var checkinTickImg: UIImageView!
    
    func configureMenu(data: [String: String]){
        self.lblTitle.text = data["title"]
        self.imgImage.image = UIImage(named: data["image"]!)
        self.viewShadow.dropShadow(radius: 5, opacity: 0.5)
    }
}
