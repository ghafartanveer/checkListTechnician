//
//  UploadFileViewController.swift
//  Checklist
//
//  Created by Rizwan Ali on 22/04/2021.
//

import UIKit
import DropDown
var imageListViewModel = ImageListViewModel()

class UploadFileViewController: BaseViewController, TopBarDelegate {
    //MARK: - IBOUTLETS
    @IBOutlet weak var dropDownContainer: UIView!
    @IBOutlet weak var dropDownBtn: UIButton!
    @IBOutlet weak var viewCollection: UICollectionView!
    
    @IBOutlet weak var descriptionTxtV: KMPlaceholderTextView!
    
    @IBOutlet weak var imagrequiresTaskLbl: UILabel!
    
    @IBOutlet var uploadImagePopUpContainer: UIView!
    
    @IBOutlet weak var popUpImgV: UIImageView!
    @IBOutlet weak var closeImagePopUp: UIButton!
    @IBOutlet weak var popUpDescriptionTxtV: KMPlaceholderTextView!
    @IBOutlet weak var submitImageBtnAction: UIButton!
    
    @IBOutlet weak var sumbitTaskBtn: UIButton!
    @IBOutlet weak var scrolV: UIScrollView!
    
    
    @IBOutlet weak var collectionContainerHeight: NSLayoutConstraint!
    
    //MARK: - OBJECT AND VERIABLES
    //var selectedImgDetailsIndex = 0
    var isPopUpOpened = false
    var isImageRequired = false
    
    var taskSubCategoryList:[CategoryViewModel] = [] //selectedList
    
    let dropDown = DropDown()
    var imageList = [UIImage]()
    var taskViewModel: TaskViewModel? = nil
    
    var dropDownsOptionList: [String] = []
    var dropDownOptionIdList: [Int] = []

    //MARK: - OVERRIDE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()

        Global.shared.catWithImagesId = taskSubCategoryList[0].id
        self.getImagesAgainstCat()
        setUpDropDown()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let container = self.mainContainer{
            container.delegate = self
            container.setMenuButton(true, title: TitleNames.Upload_File)
        }
        
