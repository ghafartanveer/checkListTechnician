
import Foundation
import UIKit


typealias ParamsAny             = [String:Any]
typealias ParamsString          = [String:String]

let ALERT_TITLE_APP_NAME        = "CheckList"
let EMAIL_REGULAR_EXPRESSION    = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

struct SideMenu {
//    static let MENULIST = [["title":"Top Priority/Task","image":"settings"],
//                           ["title":"Reminder","image":"Reminder"],
//                           ["title":"Notes","image":"notes_Icon"],
//                           ["title":"Language-English","image":"global"],
//                           ["title":"Setting/Profile","image":"settings"],
//                           ["title":"Notification - On/Off","image":"bell"],
//                           ["title":"About Us","image":"information_Icon"]]
    
    static let MENULIST = [["title":"Home","image":"home_icon"],
                           ["title":"About Us","image":"menu_about_us"],
                           ["title":"Help","image":"help_icon"],
                           ["title":"Settings","image":"menu_setting_icon"]]

}
struct HomeMenu {
//    static let MENU_LIST = [["title":"Check In","image":"Group14"],
//                            ["title":"All Tasks","image":"Group16"],
//                            ["title":"Check Out","image":"Group18"],
//                            ["title":"History","image":"Group22"]]
    
    static let MENU_LIST = [
        ["title":"All Check List","image":"Group18"],
        ["title":"Hostory","image":"Group22"],
        ["title":"Check In","image":"Group16"],
        ["title":"Chck Out","image":"ic_check_out"]]
}




struct APIKeys {
    static let googleApiKey     = "AIzaSyBTfypSbx_zNMhWSBXMTA2BJBMQO7_9_T8"
}

struct StoryboardNames {
    static let Registration = "Registration"
    static let Main = "Main"
    static let Home = "Home"
    static let Setting = "Setting"
    static let AboutUs = "AboutUs"
    static let Help = "Help"
}

struct TitleNames {
    static var Work_List = "Work List"
    static var Check_List = "Check List"
    static var Upload_File = "Upload File"
    static let Home = "Home"
    static let Setting = "Setting"
    static let History = "History"
    static let Pending_Task = "Pending Task"
    static let Completed_Task = "Completed Task"
    static let About_Us = "About Us"
    static let Help = "Help"
}

struct LoginType {
    static let Admin = "admin"
    static let Technician = "technician"
}


struct NavigationTitles {
    static let Home                 = "Home"
    
}

struct NotificationName {
    static let UnAuthorizedAccess    = Notification.Name(rawValue: "UnAuthorizedAccess")
}

struct AssetNames {
    static let sideLogo = "menu-icon"
    static let Back_Icon = "back-icon"
    static let Box_Blue = "BoxBlue"
    static let Box_Red = "BoxRed"
    static let Delete_Icon = "deleteIcon"
    static let Edit_Icon = "editIcon"
    static let UsrPlacHolderImage = "user_image"
    
}

struct AssetColors {
    static let pinkThemeColor = "PinkThemeColor"
}
struct ServiceMessage {
    static let LocationTitle       = "Location Service Off"
    static let LocationMessage     = "Turn on Location in Settings > Privacy to allow myLUMS to determine your Location"
    static let Settings            = "Settings"
    static let CameraTitle         = "Permission Denied"
    static let CameraMessage       = "Turn on Camera in Settings"
}

struct ControllerIdentifier {
    static let SWRevealViewController = "SWRevealViewController"
    static let CheckListViewController = "CheckListViewController"
    static let CheckListHistoryViewController = "CheckListHistoryViewController"
    static let HomeVC = "HomeVC"
    static let settingVC = "settingVC"
    static let SWRevealVC = "SWRevealVC"
    static let WorkListViewController = "WorkListViewController"
    static let UploadFileViewController = "UploadFileViewController"
    static let ProfileSettingViewController = "ProfileSettingViewController"
    static let ChangePasswordPopUpViewController = "ChangePasswordPopUpViewController"
    static let CalenderViewController = "CalenderViewController"
    static let LoginViewController = "LoginViewController"
    static let ForgetPasswordViewController = "ForgetPasswordViewController"
    static let VehicleDetailPopUpViewController = "VehicleDetailPopUpViewController"
    static let UpdatePasswordViewController = "UpdatePasswordViewController"
    static let aboutUsVc = "aboutUsVc"
    static let helpVC = "helpVC"
    static let HistoryDetailsViewController = "HistoryDetailsViewController"
    static let FilterSelctionPopUpViewController = "FilterSelctionPopUpViewController"
}

