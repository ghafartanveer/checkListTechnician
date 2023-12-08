//
//  CheckListViewController.swift
//  Checklist
//
//  Created by Rizwan Ali on 20/04/2021.
//

import UIKit
import DropDown
import CropViewController



class CheckListViewController: BaseViewController, TopBarDelegate {
    //MARK: - Outlets
    @IBOutlet weak var heightTableView: NSLayoutConstraint!
    @IBOutlet weak var questionListTV: UITableView!
    @IBOutlet weak var searchBarTF: UITextField!
    @IBOutlet weak var seachBarContainerView: UIView!
    @IBOutlet weak var topBarHeight: NSLayoutConstraint!
    @IBOutlet weak var saperationView: UIView!
    
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
    
    var isPopUpOpened = false
    var isImageRequired = false
    let dropDown = DropDown()
    var imageList = [UIImage]()
    var dropDownsOptionList: [String] = []
    var dropDownOptionIdList: [Int] = []
    var imageDescriptionTxt = "" // this is image description from dropdown or popUpTxtV
    var globalId = 0
    
    
    
    //MARK: - Variables/Objects
    var taskSubCategoryList: [CategoryViewModel] = []
    var filteredDataList: [CategoryViewModel] = []
    var taskToBeSubmitedIDs = [Int]()
    var isNoDataToShow = true
    var taskObjViewModel: TaskViewModel? = nil
    var categoryObj:Category? = nil
    
    //MARK: -  OverRide function
    override func viewDidLoad() {
        super.viewDidLoad()
        popUpDescriptionTxtV.delegate = self
        Global.shared.catWithImagesId = taskSubCategoryList[0].id
        globalId = taskSubCategoryList[0].id //= Global.shared.catWithImagesId
        self.getImagesAgainstCat()
        setUpDropDown()
        configureTblHeight()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        questionListTV.reloadData()
        setCollectionHeight()
        for id in taskToBeSubmitedIDs {
            print(id)
        }
        for task in taskSubCategoryList {
            filteredDataList.append(task)
        }
        addDefaultValues()
        searchBarTF.addTarget(self, action: #selector(searchFieldHandler(textField:)), for: .editingChanged)
        if taskSubCategoryList.count == 1 {
            seachBarContainerView.isHidden = true
            topBarHeight.constant = 40
            saperationView.backgroundColor = .clear
        } else {
            saperationView.backgroundColor = .white
            seachBarContainerView.isHidden = false
            topBarHeight.constant = 90
        }
        if let container = self.mainContainer{
            container.delegate = self
            container.setMenuButton(true, true, title: TitleNames.checklistTaskList)
        }
        for sectionNo in 0..<taskSubCategoryList.count {
            for rowData in 0..<(taskSubCategoryList[sectionNo].taskSubCategory?.taskSubCategoryList.count ?? 0) {
                if rowData > 0 {
                    isNoDataToShow = false
                    break
                }
            }
        }
        if isNoDataToShow {
            questionListTV.setNoDataMessage(LocalStrings.NoDataFound)
        } else {
            questionListTV.removeBackground()
        }
        addDefaultValues()
    }
    
    func configureTblHeight(){
        if taskSubCategoryList.count == 1{
            self.heightTableView.constant = CGFloat(15 + ((taskSubCategoryList.first?.taskSubCategory?.taskSubCategoryList.count ?? 0) * 120))
        }
        else{
            var rowHeight = 0.0
            for each in taskSubCategoryList{
                rowHeight = rowHeight + Double((each.taskSubCategory?.taskSubCategoryList.count ?? 0) * 120)
            }
            self.heightTableView.constant = CGFloat(Double(70 * taskSubCategoryList.count) + (rowHeight))
        }
    }
    
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
        
        for sectionNo in 0..<taskSubCategoryList.count {
            for rowData in 0..<(taskSubCategoryList[sectionNo].taskSubCategory?.taskSubCategoryList.count ?? 0) {
                taskObjViewModel?.categories[sectionNo].checkListQuestions[rowData].status = taskSubCategoryList[sectionNo].taskSubCategory?.taskSubCategoryList[rowData].status ?? QuestionListOptions.defaultValue
            }
        }
        var isAllSelected: Bool = true
        for sectionNo in 0..<taskSubCategoryList.count {
            for rowNo in 0..<(taskSubCategoryList[sectionNo].taskSubCategory?.taskSubCategoryList.count ?? 0) {
                if  taskSubCategoryList[sectionNo].taskSubCategory?.taskSubCategoryList[rowNo].status == QuestionListOptions.defaultValue {
                    isAllSelected = false
                    break
                }
            }
        }
        if isAllSelected {
            if let descriptionText = descriptionTxtV.text {
                taskObjViewModel?.description = descriptionText
            }
            
            if let params = taskObjViewModel?.getParams() {
                print(params)
                submitTaskServerCall(params: params)
            }
        } else {
            self.showAlertView(message: PopupMessages.SelectAllOptions)
        }
        
        //task description
    }
    
