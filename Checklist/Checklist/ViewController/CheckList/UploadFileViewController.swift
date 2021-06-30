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
    var selectedImgDetailsIndex = 0
    
    var isImageRequired = false
    
    var taskSubCategoryList:[CategoryViewModel] = [] //selectedList
    
    let dropDown = DropDown()
    var imageList = [UIImage]()
    var taskViewModel: TaskViewModel? = nil
    
    var dropDownsOptionList: [String] = []
    var dropDownOptionIdList: [Int] = []
    
    var selectedImageList:[selectedImageViewModel] = []

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
        } else {
            self.showAlertView(message: PopupMessages.ImagesNotRequired)
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
        
        for item in taskSubCategoryList {
            if item.hasImages == 1 {
                for imageCount in 0..<(item.images?.imagelist.count)! {
                    print((item.images?.imagelist[imageCount].typeName) ?? "")
                    print((item.images?.imagelist[imageCount].id) ?? 0)
                    print((item.images?.imagelist[imageCount].categoryID) ?? 0)
                    if ((item.images?.imagelist[imageCount].typeName) != "null") {
                    dropDownsOptionList.append((item.images?.imagelist[imageCount].typeName) ?? "")
                    dropDownOptionIdList.append((item.images?.imagelist[imageCount].id) ?? 0)
                        
                        selectedImageList.append(selectedImageViewModel(typeName: (item.images?.imagelist[imageCount].typeName) ?? "", imageId: (item.images?.imagelist[imageCount].id) ?? 0, categoryId: (item.images?.imagelist[imageCount].categoryID) ?? 0 ))
                    }
                }
            }
            
        }
        
        
//        for taskWithImage in 0 ..< ((taskViewModel?.categories.count)!) {
//
//            if taskViewModel?.categories[taskWithImage].hasImages == 1 {
//                dropDownsOptionList.append(taskViewModel?.categories[taskWithImage].name ?? "")
//                dropDownOptionIdList.append(taskViewModel?.categories[taskWithImage].id ?? 0)
//            }
//        }
        if dropDownsOptionList.count > 0 {
            isImageRequired = true
            dropDownContainer.dropShadow()
            dropDown.anchorView = dropDownContainer
            dropDown.dataSource = dropDownsOptionList
            dropDownBtn.setTitle(dropDown.dataSource[0], for: .normal)
            dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                dropDownBtn.setTitle(item, for: .normal)
                print("cId : ",selectedImageList[index].categoryId, "iId : ", selectedImageList[index].imageId, "tName : ", selectedImageList[index].typeName )
                self.selectedImgDetailsIndex = index
               
                
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
        picker.dismiss(animated: true, completion: nil)
//        self.imageList.append(image)
//        picker.dismiss(animated: true, completion: nil)
//        self.viewCollection.reloadData()
        
        let imageDetails = selectedImageList[selectedImgDetailsIndex]
        let imageData = (image).jpegData(compressionQuality: 0.8)
        self.uploadTaskImage(params: [
                                DictKeys.Category_Id : imageDetails.categoryId, DictKeys.ImageId : imageDetails.imageId],  imageDic: [DictKeys.image : imageData], image: image )
        
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
        let imageTodelete = selectedImageList[indexP]
        deleteImageServerCall(index: indexP, params: [DictKeys.ImageId: imageTodelete.imageId, DictKeys.Category_Id:imageTodelete.categoryId]) //update
        //self.imageList.remove(at: indexP)
        //self.viewCollection.reloadData()
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
    
    func uploadTaskImage(params: ParamsAny, imageDic: [String:Data?], image: UIImage){
        self.startActivity()
        GCD.async(.Background) {
            CommonService.shared().uploadImagesApi(params: params, Img: imageDic) { (_ message:String, _ success:Bool) in
                GCD.async(.Main) { [self] in
                    self.stopActivity()
                    if success{
                        self.imageList.append(image)
                        self.viewCollection.reloadData()
                        //self.showAlertView(message: message)
                    }else{
                        self.showAlertView(message: message)
                    }
                }
            }
        }
        
    }
    
    func deleteImageServerCall(index:Int,params: ParamsAny){
        self.startActivity()
        GCD.async(.Background) {
            CommonService.shared().deleteImageApi(params: params) { (message, success) in
                GCD.async(.Main) { [self] in
                    self.stopActivity()
                    if success{
                        self.imageList.remove(at: index)
                        self.selectedImageList.remove(at: index)
                        self.viewCollection.reloadData()
                    }else{
                        self.showAlertView(message: message)
                    }
                }
            }
        }
    }

    
}


struct selectedImageViewModel {
    var typeName: String
    var imageId: Int
    var categoryId: Int
    
}
