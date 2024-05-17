//
//  NotificationPopup.swift
//  Intelligent
//
//  Created by Kurt Jensen on 11/6/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import Foundation
import SwiftyJSON
import IntelligentKit

protocol NotificationPopupDelegate: class {
    func presentAlert(vc: UIViewController)
    func notificationPopupDidTapView(_ notification: INNotification, isPersonalSafety: Bool)
}

class NotificationPopup: NSObject {
    
    enum NotificationPopupType: String {
        case alert = "alert",
        socialMedia = "social-media"
    }
    
    let popupType: NotificationPopupType
    let userInfo: JSON
    
    var notification: INNotification?
    
    var type: NotificationType? {
        return NotificationType(rawValue: userInfo["alert_type"].stringValue)
    }
    var isPersonalSafety: Bool {
        return type == .personalSafety
    }
    
    weak var delegate: (NotificationPopupDelegate & UIViewController)?
    
    init?(notification: Foundation.Notification, delegate: NotificationPopupDelegate & UIViewController) {
        guard let nUserInfo = notification.userInfo else { return nil }
        
        self.userInfo = JSON(nUserInfo)
        self.delegate = delegate
        
        guard let popupType = NotificationPopupType(rawValue: userInfo["type"].stringValue) else {
            Logging.info("Invalid Notification popup \(userInfo)")
            return nil
        }
        
        Logging.info("Valid Notification popup \(userInfo)")
        
        self.popupType = popupType

        super.init()
        
        getNotification()
    }
    
    private func getNotification() {
        //let buildingId = userInfo["building_id"].intValue
        let notificationId = userInfo["id"].intValue
        
        API.getInbox(0, success: { [weak self] (notifications, _) in
            guard let notification = notifications.first(where: { return $0.id == notificationId }) else { return }
            self?.didLoadNotification(notification)
        }) { (error) in
            //
        }
    }

    private func didLoadNotification(_ notification: INNotification) {
        self.notification = notification
        
        if UIApplication.shared.applicationState == .active {
            API.markOpened(notification, success: nil, failure: nil)
            handleDisplay()
        } else {
            NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        }
    }
        
    @objc func applicationDidBecomeActive() {
        NotificationCenter.default.removeObserver(self)
        if let notification = notification {
            API.markOpened(notification, success: nil, failure: nil)
            handleDisplay()
        }
    }
    
    private func handleDisplay() {
        guard let notification = notification else { return }
        
        switch popupType {
        case .alert:
            if isPersonalSafety {
                delegate?.notificationPopupDidTapView(notification, isPersonalSafety: isPersonalSafety)
            } else {
                displayAlert()
            }
        case .socialMedia:
            delegate?.notificationPopupDidTapView(notification, isPersonalSafety: isPersonalSafety)
        }
    }
    
    private func displayAlert() {
        let title = userInfo["title"].string
        let message = userInfo["body"].string
        Logging.info("DISPLAY ALERT", title, message)
    
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: { (action) in
            INAudioManager.stop()
            self.handleAlertResponse(false)
        }))
        alert.addAction(UIAlertAction(title: "View", style: .default, handler: { (action) in
            INAudioManager.stop()
            self.handleAlertResponse(true)
        }))
        delegate?.presentAlert(vc: alert)
    }
    
    private func handleAlertResponse(_ view: Bool) {
        guard let notification = notification else { return }
        
        if isPersonalSafety {
            API.markPersonalSafetyResponse(notification, viewed: view, success: nil, failure: nil)
        }
        if view {
            delegate?.notificationPopupDidTapView(notification, isPersonalSafety: isPersonalSafety)
        }
    }
}
