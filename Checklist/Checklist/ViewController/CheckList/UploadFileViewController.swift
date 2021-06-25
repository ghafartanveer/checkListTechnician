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
    
    @IBOutlet weak var descriptionTxtV: KMPlaceholderTextView!
    
    @IBOutlet weak var imagrequiresTaskLbl: UILabel!
    
    //MARK: - OBJECT AND VERIABLES
    var categoryId = 0
    var isImageRequired = false
    
    let dropDown = DropDown()
    var imageList = [UIImage]()
    var categoryListViewModel = CategoryListViewModel()
    var taskViewModel: TaskViewModel? = nil
    
    var dropDownsOptionList: [String] = []
    var dropDownOptionIdList: [Int] = []
    //MARK: - OVERRIDE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        // The view to which the drop down will appear on
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpDropDown()
        
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
        if isImageRequired {
            self.fetchProfileImage()
        }
        
    }
    
    @IBAction func actionSubmit(_ sender: UIButton){
        
        
        if let descriptionText = descriptionTxtV.text {
            taskViewModel?.description = descriptionText
        }
        
        if let params = taskViewModel?.getParams() {
            
            submitTaskServerCall(params: params)
        }
    }
    //MARK: - FUNCTIONS
    func actionBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setUpDropDown() {
        
        for img in categoryListViewModel.categoryList {
            print( img.id )
            for imgTypeName in 0..<((img.images?.imagelist.count)!) {
                print(imgTypeName)
            }
        }
        
        for taskWithImage in 0 ..< ((taskViewModel?.categories.count)!) {
            
            if taskViewModel?.categories[taskWithImage].hasImages == 1 {
                dropDownsOptionList.append(taskViewModel?.categories[taskWithImage].name ?? "")
                dropDownOptionIdList.append(taskViewModel?.categories[taskWithImage].id ?? 0)
            }
        }
        if dropDownsOptionList.count > 0 {
            isImageRequired = true
            dropDownContainer.addshadow()
            dropDown.anchorView = dropDownContainer
            dropDown.dataSource = dropDownsOptionList
            dropDownBtn.setTitle(dropDown.dataSource[0], for: .normal)
            dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                dropDownBtn.setTitle(item, for: .normal)
                self.categoryId = index

                print("Selected item: \(item) at index: \(index)")
            }
        } else {
            isImageRequired = false
            imagrequiresTaskLbl.isHidden = true
            dropDownContainer.isHidden = true
        }
    }
    
    //MARK: - IMAGE PICKER CONTOLLER METHODS
    override func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        self.imageList.append(image)
        picker.dismiss(animated: true, completion: nil)
        self.viewCollection.reloadData()
        
        let imageData = (image).jpegData(compressionQuality: 1.0)
        
        self.uploadTaskImage(params: [
                                DictKeys.Category_Id : self.categoryId, DictKeys.ImageId : imageList.count],  imageDic: [DictKeys.image : imageData] )
        
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

extension UploadFileViewController {
    func submitTaskServerCall(params: ParamsAny){
        self.startActivity()
        GCD.async(.Background) {
            CommonService.shared().submitTaskApi(params: params) { (message, success) in
                GCD.async(.Main) { [self] in
                    self.stopActivity()
                    if success{
                        self.showAlertView(message: message, title: "CheckList", doneButtonTitle: "Done") { (action) in
                            self.navigationController?.popToRootViewController(animated: true)
                        }
                        
                    }else{
                        self.showAlertView(message: message)
                    }
                }
            }
        }
    }
    
    func uploadTaskImage(params: ParamsAny, imageDic: [String:Data?]){
        self.startActivity()
        GCD.async(.Background) {
            CommonService.shared().uploadImagesApi(params: params, Img: imageDic) { (_ message:String, _ success:Bool) in
                GCD.async(.Main) { [self] in
                    self.stopActivity()
                    if success{
                        
                        //self.showAlertView(message: message)
                    }else{
                        self.showAlertView(message: message)
                    }
                }
            }
        }
        
    }
    
}