    @IBAction func closePopUp(_ sender: Any) {
        self.isPopUpOpened = false
        self.checkIfPopUpOpened()
        uploadImagePopUpContainer.removeFromSuperview()
        
    }
    
    @IBAction func UploadImgBtnAction(_ sender: Any) {
        let image = popUpImgV.image!
        
        //        var description = ""
        //        if dropDownOptionIdList.count > 0 {
        //            description = dropDownBtn.titleLabel?.text ?? ""
        //        } else {
        //            description = popUpDescriptionTxtV.text
        //        }
        if dropDown.selectedItem == dropDownsOptionList[0]{
            imageDescriptionTxt = popUpDescriptionTxtV.text
        }
        
//        if popUpDescriptionTxtV.text != ""  {
//            imageDescriptionTxt = popUpDescriptionTxtV.text
//        }
        
        if imageDescriptionTxt.isEmpty || imageDescriptionTxt == LocalStrings.PlsSelectDescription {
            self.showAlertView(message: PopupMessages.imageDescRequired)
        } else {
            
            let imageData = (image).jpegData(compressionQuality: 0.8)
            let activityId = Global.shared.checkInId
            for each in taskSubCategoryList{ // Global.shared.catWithImagesId
                self.uploadTaskImage(params: [
                    DictKeys.Category_Id : each.id, DictKeys.activity_id: activityId, DictKeys.Description: imageDescriptionTxt], imageDic: [DictKeys.image : imageData], image: image , catId: each.id)
            }
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
       // getimageListApi(params:[
         //   DictKeys.Category_Id : catId, DictKeys.activity_id: activityId ])
        imageListViewModel.imagelist.removeAll()
        for each in taskSubCategoryList{
            getimageListApi(params:[
                DictKeys.Category_Id : each.id, DictKeys.activity_id: activityId ])
        }
        
    }
    
    func actionBack() {
        if !isPopUpOpened {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func setUpDropDown() {
        
        dropDownOptionIdList.insert(-1, at: 0)
        dropDownsOptionList.insert(LocalStrings.PlsSelectDescription, at: 0)
        
        //dropDown.selectedItem = dropDownsOptionList[0]
        dropDown.selectRow(0)
        
        for item in taskSubCategoryList {
            if item.hasImages == 1 {
            for subItem in 0 ..< ((item.taskSubCategory?.taskSubCategoryList.count) ?? 0) {
                if (item.taskSubCategory?.taskSubCategoryList[subItem].subcategoryDescription != "null") && (!(item.taskSubCategory?.taskSubCategoryList[subItem].subcategoryDescription.isEmpty ?? false)) {
                    dropDownsOptionList.append(item.taskSubCategory?.taskSubCategoryList[subItem].subcategoryDescription ?? "")
                    dropDownOptionIdList.append((item.id))
                }
            }
            
            
            
//                for n in 0..<(item.images?.imagelist.count)! {
//
//                    if ((item.images?.imagelist[n].typeName) != "null") {
//
//                        dropDownsOptionList.append((item.images?.imagelist[n].typeName) ?? "")
//
//                        dropDownOptionIdList.append((item.id))
//                    }
//                }
            } else {
                
                Global.shared.catWithImagesId = self.taskSubCategoryList[0].id
            }
        }
        
        if dropDownsOptionList.count > 0 {
            isImageRequired = true
            dropDownContainer.dropShadow()
            dropDown.anchorView = dropDownContainer
            dropDown.dataSource = dropDownsOptionList
            dropDownBtn.setTitle(dropDown.dataSource[0], for: .normal)
            
            imageDescriptionTxt = dropDown.dataSource[0]
            dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                dropDownBtn.setTitle(item, for: .normal)
                if index != 0 {
                    popUpDescriptionTxtV.text = ""
                    popUpDescriptionTxtV.isUserInteractionEnabled = false

                    popUpDescriptionTxtV.isUserInteractionEnabled = false
                    imageDescriptionTxt = item
                    
                    Global.shared.catWithImagesId = dropDownOptionIdList[index]
                    
                    // self.selectedImgDetailsIndex = index
                    // popUpDescriptionTxtV.isUserInteractionEnabled = false
                } else {
                    Global.shared.catWithImagesId = globalId
                    popUpDescriptionTxtV.isUserInteractionEnabled = true
                }
                
            }
        } else {
            popUpDescriptionTxtV.isUserInteractionEnabled = true
            isImageRequired = false
            imagrequiresTaskLbl.isHidden = true
            dropDownContainer.isHidden = true
        }
    }
    
    func setUpDropDown2() {
        
        dropDownOptionIdList.insert(-1, at: 0)
        dropDownsOptionList.insert(LocalStrings.PlsSelectDescription, at: 0)
        
        //dropDown.selectedItem = dropDownsOptionList[0]
        dropDown.selectRow(0)
        
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
            
            imageDescriptionTxt = dropDown.dataSource[0]
            dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                dropDownBtn.setTitle(item, for: .normal)
                if index != 0 {
                popUpDescriptionTxtV.text = ""
                    popUpDescriptionTxtV.isUserInteractionEnabled = false
                imageDescriptionTxt = item
                
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
                // popUpDescriptionTxtV.isUserInteractionEnabled = false
                } else {
                    Global.shared.catWithImagesId = globalId
                    popUpDescriptionTxtV.isUserInteractionEnabled = true
                }
                
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
        
        
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        picker.dismiss(animated: true, completion: nil)
        presentCropViewController(imgToCrop: image)
        
        //        self.imageList.append(image)
        //        picker.dismiss(animated: true, completion: nil)
        //        self.viewCollection.reloadData()
        
        
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
        
        
        
        //openPopUpHere
        //->        uploadImagePopUpContainer.frame = CGRect(x: 20, y: 70, width: ScreenSize.SCREEN_WIDTH - 40, height: ScreenSize.SCREEN_HEIGHT * 0.8)
        
        //        image = resizeImage(image: image, targetSize: CGSize(width: 300, height:350) )
        //        let dateString = Utilities.getCurrentDateString()
        //        image = textToImage(drawText: dateString as NSString, inImage: image, atPoint: CGPoint(x: 20, y: 15))
        //
        //
        //        popUpImgV.image = image
        //        uploadImagePopUpContainer.dropShadow()
        //        self.isPopUpOpened = true
        //        self.checkIfPopUpOpened()
        //        self.view.addSubview(uploadImagePopUpContainer)
        
        
        //    -----------------------------
        //let imageDetails = selectedImageList[selectedImgDetailsIndex]
        // let imageData = (image).jpegData(compressionQuality: 0.8)
        //        self.uploadTaskImage(params: [
        //                                DictKeys.Category_Id : imageDetails.categoryId, DictKeys.ImageId : imageDetails.imageId],  imageDic: [DictKeys.image : imageData], image: image )
        
    }
    
    
    
    override func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        cropViewController.dismiss(animated: true, completion: nil)
        
        uploadImagePopUpContainer.frame = CGRect(x: 20, y: 70, width: ScreenSize.SCREEN_WIDTH - 40, height: ScreenSize.SCREEN_HEIGHT * 0.8)
        let imageResized = resizeImage(image: image, targetSize: CGSize(width: 300, height:350) )
        let dateString = Utilities.getCurrentDateString()
        let finalImage = textToImage(drawText: dateString as NSString, inImage: imageResized, atPoint: CGPoint(x: 20, y: 15))
        
        
        popUpImgV.image = finalImage
        uploadImagePopUpContainer.dropShadow()
        self.isPopUpOpened = true
        self.checkIfPopUpOpened()
        self.view.addSubview(uploadImagePopUpContainer)
        // 'image' is the newly cropped version of the original image
    }
    
    
    //MARK: - IBOutlets
    @IBAction func nextButton(_ sender: Any) {
        for sectionNo in 0..<taskSubCategoryList.count {
            for rowData in 0..<(taskSubCategoryList[sectionNo].taskSubCategory?.taskSubCategoryList.count ?? 0) {
                taskObjViewModel?.categories[sectionNo].checkListQuestions[rowData].status = taskSubCategoryList[sectionNo].taskSubCategory?.taskSubCategoryList[rowData].status ?? QuestionListOptions.defaultValue
            }
        }
        var isAllSelected: Bool = true
        for sectionNo in 0..<taskSubCategoryList.count {
            for rowNo in 0..<(taskSubCategoryList[sectionNo].taskSubCategory?.taskSubCategoryList.count ?? 0) {
                if  taskSubCategoryList[sectionNo].taskSubCategory?.taskSubCategoryList[rowNo].status == QuestionListOptions.defaultValue {
                    isAllSelected = false
                    break
                }
            }
        }
        if isAllSelected {
            navigteToUploadFileVC()
        } else {
            self.showAlertView(message: PopupMessages.SelectAllOptions)
        }
    }
    
    //MARK: - functions
    
    @objc final private func searchFieldHandler(textField: UITextField) {
       // print("Text changed", textField.text)
        
        if(textField.text == ""){
                        taskSubCategoryList.removeAll()
                        for task in filteredDataList {
                            taskSubCategoryList.append(task)
                        }
            
            //self.taskSubCategoryList = self.filteredDataList
            self.questionListTV.reloadData()
        }
        else{
            taskSubCategoryList.removeAll()
            for task in filteredDataList {
                taskSubCategoryList.append(task)
                
            }
            for task in 0..<taskSubCategoryList.count {
                let filterdItemsArray = taskSubCategoryList[task].taskSubCategory?.taskSubCategoryList.filter({ ($0.subcategoryName.lowercased().contains(textField.text!.lowercased())) })
                taskSubCategoryList[task].taskSubCategory?.taskSubCategoryList = filterdItemsArray!
                self.questionListTV.reloadData()
            }
        }
    }
    
    func addDefaultValues() {
        
        var checkListQuestionObjData : [CheckListQuestion] = []
        var categoryObjArr: [Category] = []
        for sec in 0..<taskSubCategoryList.count {
            
            for r in 0..<(taskSubCategoryList[sec].taskSubCategory!.taskSubCategoryList.count ) {
                checkListQuestionObjData.append(CheckListQuestion.init(id: (taskSubCategoryList[sec].taskSubCategory?.taskSubCategoryList[r].id)!, sub_category_name: (taskSubCategoryList[sec].taskSubCategory?.taskSubCategoryList[r].subcategoryName)!, status: "4"))
            }
            
            categoryObj = Category.init(id: taskSubCategoryList[sec].id, hasImages: taskSubCategoryList[sec].hasImages, name: taskSubCategoryList[sec].name, checkListQuestions: checkListQuestionObjData)
            
            checkListQuestionObjData.removeAll()
            categoryObjArr.append(categoryObj!)
            
        }
        taskObjViewModel = TaskViewModel.init(activity_id: Global.shared.checkInId, description: "", categories: categoryObjArr)
       // print("Cat obj: ",categoryObj! as Any)
        
    }
    
//    func actionBack() {
//        self.navigationController?.popViewController(animated: true)
//    }
    
    func navigteToUploadFileVC() {
        let storyboard = UIStoryboard(name: StoryboardNames.Setting, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: ControllerIdentifier.UploadFileViewController) as! UploadFileViewController
        vc.taskSubCategoryList = taskSubCategoryList
        vc.taskViewModel = taskObjViewModel
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
//MARK: - EXTENISON TABEL VIEW METHODS

extension CheckListViewController: UITableViewDelegate, UITableViewDataSource{
    //        func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    //            taskSubCategoryList[section].name
    //        }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return taskSubCategoryList.count
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if taskSubCategoryList.count == 1 {
            return 10
        }
        return 70
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if taskSubCategoryList.count == 1 {
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 10))
            headerView.backgroundColor = .clear
            return headerView
        }
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
        headerView.backgroundColor = .clear
        let label = UILabel(frame: CGRect(x: 20, y: 7, width: headerView.frame.width, height: headerView.frame.height))
        label.text = taskSubCategoryList[section].name
        let boldAttribute = [
            NSAttributedString.Key.font: UIFont(name: "Poppins SemiBold", size: 18.0) ?? UIFont.systemFont(ofSize: 18)
        ]
        let boldTitleText = NSAttributedString(string: taskSubCategoryList[section].name, attributes: boldAttribute)
        label.attributedText = boldTitleText
        headerView.addSubview(label)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (taskSubCategoryList[section].taskSubCategory?.taskSubCategoryList.count ?? 0) > 0 {
            self.isNoDataToShow = false
        }
        return taskSubCategoryList[section].taskSubCategory?.taskSubCategoryList.count ?? 0 //taskSubCategoryList.taskSubCategory?.taskSubCategoryList.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.CheckListTableViewCell) as! CheckListTableViewCell
        let data = taskSubCategoryList[indexPath.section].taskSubCategory?.taskSubCategoryList[indexPath.row]
        cell.delegate = self
        
        cell.btnYes.tag = (indexPath.section*1000) + indexPath.row
        cell.btnNo.tag = (indexPath.section*1000) + indexPath.row
        cell.btnNotAvailable.tag = (indexPath.section*1000) + indexPath.row
        cell.cofigureCellData(info: data!, index: indexPath.row)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenSize.SCREEN_WIDTH, height: 2))
        let inerView = UIView(frame: CGRect(x: (footerView.frame.origin.x + 80), y: 0, width: footerView.frame.size.width - 160, height: 2))
        inerView.backgroundColor = .black
        footerView.backgroundColor = .clear
        footerView.addSubview(inerView)
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 2
    }
}

