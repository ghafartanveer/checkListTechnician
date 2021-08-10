//
//  BaseViewController.swift
//  AlKadi
//
//  Created by Khurram Bilal Nawaz on 22/07/2016.
//  Copyright © 2016 Khurram Bilal Nawaz. All rights reserved.
//

import UIKit
import SDWebImage
import MBProgressHUD
import StoreKit
import AVFoundation
import CropViewController

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
    
    class func fromNib<T : UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}


extension UIViewController{
    
    var mainContainer : MainContainerViewController? {
        
        get{
            var foundController: MainContainerViewController? = nil
            var currentViewController : UIViewController? = self
            
            if(self.isKind(of: MainContainerViewController.self)){
                foundController = (self as! MainContainerViewController)
            }else{
                while true{
                    if let parent = currentViewController?.parent {
                        if parent.isKind(of: MainContainerViewController.self){
                            foundController = (parent as! MainContainerViewController)
                            break
                        }else if parent.isKind(of: BaseNavigationController.self){
                            let navController = parent as! BaseNavigationController
                            if let parentController = navController.view.superview?.parentViewController{
                                if parentController.isKind(of: MainContainerViewController.self){
                                    foundController = (parentController as! MainContainerViewController)
                                    break
                                }
                            }
                        }
                        
                    }
                    else {
                        break
                    }
                    currentViewController = currentViewController?.parent
                }
            }
            
            return foundController
        }
    }
    
}


public class BaseViewController : UIViewController, UIGestureRecognizerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate,KYDrawerControllerDelegate, CropViewControllerDelegate, UITextViewDelegate {
    
    
    
    var hud = MBProgressHUD()
    var disableMenuGesture: Bool = false
    var objAlertVC:BaseViewController?
    var alertView = CustomIOSAlertView()
    var popupAlertView = CustomIOSAlertView()
    
    var isImgeSourceCamra = false
    
