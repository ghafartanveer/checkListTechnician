//
//  UploadFileViewController.swift
//  Checklist
//
//  Created by Rizwan Ali on 22/04/2021.
//

import UIKit

class UploadFileViewController: BaseViewController, TopBarDelegate {
    //MARK: - IBOUTLETS
    @IBOutlet weak var viewCollection: UICollectionView!
    
    //MARK: - OBJECT AND VERIABLES
    
    var imageList = [UIImage]()
    //MARK: - OVERRIDE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let container = self.mainContainer{
            container.delegate = self
            container.setMenuButton(true, title: TitleNames.Upload_File)
        }
    }
    
    //MARK: - IBACTION METHODS
    @IBAction func actionChoosePhoto(_ sender: UIButton){
        self.fetchProfileImage()
    }
    @IBAction func actionSubmit(_ sender: UIButton){
        self.navigationController?.popToRootViewController(animated: true)
    }
    //MARK: - FUNCTIONS
    func actionBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - IMAGE PICKER CONTOLLER METHODS
    override func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        self.imageList.append(image)
        picker.dismiss(animated: true, completion: nil)
        self.viewCollection.reloadData()
    }
}

//MARK: - EXTENSION COLLECTION VIEW METHODS
extension UploadFileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UploadFileCollectionViewCellDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.UploadFileCollectionViewCell, for: indexPath) as! UploadFileCollectionViewCell
        cell.delegate = self
        cell.configureImage(image: self.imageList[indexPath.row], index: indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collection = collectionView.bounds.width
        return CGSize(width: collection / 4.2, height: 60)
    }
    
    func callBackActionDeleteImage(indexP: Int) {
        self.imageList.remove(at: indexP)
        self.viewCollection.reloadData()
    }
    
    
}
