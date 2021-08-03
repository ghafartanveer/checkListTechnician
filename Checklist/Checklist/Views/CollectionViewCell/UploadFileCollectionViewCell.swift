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
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imgTask: UIImageView!
    @IBOutlet weak var desccriptioLbl: UILabel!
    
    //MARK: - OBJECT AND VERAIBLES
    var index: Int = -1
    var imageId = 0
    weak var delegate: UploadFileCollectionViewCellDelegate?
    
    //MARK: - FUNCTIONS
//    func configureImage(image: UIImage, index: Int){
//
//        self.imgTask.image = image
//        self.index = index
//        desccriptioLbl.text = image.
//    }
    
    func configureImageCellImage(info: ImageViewVodel, index: Int) {
        self.containerView.dropShadow()
        self.setImageWithUrl(imageView: self.imgTask, url: info.image ?? "")
        self.desccriptioLbl.text = info.typeName
        self.index = index
    }
    
    //MARK: - IBACTION METHODS
    @IBAction func actionDeleteImage(_ sender: UIImage){
        delegate?.callBackActionDeleteImage(indexP: index)
    }
}
