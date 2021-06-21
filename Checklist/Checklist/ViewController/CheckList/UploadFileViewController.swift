//
//  UploadFileViewController.swift
//  Checklist
//
//  Created by Rizwan Ali on 22/04/2021.
//

import UIKit
import DropDown

class UploadFileViewController: BaseViewController, TopBarDelegate {
    //MARK: - IBOUTLETS
    @IBOutlet weak var dropDownContainer: UIView!
    @IBOutlet weak var dropDownBtn: UIButton!
    @IBOutlet weak var viewCollection: UICollectionView!
    
    //MARK: - OBJECT AND VERIABLES
    let dropDown = DropDown()
    var imageList = [UIImage]()
    
    let dropDownsOptionList = ["Car", "Motorcycle", "Truck"]
    //MARK: - OVERRIDE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpDropDown()

        // The view to which the drop down will appear on
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let container = self.mainContainer{
            container.delegate = self
            container.setMenuButton(true, title: TitleNames.Upload_File)
        }
    }
    
    //MARK: - IBACTION METHODS
    
    @IBAction func openDropDown(_ sender: Any) {
        dropDown.show()
    }
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
    
    func setUpDropDown() {
        dropDownContainer.addshadow()
        dropDown.anchorView = dropDownContainer // UIView or UIBarButtonItem
        
        // The list of items to display. Can be changed dynamically
        dropDown.dataSource = dropDownsOptionList
        dropDownBtn.setTitle(dropDown.dataSource[0], for: .normal)
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            dropDownBtn.setTitle(item, for: .normal)
            
            print("Selected item: \(item) at index: \(index)")
        }
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