        setCollectionHeight()
    }
    
    
    //MARK: - IBACTION METHODS
    
    @IBAction func openDropDown(_ sender: Any) {
        dropDown.show()
    }
    
    @IBAction func actionChoosePhoto(_ sender: UIButton){
        //if isImageRequired {
            self.fetchProfileImage()
       // }
//        else {
//            self.showAlertView(message: PopupMessages.ImagesNotRequired)
//        }
        
    }
    
    @IBAction func actionSubmit(_ sender: UIButton){
        
        
        if let descriptionText = descriptionTxtV.text {
            taskViewModel?.description = descriptionText
        }
        
        if let params = taskViewModel?.getParams() {
            //print(params.)
            submitTaskServerCall(params: params)
        }
    }
    
    @IBAction func closePopUp(_ sender: Any) {
        self.isPopUpOpened = false
        self.checkIfPopUpOpened()
        uploadImagePopUpContainer.removeFromSuperview()
        
    }
    
    @IBAction func UploadImgBtnAction(_ sender: Any) {
        let image = popUpImgV.image!
        
        var description = ""
        if dropDownOptionIdList.count > 0 {
            description = dropDownBtn.titleLabel?.text ?? ""
        } else {
            description = popUpDescriptionTxtV.text
        }
        
        if description.isEmpty {
            self.showAlertView(message: PopupMessages.imageDescRequired)
        } else {
        
        let imageData = (image).jpegData(compressionQuality: 0.8)
        let activityId = Global.shared.checkInId
        self.uploadTaskImage(params: [
                                DictKeys.Category_Id : Global.shared.catWithImagesId, DictKeys.activity_id: activityId, DictKeys.Description: description ], imageDic: [DictKeys.image : imageData], image: image )
        }
    }
    
    //MARK: - FUNCTIONS
    
    func checkIfPopUpOpened() {
        if isPopUpOpened {
            self.sumbitTaskBtn.isEnabled = false
            self.scrolV.isScrollEnabled = false
            
        } else {
            self.sumbitTaskBtn.isEnabled = true
            self.scrolV.isScrollEnabled = true
        }
    }
    
    func setCollectionHeight() {
        if imageListViewModel.imagelist.count > 0 {
            collectionContainerHeight.constant = 150
        } else {
            collectionContainerHeight.constant = 0
            
        }
    }
    
    func saveImagesToGallery() {
       
        for index in 0..<imageListViewModel.imagelist.count {
            
//            let indexpath: IndexPath = [0,index]
//            let collecttionCell = collectionView(self.viewCollection, cellForItemAt: indexpath) as! UploadFileCollectionViewCell
//
//            let image = (collecttionCell.imgTask.image ?? UIImage(named: ""))!
            //PhotoGalleryAlbum.shared.save(image: image)
            
            let imgView = UIImageView()
            imgView.sd_setImage(with: URL(string:imageListViewModel.imagelist[index].image ?? ""), completed: { (image, error, type, url) in
                PhotoGalleryAlbum.shared.save(image: image ?? UIImage())
            })
        }
    }
    
    func getImagesAgainstCat() {
            let catId = Global.shared.catWithImagesId
            let activityId = Global.shared.checkInId
            getimageListApi(params:[
                                DictKeys.Category_Id : catId, DictKeys.activity_id: activityId ])
        
    }
    
    
    func actionBack() {
        if !isPopUpOpened {
        self.navigationController?.popViewController(animated: true)
        }
    }
    
    func setUpDropDown() {
        
        for item in taskSubCategoryList {
            if item.hasImages == 1 {
                for n in 0..<(item.images?.imagelist.count)! {
                   
                    if ((item.images?.imagelist[n].typeName) != "null") {
                    dropDownsOptionList.append((item.images?.imagelist[n].typeName) ?? "")
                        
                    dropDownOptionIdList.append((item.id))
                    }
                }
            } else {
                
                Global.shared.catWithImagesId = taskSubCategoryList[0].id
            }
            
        }
      
        if dropDownsOptionList.count > 0 {
            isImageRequired = true
            dropDownContainer.dropShadow()
            dropDown.anchorView = dropDownContainer
            dropDown.dataSource = dropDownsOptionList
            dropDownBtn.setTitle(dropDown.dataSource[0], for: .normal)
            dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                dropDownBtn.setTitle(item, for: .normal)
                
//                for cat in taskSubCategoryList {
//                    if cat.hasImages == 1 {
//                        for n in 0..<(cat.images?.imagelist.count)! {
//
//                            if ((cat.images?.imagelist[n].typeName) != "null") {
//                                dropDownsOptionList.append((cat.images?.imagelist[n].typeName) ?? "")
//
//                            }
//                        }
//                    }
//                }
                
                Global.shared.catWithImagesId = dropDownOptionIdList[index]
                
               // self.selectedImgDetailsIndex = index
                popUpDescriptionTxtV.isUserInteractionEnabled = false
            }
        } else {
            popUpDescriptionTxtV.isUserInteractionEnabled = true
            isImageRequired = false
            imagrequiresTaskLbl.isHidden = true
            dropDownContainer.isHidden = true
        }
    }
    
    //MARK: - IMAGE PICKER CONTOLLER METHODS
    override func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var image = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        
        picker.dismiss(animated: true, completion: nil)
//        self.imageList.append(image)
//        picker.dismiss(animated: true, completion: nil)
//        self.viewCollection.reloadData()
        
        //openPopUpHere
        uploadImagePopUpContainer.frame = CGRect(x: 20, y: 70, width: ScreenSize.SCREEN_WIDTH - 40, height: ScreenSize.SCREEN_HEIGHT * 0.8)
        
//        if let imageRaw = info[.originalImage] as? UIImage{
//            if isImgeSourceCamra {
//
//                if let renderedImage = self.imageWithRenderDateMetaData(metaData: info[.mediaMetadata] as! NSDictionary, image: imageRaw){
//                    image = renderedImage
//                    //self.successToSelectImageFromGallery(image: renderedImage)
//                }else{
//                    print("failed to add Time Stamp")
//                }
//
//            } else {
//                //watermark for gallery
//            }
       // }
        
