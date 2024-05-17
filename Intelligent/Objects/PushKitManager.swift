//
//  PushKitManager.swift
//  Intelligent
//
//  Created by Kurt Jensen on 12/6/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import Foundation
import PushKit
import SwiftyJSON
import IntelligentKit
import UserNotifications

class PushKitManager: NSObject {
    
    private let pushRegistry: PKPushRegistry = PKPushRegistry(queue: DispatchQueue.main)
    static let shared = PushKitManager()
    
    private var token: String? { // this is necessary in event user logs out and logs in as another user, we need to associate previously updated token with this newly logged in user
        didSet {
            registerToken()
        }
    }
    
    override init() {
        super.init()
        
        pushRegistry.delegate = self
        pushRegistry.desiredPushTypes = [PKPushType.voIP]
        
        NotificationCenter.default.addObserver(self, selector: #selector(registerToken), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    func registerForPush() {
        let options: UNAuthorizationOptions = [.badge, .alert, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { (authorized, error) in
            DispatchQueue.main.async {
                if authorized {
                }
            }
        }
        
        UIApplication.shared.registerForRemoteNotifications()
        
        registerToken() // this is necessary in event user logs out and logs in as another user, we need to associate previously updated token with this newly logged in user
    }
    
    func handleLocalNotification(_ userInfo: [AnyHashable: Any]) {
        let payload = JSON(userInfo)
        debugPrint("Handle local notification \(payload)")
        
        guard let action = payload["action"].string else {
            return
        }
        
        switch action {
        case "PushNotification":
            NotificationCenter.default.post(name: Foundation.Notification.Name.receivedPushNotification, object: nil, userInfo: userInfo)
        case "AutomaticAlert":
            NotificationCenter.default.post(name: Foundation.Notification.Name.receivedAutomaticAlert, object: nil, userInfo: userInfo)
        default:
            break
        }
    }
    
}

extension PushKitManager: PKPushRegistryDelegate {
    
    func pushRegistry(_ registry: PKPushRegistry, didUpdate credentials: PKPushCredentials, for type: PKPushType) {
        debugPrint("pushRegistry didUpdate \(credentials) for \(type)")
        
        var token: String = ""
        for i in 0 ..< credentials.token.count {
            token += String(format: "%02.2hhx", credentials.token[i] as CVarArg)
        }
        
        self.token = token
    }
    
    func pushRegistry(_ registry: PKPushRegistry, didInvalidatePushTokenFor type: PKPushType) {
        debugPrint("pushRegistry didInvalidatePushTokenFor \(type)")
    }
    
    @objc private func registerToken() {
        guard let token = token else { return }
        
        OpenAPI.reportPushKitToken(token: token)
    }
    
    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith rawPayload: PKPushPayload, for type: PKPushType) {
        debugPrint("received push notification \(rawPayload.dictionaryPayload)")
        
        OpenAPI.relayPushKitNotification(dictionaryPayload: rawPayload.dictionaryPayload)
    }
}