    lazy var profileImagePicker: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        return imagePicker
    }()
    
    lazy var refreshControl: UIRefreshControl = {
        let view = UIRefreshControl()
        view.tintColor = .white
        view.addTarget(self, action: #selector(handleRefreshController), for: .valueChanged)
        return view
    }()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // self.mainContainer?.setRightButton()
        //self.mainContainer?.topbarView.isHidden = false
    }
    
    @objc func handleRefreshController(_ refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
    }
    
    //    func logoutUserAccount() {
    //        UserDefaultsManager.shared.clearUserData()
    //        let storyboard = UIStoryboard(name: StoryboardNames.Registeration, bundle: nil)
    //       // let controller = storyboard.instantiateViewController(withIdentifier: ControllerIdentifier.LoginViewController) as! LoginViewController
    //        if let container = self.navigationController?.navigationController?.parent as? KYDrawerController {
    //       //     container.navigationController?.setViewControllers([controller], animated: true)
    //            container.navigationController?.popToRootViewController(animated: true)
    //        }
    //    }
    
    
    func addTapGesture()  {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        tapGesture.delegate = self
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    func fetchCameraImage(){
        if(UIImagePickerController.isSourceTypeAvailable(.camera)){
            self.profileImagePicker.sourceType = .camera
            self.present(self.profileImagePicker, animated: true, completion:  nil)
        }else{
            print("Camera is not available")
        }
    }
    func fetchProfileImage(_ message:String = kBlankString){
        let actionSheet = UIAlertController.init(title: "Select Image", message: message, preferredStyle: UIAlertController.Style.actionSheet)
        actionSheet.addAction(UIAlertAction.init(title: "Camera", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
            if(UIImagePickerController.isSourceTypeAvailable(.camera)){
               // self.profileImagePicker.allowsEditing = true
                self.profileImagePicker.sourceType = .camera
                self.isImgeSourceCamra = true
                self.present(self.profileImagePicker, animated: true, completion:  nil)
            }else{
                print("Camera is not available")
            }
        }))
        
        actionSheet.addAction(UIAlertAction.init(title: "Photo Gallary", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
            self.profileImagePicker.sourceType = .photoLibrary
            self.isImgeSourceCamra = false
            //self.profileImagePicker.allowsEditing = true

            self.present(self.profileImagePicker, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction.init(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { (UIAlertAction) in
        }))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        picker.dismiss(animated: true, completion: nil)
        presentCropViewController(imgToCrop: image)
        print("image selected succesfully")
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.profileImagePicker.dismiss(animated: true, completion: nil)
    }
    
    public func presentCropViewController(imgToCrop: UIImage) {
        let image: UIImage = imgToCrop //Load an image
        
        let cropViewController = CropViewController(image: image)
        cropViewController.delegate = self
        present(cropViewController, animated: true, completion: nil)
    }
    
    public func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        cropViewController.dismiss(animated: true, completion: nil)
        
        print("Croped image here")
        // 'image' is the newly cropped version of the original image
    }
    
    func showAlertVIew(message:String, title:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (result : UIAlertAction) -> Void in
            //self.closeAlertMessage()
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    public func checkCameraPermission() -> Bool {
        if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) == .authorized {
            return true
        }else {
            return false
        }
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return true
    }
    
    func addShadowOnView(view:UIView,color:UIColor,radius:Int,opacity:Float? = 1) {
        //view.center = self.view.center
        view.layer.shadowOpacity = opacity!
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowRadius = CGFloat(radius)
        view.layer.shadowPath = UIBezierPath(rect: view.bounds).cgPath
        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = UIScreen.main.scale
        //self.view.addSubview(view)
    }
    
    func setBorderColor(view:UIView,color:UIColor? = .white, width:CGFloat? = 1) {
        view.layer.borderWidth = width!
        view.layer.borderColor = color!.cgColor
    }
    
    func stopActivity(containerView: UIView? = nil) {
        MBProgressHUD.hide(for: self.view, animated: true)
        //        if let _ = containerView{
        //            MKProgress.hide()
        //        }else{
        //            MKProgress.hide()
        //        }
    }
    
    func startActivity() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        // MKProgress.show()
    }
    
    func checkInternetConnection() -> Bool{
        if(BReachability.isConnectedToNetwork()){
            return true
        }
        self.showAlertVIew(message: PopupMessages.SomethingWentWrong, title: "")
        return false
    }
    
    //Mark:-SetImageWithUrl
    func setImageWithUrl(imageView:UIImageView,url:String, placeholderImage:String? = ""){
        let finalUrl = url.replacingOccurrences(of: " ", with: "%20")
        if let imageurl =  NSURL.init(string: finalUrl){
            imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            imageView.sd_setImage(with: imageurl as URL?, placeholderImage: UIImage(named:placeholderImage!))
        }
    }
    
    func setBtnImageWithUrl(btn: UIButton, urlStr: String, placeholderImage:String? = "") {
        btn.sd_setImage(with: URL(string: urlStr), for: UIControl.State.normal, placeholderImage: UIImage(named: placeholderImage!), options: SDWebImageOptions(rawValue: 0)) { (image, error, cache, url) in
            
        }
    }
    
    
    func setPlaceholderTextColor(textfield:UITextField,text:String) {
        
        textfield.attributedPlaceholder = NSAttributedString(string: text,
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.groupTableViewBackground])
        
        
    }
    func setPlaceholderBlackColor(textfield:UITextField){
        
        textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder!,
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        
        
    }
    
    func imageWithRenderDateMetaData(image: UIImage) -> UIImage? {
        print("Start : \(Utilities.getCurrentDateString()))")
        
        
        let dateString =  "    " + Utilities.getCurrentDateString()
        UIGraphicsBeginImageContext(image.size);
        
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        let label = UILabel()
        label.text = dateString
        label.adjustsFontSizeToFitWidth = true
        //label.font = UIFont(name: "HelveticaNeue-Bold", size: 70)
        
        let rect = CGRect(x: 50, y: 50, width: image.size.width/2, height: 120)
        
        UIColor.clear.withAlphaComponent(0.3).setFill()
        UIRectFill(rect)
        label.tintColor = .red
        
        label.drawText(in: rect)
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        print("end : \(Utilities.getCurrentDateString()))")
        return newImage
    }
    
    func textToImage(drawText: NSString, inImage: UIImage, atPoint: CGPoint) -> UIImage{
        
        // Setup the font specific variables
        let textColor = UIColor.red
        let textFont = UIFont(name: "Helvetica Bold", size: 15) ?? UIFont.systemFont(ofSize: 15)
        
        // Setup the image context using the passed image
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(inImage.size, false, scale)
        
        // Setup the font attributes that will be later used to dictate how the text should be drawn
        let textFontAttributes = [
            NSAttributedString.Key.font: textFont,
            NSAttributedString.Key.foregroundColor: textColor,
        ]
        
        // Put the image into a rectangle as large as the original image
        let rectPoint = CGRect(x: 0, y: 0, width: inImage.size.width, height: inImage.size.height)
        inImage.draw(in: rectPoint)
        
        // Create a point within the space that is as bit as the image
        var rect = CGRect(x: atPoint.x, y: atPoint.y, width: inImage.size.width, height: inImage.size.height)
            
            //CGRectMake(atPoint.x, atPoint.y, inImage.size.width, inImage.size.height)
        
        // Draw the text into an image
        drawText.draw(in: rect, withAttributes: textFontAttributes)
        
        // Create a new image out of the images we have created
        let newImage = UIGraphicsGetImageFromCurrentImageContext() ?? inImage
        
        // End the context now that we have the image we need
        UIGraphicsEndImageContext()
        
        //Pass the image back up to the caller
        return newImage
        
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    //MARK:-setToolbarOnPickerView
    func addToolBarToPickerView(textField:UITextField)
    {
        var buttonDone = UIBarButtonItem()
        let toolbar = UIToolbar()
        toolbar.barStyle = UIBarStyle.default
        toolbar.sizeToFit()
        let buttonflexible = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        
        let button =  UIButton(type: .custom)
        button.addTarget(self, action: #selector(BaseViewController.doneClicked(_:)), for: .touchUpInside)
        button.setTitle("Done", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
        button.contentMode = UIView.ContentMode.right
        button.frame = CGRect(x:0, y:0, width:60, height:40)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0)
        
        buttonDone = UIBarButtonItem(customView: button)
        
        
        toolbar.setItems(Array.init(arrayLiteral: buttonflexible,buttonDone), animated: true)
        textField.inputAccessoryView = toolbar
        
    }
    
    func addToolBarToPickerViewOnTextview(textview:UITextView)
    {
        var buttonDone = UIBarButtonItem()
        let toolbar = UIToolbar()
        toolbar.barStyle = UIBarStyle.default
        toolbar.sizeToFit()
        let buttonflexible = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        let button =  UIButton(type: .custom)
        button.addTarget(self, action: #selector(BaseViewController.doneClicked(_:)), for: .touchUpInside)
        //button.frame = CGRectMake(0, 0, 53, 31)
        button.setTitle("Done", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        //button.setTitleColor(UIColor(netHex: 0xAE2540), for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
        button.contentMode = UIView.ContentMode.right
        button.frame = CGRect(x:0, y:0, width:60, height:40)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0)
        
        buttonDone = UIBarButtonItem(customView: button)
        toolbar.setItems(Array.init(arrayLiteral: buttonflexible,buttonDone), animated: true)
        textview.inputAccessoryView = toolbar
        
    }
    
    override public func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing,animated:animated)
        if (self.isEditing) {
            self.editButtonItem.title = "Editing"
        }
        else {
            self.editButtonItem.title = "Not Editing"
        }
    }
    
    @IBAction func doneClicked(_ sender:AnyObject)
    {
        self.hideKeyboard()
    }
    
    func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    func showAlertView(message:String) {
        showAlertView(message: message, title: ALERT_TITLE_APP_NAME)
    }
    
    func showAlertView(message:String, title:String, doneButtonTitle:String, doneButtonCompletion: ((UIAlertAction) -> Void)?) {
        showAlertView(message: message, title: title, doneButtonTitle: doneButtonTitle, doneButtonCompletion: doneButtonCompletion, cancelButtonTitle: nil, cancelButtonCompletion: nil)
    }
    
    func showAlertView(message:String, title:String, doneButtonTitle:String = "OK", doneButtonCompletion: ((UIAlertAction) -> Void)? = nil, cancelButtonTitle:String? = nil, cancelButtonCompletion:((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: doneButtonTitle, style: .default, handler: doneButtonCompletion)
        if let cancelTitle = cancelButtonTitle {
            let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: cancelButtonCompletion)
            alertController.addAction(cancelAction)
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    func buildAlertSheet(with title:String? = nil, message:String? = nil, options:[String], completion: @escaping (Int,String)->Void) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        for index in 0..<options.count {
            let action = UIAlertAction(title: options[index], style: .default) { (_) in
                completion(index,options[index])
            }
            
            controller.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: LocalStrings.Cancel, style: .cancel, handler: nil)
        controller.addAction(cancelAction)
        self.present(controller, animated: true, completion: nil)
    }
    
    func openSettings()  {
        let settingUrl = URL(string: UIApplication.openSettingsURLString)!
        if let _ = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(settingUrl) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(settingUrl, completionHandler: { (success) in
                        print("Settings opened: \(success)")
                    })
                } else {
                    UIApplication.shared.openURL(settingUrl)
                }
            }
        }
    }
    
    // Resend Message Popup Delegate
    func actionCallBackResend() {
        
    }
    func getUrl(lat: Double, lng : Double) -> String{
        let url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(lat),\(lng)&key=\(APIKeys.googleApiKey)"
        return url
    }
    
    
    //MARK: - SETUP OBSERVER OF AUTHORIZATION
    func setupAuthObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.userUnAuthorized), name: NotificationName.UnAuthorizedAccess, object: nil)
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: NotificationName.UnAuthorizedAccess, object: nil)
    }
    @objc private func userUnAuthorized(){
        GCD.async(.Main) {
            if let topController = UIApplication.shared.topViewController() as? BaseViewController {
                topController.stopActivity()
            }
            
            GCD.async(.Main, delay: 2) {
                UIApplication.shared.endIgnoringInteractionEvents()
                self.showAlertView(message: PopupMessages.Session_Expired, title: ALERT_TITLE_APP_NAME, doneButtonTitle: LocalStrings.ok) { (_) in
                    self.logoutUserAccount()
                }
            }
        }
    }
}