extension CheckListViewController: CheckListTableViewCellDelegate {
    
    func yesBtn(btn: UIButton) {
        let btnTag = btn.tag
        
        let btnRow = btnTag % 1000
        let btnSection = btnTag / 1000
       
        taskSubCategoryList[btnSection].taskSubCategory?.taskSubCategoryList[btnRow].status = QuestionListOptions.yes
        //print("Section: ", btnSection, "Row : ",btnRow )
        questionListTV.reloadData()
        
    }
    
    func noBtn(btn: UIButton) {
        let btnTag = btn.tag
        
        let btnRow = btnTag % 1000
        let btnSection = btnTag / 1000
        
        taskSubCategoryList[btnSection].taskSubCategory?.taskSubCategoryList[btnRow].status = QuestionListOptions.no
       // print("Section: ", btnSection, "Row : ",btnRow )
        questionListTV.reloadData()
        
    }
    
    func notAvalable(btn: UIButton) {
        let btnTag = btn.tag
        
        let btnRow = btnTag%1000
        let btnSection = btnTag/1000
        
        taskSubCategoryList[btnSection].taskSubCategory?.taskSubCategoryList[btnRow].status = QuestionListOptions.notAvilAble
    
       // print("Section: ", btnSection, "Row : ",btnRow )
        questionListTV.reloadData()
        
    }
}

