//
//  AppDelegate.swift
//  Intelligent
//
//  Created by Kurt Jensen on 9/27/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit
import RealmSwift
import FBSDKCoreKit
import GoogleSignIn
import TwilioVoice
import Firebase
import CoreLocation
import IntelligentKit
import SDWebImage

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var window: UIWindow?
    private let locationManager = CLLocationManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        
        Appearance.configure()
        SDWebImageCodersManager.sharedInstance().addCoder(SDWebImageGIFCoder.shared())

        let window = UIWindow()
        let tempVC: UIViewController = {
            let vc = UIViewController()
            vc.view.backgroundColor = .white
            return vc
        }()
        window.rootViewController = tempVC
        window.makeKeyAndVisible()
        self.window = window
        
        FirebaseApp.configure()

        // request always usage here so iSoma doesn't request "while in use" automatically
        // it is also required for Factual.
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        Ads.configure(gpsEnabled: true)
        
        TwilioVoice.logLevel = .off

        // DB
        Realm.Configuration.defaultConfiguration.deleteRealmIfMigrationNeeded = true
        Logging.info(Realm.Configuration.defaultConfiguration.fileURL)
        
        INSubscriberManager.shared.start(self)
        
        //
        FBSDKApplicationDelegate.sharedInstance()?.application(application, didFinishLaunchingWithOptions: launchOptions)
        GIDSignIn.sharedInstance().clientID = Constants.Google.clientId
        
        /*
        // Ads
        AdManager.shared.start()
        AdManager.shared.delegate = self
        */
        
        return true
    }
    
    private func changeRoot(isLoggedIn: Bool) {
        let vc: UIViewController
        if isLoggedIn {
            vc = Storyboard.main.storyboard.instantiateInitialViewController()!
        } else {
            vc = Storyboard.auth.storyboard.instantiateInitialViewController()!
        }
        window?.rootViewController = vc
    }
    
    private func changeRootToResetPassword(resetCode: String?) {
        let rootNC = Storyboard.auth.storyboard.instantiateInitialViewController() as! UINavigationController
        guard let vc = Storyboard.auth.viewController(vc: AuthResetPasswordViewController.self) else { return }
        
        vc.resetCode = resetCode
        rootNC.pushViewController(vc, animated: false)
        window?.rootViewController = rootNC
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        INNotification.updateUnreadBadgeCount()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        FBSDKAppEvents.activateApp()
        
        INAudioManager.stop()
        
        if let _ = INSubscriber.current {
            API.openedApp(nil, failure: nil)
            API.updateCurrentSubscriber(nil, failure: nil)
            INGeofenceUpdater.start()
        
            NotificationCenter.default.post(name: .resetInbox, object: nil)
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        Logging.info("opening url: \(url)")
        
        if let fbHandled = FBSDKApplicationDelegate.sharedInstance()?.application(app, open: url, options: options), fbHandled == true {
            return fbHandled
        }
        
        let sourceApp = options[.sourceApplication] as? String
        if let gHandled = GIDSignIn.sharedInstance()?.handle(url, sourceApplication: sourceApp, annotation: options[.annotation]), gHandled == true {
            return gHandled
        }

        if url.host == "resetPassword" {
            changeRootToResetPassword(resetCode: url.query)
        } else if url.host == "web_subscribe",
            let buildingIdString = url.query,
            let buildingId = Int(buildingIdString) {
            let request = SubscribeBuildingRequest(buildingId: buildingId, automatic: false, inviteId: nil, optIn: true)
            API.subscribeToBuilding(request, success: nil, failure: nil)
        }
        
        return true
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        Logging.info("continueUserActivity", userActivity.webpageURL, userActivity.activityType)
        
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
            let pathComponents = userActivity.webpageURL?.pathComponents, pathComponents.count == 4 else {
                return false
        }
            
        Logging.info(pathComponents)
        
        if pathComponents[1] == "buildings" && pathComponents[2] == "web_subscribe",
            let buildingId = Int(pathComponents[3]) {
            promptSubscribe(buildingId, inviteId: nil)
            
            return true
        }
        
        if pathComponents[1] == "subscribe",
            let buildingId = Int(pathComponents[2]),
            let inviteId = Int(pathComponents[3]) {
            
            promptSubscribe(buildingId, inviteId: inviteId)
            return true
        }
        
        if pathComponents[1] == "subscribers" && pathComponents[2] == "resetPassword" {
            changeRootToResetPassword(resetCode: pathComponents[3])
            return true
        }
        
        return false
    }
    
    private func promptSubscribe(_ buildingId: Int, inviteId: Int?) {
        Logging.info("Prompting subscribe to \(buildingId) with invite id \(inviteId ?? -1)")
        
        API.getBuilding(buildingId, success: { (building) in
            self.promptSubscribe(building.name ?? "this building", buildingId: buildingId, inviteId: inviteId)
        }) { (error) in
            self.promptSubscribe("this building", buildingId: buildingId, inviteId: inviteId)
        }
    }
    
    private func promptSubscribe(_ buildingName: String, buildingId: Int, inviteId: Int?) {
        let format = NSLocalizedString("You have been invited to join %@", comment: "")
        let title = String.localizedStringWithFormat(format, buildingName)
        let message = NSLocalizedString("Are you sure you want to join?", comment: "")
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default) { (action) in
            let request = SubscribeBuildingRequest(buildingId: buildingId, automatic: false, inviteId: inviteId, optIn: true)
            API.subscribeToBuilding(request, success: nil, failure: nil)
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        guard let vc = window?.topMostViewController else { return }
        vc.present(alert, animated: true, completion: nil)
    }

}

extension AppDelegate {
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        Logging.info("AppDelegate didReceiveLocalNotification")
        guard let userInfo = notification.userInfo else { return }
        
        PushKitManager.shared.handleLocalNotification(userInfo)
    }
}

extension AppDelegate: INSubscriberManagerDelegate {
    
    func currentSubscriberDidChange(_ manager: INSubscriberManager, isLoggedIn: Bool) {
        changeRoot(isLoggedIn: isLoggedIn)
    }
    
}

// MARK: Factual
extension AppDelegate: FactualObservationGraphDelegate {

    func factualObservationGraphDidStart() {
        print("factualObservationGraphDidStart")
    }
    
    func factualObservationGraphDidStop() {
        print("factualObservationGraphDidStop")
    }
    
    func factualObservationGraphDidFailWithError(_ factualError: FactualError) {
        print("factualObservationGraphDidFailWithError \(factualError)")
    }
    
    func factualObservationGraphDidReportInfo(_ infoMessage: String) {
        print("factualObservationGraphDidReportInfo \(infoMessage)")
    }
    
    func factualObservationGraphDidLoadConfig(_ data: FactualConfigMetadata) {
        print("factualObservationGraphDidLoadConfig \(data)")
    }
    
    func factualObservationGraphDidReportDiagnosticMessage(_ diagnosticMessage: String) {
        print("factualObservationGraphDidReportDiagnosticMessage \(diagnosticMessage)")
    }
    
}

// MARK: Ads
extension AppDelegate: AdManagerDelegate {
    
    func didClickAd(_ ad: Ad) {
        guard let url = ad.url.url else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