//Mark:- SaveUserInfo

extension BaseViewController{
    
    func saveUserInfo(_ userInfo:UserViewModel) {
        Global.shared.user = userInfo
        Global.shared.isLogedIn = true
        UserDefaultsManager.shared.isUserLoggedIn = true
        UserDefaultsManager.shared.userInfo = userInfo
        
    }
    
    func loadHomeController(){
        if let container = self.revealViewController()?.frontViewController as? MainContainerViewController{
            container.showHomeController()
        }
    }
    func logoutUserAccount() {
        Global.shared.isLogedIn = false
        UserDefaultsManager.shared.clearUserData()
        let storyboard = UIStoryboard(name: StoryboardNames.Registration, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: ControllerIdentifier.LoginViewController) as! LoginViewController
        if let container = self.navigationController?.parent as? MainContainerViewController {
            container.navigationController?.setViewControllers([controller], animated: true)
            container.navigationController?.popToRootViewController(animated: true)
        }else if let container = self.parent as? SWRevealViewController {
            container.navigationController?.setViewControllers([controller], animated: true)
            container.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    

}

extension BaseViewController: ChangePasswordPopUpViewControllerDelegate {
    
    func showChangePasswordPopUP(){
        self.alertView = CustomIOSAlertView()
        self.alertView?.buttonTitles = nil
        self.alertView?.useMotionEffects = true
        self.alertView?.touchesEnabled = false
        var demoView:UIView!
        demoView = UIView()
        
        let storyBoard = UIStoryboard(name: StoryboardNames.Setting, bundle: nil)
        if let vc = storyBoard.instantiateViewController(withIdentifier: ControllerIdentifier.ChangePasswordPopUpViewController) as? ChangePasswordPopUpViewController
        {
            
            vc.delegate = self
            
            self.objAlertVC = vc
            demoView.frame = CGRect(x:0, y:0, width: ScreenSize.SCREEN_WIDTH - 30, height: 350)
            vc.view.frame = CGRect(x:0, y:0, width: ScreenSize.SCREEN_WIDTH - 30, height: 350)
            
            demoView.addSubview(vc.view)
            
            self.alertView?.containerView = demoView
        }
        
    }
    
    func closePopUP() {
        self.alertView?.close()
    }
    @objc func callBackActionSubmit(crntPswd cruntpsd:String, newPasword: String) {
    }
}
extension BaseViewController: VehicleDetailPopUpViewControllerDelegate {
    
    func showVehicleDetailPopUP(){
        self.alertView = CustomIOSAlertView()
        self.alertView?.buttonTitles = nil
        self.alertView?.useMotionEffects = true
        self.alertView?.touchesEnabled = true
        var demoView:UIView!
        demoView = UIView()
        
        let storyBoard = UIStoryboard(name: StoryboardNames.Setting, bundle: nil)
        if let vc = storyBoard.instantiateViewController(withIdentifier: ControllerIdentifier.VehicleDetailPopUpViewController) as? VehicleDetailPopUpViewController
        {
            
            vc.delegate = self
            
            self.objAlertVC = vc
            demoView.frame = CGRect(x:0, y:0, width: ScreenSize.SCREEN_WIDTH - 40, height: 420)
            vc.view.frame = CGRect(x:0, y:0, width: ScreenSize.SCREEN_WIDTH - 40, height: 420)
            
            demoView.addSubview(vc.view)
            
            self.alertView?.containerView = demoView
        }
        
    }
    
    @objc func callBackActionSave(txtVehicleNumber _: String, txtCustomerName _: String) {
        
    }
    
}

extension BaseViewController: FilterSelctionPopUpViewControllerDelegte {
    
    func showHistorySlectionPopup(){
        self.alertView = CustomIOSAlertView()
        self.alertView?.buttonTitles = nil
        self.alertView?.useMotionEffects = true
        self.alertView?.touchesEnabled = true
        var demoView:UIView!
        demoView = UIView()
        
        let storyBoard = UIStoryboard(name: StoryboardNames.Home, bundle: nil)
        if let vc = storyBoard.instantiateViewController(withIdentifier: ControllerIdentifier.FilterSelctionPopUpViewController) as? FilterSelctionPopUpViewController
        {
            
            vc.delegate = self
            
            self.objAlertVC = vc
            demoView.frame = CGRect(x:0, y:0, width: ScreenSize.SCREEN_WIDTH - 40, height: 320)
            vc.view.frame = CGRect(x:0, y:0, width: ScreenSize.SCREEN_WIDTH - 40, height: 320)
            
            demoView.addSubview(vc.view)
            
            self.alertView?.containerView = demoView
        }
        
    }
    
    @objc func callBackYesterdayPressed() {
        
    }
    
    @objc func callBackLastWeekPressed() {
        
    }
    
    @objc func callBackLastMonthPressed() {
        
    }
    
    @objc func callBackAllListPressed() {
        
    }
    
    
}