//        if let renderedImage = self.imageWithRenderDateMetaData(image: image){
//        image = renderedImage
//
//        }else{
//            print("failed to add Time Stamp")
//        }
        image = resizeImage(image: image, targetSize: CGSize(width: 300, height:350) )
        let dateString = Utilities.getCurrentDateString()
        image = textToImage(drawText: dateString as NSString, inImage: image, atPoint: CGPoint(x: 20, y: 15))

        
        popUpImgV.image = image
        uploadImagePopUpContainer.dropShadow()
        self.isPopUpOpened = true
        self.checkIfPopUpOpened()
        self.view.addSubview(uploadImagePopUpContainer)
        //let imageDetails = selectedImageList[selectedImgDetailsIndex]
       // let imageData = (image).jpegData(compressionQuality: 0.8)
//        self.uploadTaskImage(params: [
//                                DictKeys.Category_Id : imageDetails.categoryId, DictKeys.ImageId : imageDetails.imageId],  imageDic: [DictKeys.image : imageData], image: image )
        
    }
}

//MARK: - EXTENSION COLLECTION VIEW METHODS
extension UploadFileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UploadFileCollectionViewCellDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageListViewModel.imagelist.count//self.imageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.UploadFileCollectionViewCell, for: indexPath) as! UploadFileCollectionViewCell
        cell.delegate = self
        cell.configureImageCellImage(info: imageListViewModel.imagelist[indexPath.item], index: indexPath.row)
        //cell.configureImage(image: self.imageList[indexPath.row], index: indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collection = collectionView.bounds.width
        return CGSize(width: 130, height: 150)
            //CGSize(width: (collection / 3), height: (collection / 3) + 50)
    }
    
    func callBackActionDeleteImage(indexP: Int) {
        
        self.showAlertView(message: PopupMessages.SureToDeleteImg, title: "", doneButtonTitle: "Ok") { (UIAlertAction) in
            let imageTodelete = imageListViewModel.imagelist[indexP] //selectedImageList[indexP]
            self.deleteImageServerCall(index: indexP, params: [DictKeys.ImageId: imageTodelete.id, DictKeys.Category_Id:imageTodelete.categoryID]) //update
            //self.imageList.remove(at: indexP)
            //self.viewCollection.reloadData()
        }
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
                        for task in taskSubCategoryList {
                            print(task.id)
                            Global.shared.checkInTaskSubmitions.append(task.id)
                        }
                        UserDefaultsManager.shared.checkInSubmittedTaskIds = Global.shared.checkInTaskSubmitions
                        Global.shared.catWithImagesId = 0
                        self.showAlertView(message: message, title: "CheckList", doneButtonTitle: "Done") { (action) in
                            
                            self.saveImagesToGallery()
                            
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
                        //self.imageList.append(image)
                        self.isPopUpOpened = false
                        self.checkIfPopUpOpened()
                        uploadImagePopUpContainer.removeFromSuperview()
                        popUpDescriptionTxtV.text = ""
                        self.getImagesAgainstCat()
                        //self.viewCollection.reloadData()
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
                        //self.imageList.remove(at: index)
                        //self.selectedImageList.remove(at: index)
                        
                        self.getImagesAgainstCat()
                        //self.viewCollection.reloadData()
                    }else{
                        self.showAlertView(message: message)
                    }
                }
            }
        }
    }
    
    func getimageListApi(params: ParamsAny){
        self.startActivity()
        GCD.async(.Background) {
            CommonService.shared().imageListApi(params: params) { (message, success, imgInfo) in
                GCD.async(.Main) { [self] in
                    self.stopActivity()
                    if success{
                        if let ImgList = imgInfo{
                            imageListViewModel = ImgList
                            self.setCollectionHeight()
                            self.viewCollection.reloadData()
                        }
                        
                    }else{
                        self.showAlertView(message: message)
                    }
                }
            }
        }
    }
    
}
