//
//  AppDelegate.swift
//  Checklist
//
//  Created by Rizwan Ali on 19/04/2021.
//

import UIKit
import CoreData
import DropDown
import IQKeyboardManagerSwift
import Firebase
import SwiftyJSON
import FirebaseMessaging

@main
class AppDelegate: UIResponder, UIApplicationDelegate,  MessagingDelegate {
    var gcmMessageIDKey = "gcm message 1234"

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //self.setupInitialController()
        DropDown.startListeningToKeyboard()
        IQKeyboardManager.shared.enable = true
        
        
        FirebaseApp.configure()
        // Messaging.messaging().isAutoInitEnabled = true
        //ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        self.getFireBaseToken()
        Messaging.messaging().delegate = self
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
        
        if let notificationData = launchOptions?[.remoteNotification] {
            
            let json = JSON(notificationData)
            print(json)
            let object = NotificatioViewModel(info: json)
            if UserDefaultsManager.shared.isUserLoggedIn{
                Global.shared.user = UserDefaultsManager.shared.userInfo
                //Global.shared.notificationObject = object
                Global.shared.isFromNotification = true
                let data = json["data"]
                let strData = data.description
                let notificationDic = Utilities.convertToDictionary(text: strData)
                let id = notificationDic?["notification_id"] as? Int ?? 0
                
                Global.shared.notificationId = id
                gotoMainController()
            }
            
            //setRoot(isfromNotifi: true , data: notificationData as? [AnyHashable : Any])
            
            
        }
        else{
            setupInitialController()
        }

        return true
    }
    
    func setupInitialController(){
        if UserDefaultsManager.shared.isUserLoggedIn{
            if let info = UserDefaultsManager.shared.userInfo{
                Global.shared.user = info
                let storyboard = UIStoryboard(name: StoryboardNames.Main, bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: ControllerIdentifier.SWRevealVC) as! BaseNavigationController
                window?.rootViewController = vc
                window?.makeKeyAndVisible()
            }
        }
    }
    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Checklist")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    //MARK: - FIREBASE PUSH NOTIFICATION METHODS
    private func getFireBaseToken(){
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            } else if let token = token {
                Global.shared.fcmToken = token
                print("**FCM registration token: \(token)")
            }
        }
    }
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        let dataDict:[String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: If necessary send token to application server.
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        // Print full message.
        print(userInfo)
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        // Print full message.
        print(userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
    }
}



// MARK: - EXTENSION PUSH NOTIFICATION DELEGATE METHODS
extension AppDelegate : UNUserNotificationCenterDelegate {
    @available(iOS 10, *)
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        // Print full message.
        print(userInfo)
        // Change this to your preferred presentation option
        completionHandler([[.alert, .sound]])
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let notificationData = response.notification.request.content.userInfo
        let json = JSON(notificationData)
        print(json)
        let object = NotificatioViewModel(info: json)
                if UserDefaultsManager.shared.isUserLoggedIn{
                    Global.shared.user = UserDefaultsManager.shared.userInfo
                    //Global.shared.notificationObject = object
                    Global.shared.isFromNotification = true
                    let data = json["data"]
                    let strData = data.description
                    let notificationDic = Utilities.convertToDictionary(text: strData)
                    let id = notificationDic?["notification_id"] as? Int ?? 0
                    
                    Global.shared.notificationId = id
                    gotoMainController()
         }
        // Print message ID.
        //    if let messageID = userInfo[gcmMessageIDKey] {
        //      print("Message ID: \(messageID)")
        //    }
        completionHandler()
    }
    
    func gotoMainController() {
        let storyboard = UIStoryboard(name: StoryboardNames.Main, bundle: nil)
        let navVC = storyboard.instantiateViewController(withIdentifier: ControllerIdentifier.SWRevealVC) as! BaseNavigationController
        if #available(iOS 13.0, *){
            let sceneDelegate = UIApplication.shared.connectedScenes
                .first!.delegate as! SceneDelegate
            sceneDelegate.window!.rootViewController = navVC
        }else {
            self.window?.rootViewController = navVC
        }

    }
}
