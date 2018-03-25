//
//  AppDelegate.swift
//  HotelCrete
//
//  Created by John Nik on 14/02/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import UIKit
import SideMenuController
import SVProgressHUD
import IQKeyboardManager
import OneSignal
import GoogleMaps
import GooglePlaces

@UIApplicationMain



class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var hotelInfo: Hotel.HotelInfo?
    var homeBackgroundImageUrl: String?
    
    var launchOptions: [UIApplicationLaunchOptionsKey: Any]?
    var notificationReceivedBlock: OSHandleNotificationReceivedBlock?
    var notificationOpenedBlock: OSHandleNotificationActionBlock?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        askForLocationPermission()
        
        setupStuff()
        setNavBar()
        setupGoogleAPI()
        
        self.launchOptions = launchOptions
        self.setupOneSignal(launchOptions: launchOptions)
        
        application.statusBarStyle = .lightContent
        
        setupInitialController()
        
        return true
    }
    
    
}

extension AppDelegate {
    
    fileprivate func askForLocationPermission() {
        
        let locationPermissionStatus = LocationManager.sharedInstance.userLocationStatus()
        
        if locationPermissionStatus == .authorized {
            LocationManager.sharedInstance.startTrackingUser()
        } else if locationPermissionStatus == .unknown {
            LocationManager.sharedInstance.requestUserLocation()
        } else {
            //it is denied or other so we should pull out
        }
    }
    
    fileprivate func setupGoogleAPI() {
        GMSServices.provideAPIKey("AIzaSyDqH0TijnYmkTMVjLJR49V5x5KL80KNOM8")
        GMSPlacesClient.provideAPIKey("AIzaSyDqH0TijnYmkTMVjLJR49V5x5KL80KNOM8")
    }
    
    fileprivate func setupInitialController() {
        SideMenuController.preferences.drawing.menuButtonImage = UIImage(named: AssetName.menu.rawValue)?.withRenderingMode(.alwaysOriginal)
        SideMenuController.preferences.drawing.sidePanelPosition = .underCenterPanelLeft
        SideMenuController.preferences.drawing.sidePanelWidth = SIDE_MENU_WIDTH
        SideMenuController.preferences.drawing.centerPanelShadow = true
        SideMenuController.preferences.animating.statusBarBehaviour = .horizontalPan
        SideMenuController.preferences.animating.transitionAnimator = FadeAnimator.self
        
        window = UIWindow()
        window?.makeKeyAndVisible()
        
        let sideMenuViewController = SideMenuController()
        let homeController = HomeController()
        let navController = NavigationController(rootViewController: homeController)
        let sideController = SideController()
        
        sideMenuViewController.embed(sideViewController: sideController)
        sideMenuViewController.embed(centerViewController: navController)
        
        window?.rootViewController = sideMenuViewController
    }
}

extension AppDelegate {
    
    fileprivate func setupStuff() {
        SVProgressHUD.setDefaultStyle(.light)
        SVProgressHUD.setDefaultMaskType(.gradient)
        
        ReachabilityManager.setup()
        
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().isEnableAutoToolbar = false
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true
    }
    
    @objc fileprivate func setNavBar() {
        UINavigationBar.appearance().barTintColor = StyleGuideManager.mainLightBlueBackgroundColor
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 20)]
    }
}

//MARK: setup onesignal
extension AppDelegate: OSPermissionObserver, OSSubscriptionObserver {
    fileprivate func setupOneSignal(launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        
        notificationReceivedBlock = { notification in
            
            print("Received Notification: \(notification!.payload.notificationID)")
            
            let state: UIApplicationState = UIApplication.shared.applicationState
            if state == UIApplicationState.background {
                
            } else if state == UIApplicationState.active {
                
            }
            
            
        }
        
        notificationOpenedBlock = { result in
            // This block gets called when the user reacts to a notification received
            let payload: OSNotificationPayload? = result?.notification.payload
            
            print("Message = \(payload!.body ?? "")")
            print("badge number = \(payload?.badge ?? 0)")
            print("notification sound = \(payload?.sound ?? "")")
            
            let state: UIApplicationState = UIApplication.shared.applicationState
            if state == UIApplicationState.background {
                
                if let _ = result!.notification.payload!.additionalData {
                    
                }
            } else if state == UIApplicationState.active {
                
            } else if state == UIApplicationState.inactive {
                
            }
            
            if let additionalData = result!.notification.payload!.additionalData {
                print("additionalData = \(additionalData)")
                
                
                if let actionSelected = payload?.actionButtons {
                    print("actionSelected = \(actionSelected)")
                }
                
                // DEEP LINK from action buttons
                if let actionID = result?.action.actionID {
                    
                    print("actionID = \(actionID)")
                    
                    if actionID == "id2" {
                        print("do something when button 2 is pressed")
                        
                        
                    } else if actionID == "id1" {
                        print("do something when button 1 is pressed")
                        
                    }
                }
            }
        }
        
        
        self.setupOnesignalObserver()
        
        //        let nc = NotificationCenter.default
        //        nc.addObserver(self, selector: #selector(self.setupOnesignalObserver), name: .SetupOneSignal, object: nil)
    }
    
    @objc fileprivate func setupOnesignalObserver() {
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false]
        
        // Replace '11111111-2222-3333-4444-0123456789ab' with your OneSignal App ID.
        OneSignal.initWithLaunchOptions(launchOptions,
                                        appId: "2d7b57d1-65ca-4b90-9c03-78eda9d7f389", handleNotificationReceived: notificationReceivedBlock, handleNotificationAction: notificationOpenedBlock,
                                        settings: onesignalInitSettings)
        
        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;
        
        // Add your AppDelegate as an obsserver
        OneSignal.add(self as OSPermissionObserver)
        
        OneSignal.add(self as OSSubscriptionObserver)
        
        let status: OSPermissionSubscriptionState = OneSignal.getPermissionSubscriptionState()
        let hasPrompted = status.permissionStatus.hasPrompted
        if hasPrompted == false {
            // Call when you want to prompt the user to accept push notifications.
            // Only call once and only if you set kOSSettingsKeyAutoPrompt in AppDelegate to false.
            OneSignal.promptForPushNotifications(userResponse: { accepted in
                if accepted == true {
                    print("User accepted notifications: \(accepted)")
                } else {
                    print("User accepted notificationsfalse: \(accepted)")
                }
            })
        } else {
        }
        
        
        // Sync hashed email if you have a login system or collect it.
        //   Will be used to reach the user at the most optimal time of day.
        // OneSignal.syncHashedEmail(userEmail)
        
    }
    
    // Add this new method
    func onOSPermissionChanged(_ stateChanges: OSPermissionStateChanges!) {
        
        // Example of detecting answering the permission prompt
        if stateChanges.from.status == OSNotificationPermission.notDetermined {
            if stateChanges.to.status == OSNotificationPermission.authorized {
                print("Thanks for accepting notifications!")
            } else if stateChanges.to.status == OSNotificationPermission.denied {
                print("Notifications not accepted. You can turn them on later under your iOS settings.")
            }
        }
        // prints out all properties
        print("PermissionStateChanges: \n\(stateChanges)")
    }
    func onOSSubscriptionChanged(_ stateChanges: OSSubscriptionStateChanges!) {
        if !stateChanges.from.subscribed && stateChanges.to.subscribed {
            print("Subscribed for OneSignal push notifications!")
        }
        print("SubscriptionStateChange: \n\(stateChanges)")
    }
    
}