//======================================
// to create Params for submit_Task Api
// MARK: - TaskViewModel
struct TaskViewModel {
    var activity_id: Int
    var description: String
    var categories: [Category]
    
    func getParams() -> ParamsAny {
        
        var categoryParam = [ParamsAny]()
        
        for cat in categories {
            var listParam = [ParamsAny]()
            for list in cat.checkListQuestions{
                let listquesParam : ParamsAny = ["id":list.id, "sub_category_name": list.sub_category_name,"status": list.status]
                listParam.append(listquesParam)
            }
            
            let innerCategoryParam : ParamsAny = ["id" : cat.id,"name" : cat.name,"hasImages": cat.hasImages,"checkListQuestions" :listParam ]
            categoryParam.append(innerCategoryParam)
            
        }
        let param: ParamsAny = ["activity_id" : activity_id, "description" : description, "categories" : categoryParam]
        return param
    }
    
}

// MARK: - Category
struct Category {
    var id,hasImages : Int
    var name : String
    var checkListQuestions: [CheckListQuestion]
}

// MARK: - CheckListQuestion
struct CheckListQuestion {
    var id : Int
    var sub_category_name, status: String
}


//MARK: - EXTENSION COLLECTION VIEW METHODS
extension CheckListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UploadFileCollectionViewCellDelegate{
    
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
        