struct ValidationMessages {
    static let VerifyNumber = "Please Verify Your Number"
    static let EmptyPhonNumber = "Please enter phone number"
    static let SomeThingWrong = "SomeThingWrong"
    static let PhoneNumberVerified = "PhoneNumber Verified Successfully"
    static let WrondPinCode = "Please Enter A Valid VerificationCode"
    static let loginSuccessfully            = "You are logged in"
    static let selectProfileimage           = "Select Profile Image"
    static let emptyName                    = "Please enter your name"
    static let emptyEmail                   = "Please enter your email"
    static let enterValidEmail              = "Please enter valid email"
    static let emptyPassword                = "Password field cannot be empty"
    static let shortPassword                = "Password must be atleast 6 characters"
    static let reTypePassword               = "Please re-type password"
    static let nonMatchingPassword          = "Password is not matching"
    static let invalidPhoneNumber           = "Enter a valid phone number"
    static let configurationUrl             = "Please enter configuration url"
    static let validUrl                     = "Please enter valid url"
    static let emptyPhonNumber              = "Please enter phone number"
    static let emptyPincode                 = "Please enter pincode from email to continue"
    static let emptyCategoryName            = "Please enter category name first"
    static let emptyProductName             = "Please enter product name first"
    static let invalidProductPrice          = "Please enter a valid price for product"
    static let emptyProductInfo             = "Please describe product briefly"
    static let noImageProduct               = "Add at least one image of product"
    static let selectWeightUnit             = "Select product weight unit first"
    static let commentsMissing              = "Comment field cannot empty"
    static let noLocationAdded              = "Location info is must in order to become a supplier"
    static let fillAllFields              = "Please fill all fields"
}

struct CellIdentifier {
    static let TaskCategoryTableViewCell = "TaskCategoryTableViewCell"
    static let TaskTypesTableViewCell = "TaskTypesTableViewCell"
    static let HomeCollectionViewCell = "HomeCollectionViewCell"
    static let CheckListTableViewCell = "CheckListTableViewCell"
    static let WorkListTableViewCell = "WorkListTableViewCell"
    static let SideMenuTableViewCell = "SideMenuTableViewCell"
    static let UploadFileCollectionViewCell = "UploadFileCollectionViewCell"
    static let CalenderTableViewCell = "CalenderTableViewCell"
    static let TaskHistoryTableViewCell = "TaskHistoryTableViewCell"
    static let HistoryDetailsTaskListTableViewCell = "HistoryDetailsTaskListTableViewCell"
    
}

struct PopupMessages {
    static let Empty_Vehicle_Number = "Please enter vehicle registration number"
    static let Enter_Customer_Name = "Please enter customer name"
    static let Enter_Current_Password = "Please enter your current password"
    static let Enter_New_Password = "Please enter your new password"
    static let emptySearch = "Please enter something for search"
    static let verification = "Verification Code Sent Again Successfully"
    static let LocationNotFound             = "Location Not found"
    static let cantSendMessage              = "Cant Send Message Now Please Try Agian Later"
    static let warning                      = "Warning"
    static let sureToLogout                 = "Are you sure to logout"
    static let nothingToUpdate              = "Nothing to update"
    static let orderMarkedCompleted         = "Order marked completed successfullly"
    static let unAuthorizedAccessMessage    = "Session expired, please login again"
    static let cameraPermissionNeeded       = "Camera permission needed to scan QR Code. Goto settings to enable camera permission"
    static let SomethingWentWrong           = "Something went wrong, please check your internet connection or try again later!"
    static let CheckInFirst = "Please Check In First!"
    static let AlreadyCheckedIn = "You are already Chcked In!"
    static let SelectAllOptions = "Please answer all questions!"
    static let ImagesNotRequired = "Images not required!"
}

struct LocalStrings {
    static let success              = "Success"
    static let ok                   = "OK"
    static let Yes                  = "Yes"
    static let No                   = "No"
    static let edit                 = "Edit"
    static let delete               = "Delete"
    static let Cancel               = "Cancel"
    static let Camera               = "Camera"
    static let complete             = "COMPLETE"
    static let prepare              = "PREPARE"
    static let update               = "UPDATE"
    static let NoDataFound          = "No data found"
    static let EnterUsername        = "Enter Username"
    static let EnterEmail           = "Enter Email"
    static let OldPassword          = "Old Password"
    static let EnterOldPassword     = "Enter old password"
    static let ChangePassword       = "CHANGE PASSWORD"
    static let noDescription        = "No description available"
    static let cancellationReason   = "Cancellation Reason"
    static let deleteProduct        = "Please Select Product To Delete"
    static let enableProduct        = "Please Select Product To Enable"
    static let disableProduct       = "Please Select Product To Disable"
    static let EmptySubject        = "Please Enter Subject"
    static let EmptyMessage        = "Please Enter Message"
}

struct QuestionListOptions {
    static let no = "0"
    static let yes = "1"
    static let notAvilAble = "2"
    static let defaultValue = "4"
}

struct AppFonts {
    static func CenturyGolthicBoldWith(size : CGFloat) -> UIFont {
        
        if let font = UIFont(name: "Century Gothic Bold", size: size) {
            return font
        }
        else {
            return UIFont.systemFont(ofSize: size)
        }
    }
    static func CenturyGolthicRegularWith(size : CGFloat) -> UIFont {
        
        if let font = UIFont(name: "Century Gothic Regular", size: size) {
            return font
        }
        else {
            return UIFont.systemFont(ofSize: size)
        }
    }
}
