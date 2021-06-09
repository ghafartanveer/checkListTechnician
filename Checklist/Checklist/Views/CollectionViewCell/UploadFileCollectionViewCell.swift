//
//  UploadFileCollectionViewCell.swift
//  Checklist
//
//  Created by Rizwan Ali on 22/04/2021.
//

import UIKit

protocol UploadFileCollectionViewCellDelegate: NSObjectProtocol {
    func callBackActionDeleteImage(indexP: Int)
}


class UploadFileCollectionViewCell: BaseCollectionViewCell {
    //MARK: - IBOUTLETS
    @IBOutlet weak var imgTask: UIImageView!
    
    //MARK: - OBJECT AND VERAIBLES
    var index: Int = -1
    weak var delegate: UploadFileCollectionViewCellDelegate?
    
    //MARK: - FUNCTIONS
    func configureImage(image: UIImage, index: Int){
        self.imgTask.image = image
        self.index = index
    }
    
    //MARK: - IBACTION METHODS
    @IBAction func actionDeleteImage(_ sender: UIImage){
        delegate?.callBackActionDeleteImage(indexP: index)
    }
}