        self.showAlertView(message: PopupMessages.SureToDeleteImg, title: ALERT_TITLE_APP_NAME, doneButtonTitle: LocalStrings.ok, doneButtonCompletion: { (UIAlertAction) in
            
            let imageTodelete = imageListViewModel.imagelist[indexP]
            self.deleteImageServerCall(index: indexP, params: [DictKeys.ImageId: imageTodelete.id, DictKeys.Category_Id:imageTodelete.categoryID])
            
        }, cancelButtonTitle: LocalStrings.Cancel) { (UIAlertAction) in
            
        }
    }
}

extension CheckListViewController {
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
                            Global.shared.imageIdsToDeleteOnKill = []
                            self.saveImagesToGallery()
                            self.navigationController?.popViewController(animated: true)
                           // self.navigationController?.popToRootViewController(animated: true)
                        }
                        
                    }else{
                        self.showAlertView(message: message)
                    }
                }
            }
        }
    }
    
    func uploadTaskImage(params: ParamsAny, imageDic: [String:Data?], image: UIImage , catId : Int = 0){
        print(params)
        self.startActivity()
        GCD.async(.Background) {
            CommonService.shared().uploadImagesApi(params: params, Img: imageDic) { (_ message:String, _ success:Bool) in
                GCD.async(.Main) { [self] in
                    self.stopActivity()
                    if success{
                        //self.imageList.append(image)
                        self.isPopUpOpened = false
                        self.checkIfPopUpOpened()
                        popUpDescriptionTxtV.text = ""
                        imageDescriptionTxt = ""
                        
                        dropDown.selectRow(0)
                        dropDownBtn.setTitle(dropDownsOptionList[0], for: .normal)
                        uploadImagePopUpContainer.removeFromSuperview()
                        if catId ==  taskSubCategoryList.last?.id ?? 0{
                            self.getImagesAgainstCat()
                        }
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
                        Global.shared.imageIdsToDeleteOnKill = []

                        if let ImgList = imgInfo{
                            imageListViewModel.imagelist.append(contentsOf: ImgList.imagelist) //= ImgList
                           
                            Global.shared.imageIdsToDeleteOnKill = imageListViewModel.imagelist.map({($0.id ?? -1)})
                            Global.shared.imageIdsToDeleteOnKill = Global.shared.imageIdsToDeleteOnKill.filter({$0 != -1})
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
