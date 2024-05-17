//
//  INPushManager.swift
//  Intelligent
//
//  Created by Kurt Jensen on 11/6/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import Foundation
import PushKit
import SwiftyJSON

public class INPushManager: NSObject {
    
    static let shared = INPushManager()
    
    func handlePush(_ rawPayload: [AnyHashable: Any]) {
        Logging.info("received push notification \(rawPayload)")
        
        var payload = JSON(rawPayload)
        
        if let incrementBadge = payload["increment_badge"].int {
            UIApplication.shared.applicationIconBadgeNumber += incrementBadge
        } else if let badge = payload["aps"]["badge"].int {
            UIApplication.shared.applicationIconBadgeNumber = badge
        }
        
        payload["active"].boolValue = UIApplication.shared.applicationState == .active
        
        let action = payload["action"].stringValue
        Logging.info(action)
        
        switch action {
        case "LocationPing":
            guard let uuid = payload["uuid"].string else {
                return Logging.info("LocationPing with invalid payload \(payload)")
            }
            
            INLocationManager.ping(uuid: uuid)
        case "IncomingCall":
            guard //let conferenceId = payload["conferenceId"].string,
                //let remoteUserName = payload["remoteUserName"].string,
                let uuid = UUID(uuidString: payload["uuid"].stringValue) else {
                    return Logging.info("Incoming call with invalid payload \(payload)")
            }
            
            INCallManager.acceptCall(uuid, success: { (call) in
                // TODO
            }) { (error) in
                Logging.info(error)
            }
        case "WeatherAlert":
            
            guard let feedAlertId = payload["feedAlertId"].int else {
                //let uuid = payload["uuid"].string else {
                return Logging.info("NewWeatherAlert with invalid payload \(payload)")
            }
            
            INLocationManager.pingFeedAlert(feedAlertId: feedAlertId)
        default:
            payload["action"].string = "PushNotification"
            handlePushNotification(payload)
        }
    }
    
    private func handlePushNotification(_ payload: JSON) {
        guard payload["type"].string == "alert",
            let id = payload["id"].string else {
                Logging.info("Invalid alert payload \(payload)")
                return
        }
        
        API.markDelivered(id, success: nil, failure: nil)
        
        let alertType = NotificationType(rawValue: payload["alertType"].stringValue) ?? .normal
        Logging.info("Handle push notification \(alertType)")

        switch alertType {
        case .lifeSafety,
             .critical,
             .ping,
             .pcEmergency,
             .pcUrgent:
            handleMaxSoundAlert(payload, audio: alertType.audio ?? .ping)
        case .weather:
            let hour = Calendar.current.component(.hour, from: Date())
            let isWeatherEnabled = INSubscriber.current?.isWeatherEnabled ?? true
            let silent = !isWeatherEnabled || hour < 7 || hour > 22
            handleMaxSoundAlert(payload, audio: .weather, silent: silent)
        case .lightningAlert:
            let isLightningEnabled = INSubscriber.current?.isLightningEnabled ?? true
            handleMaxSoundAlert(payload, audio: .weather, silent: !isLightningEnabled)
        case .personalSafety,
             .normal,
             .suggested,
             .response:
            handleDefaultAlert(payload)
        }
    }
    
    private func handleDefaultAlert(_ payload: JSON, soundName: String? = nil) {
        let notification = UILocalNotification()
        notification.alertBody = payload["title"].string
        notification.userInfo = payload.dictionaryObject
        notification.soundName = soundName ?? UILocalNotificationDefaultSoundName
        UIApplication.shared.scheduleLocalNotification(notification)
    }
    
    private func handleMaxSoundAlert(_ payload: JSON, audio: Audio, silent: Bool = false) {
        let date = Settings.silenceExpirationDate
        if !silent && (date == nil || date! < Date()) {
            INAudioManager.setMaxVolume()
            INAudioManager.play(audio) { (success) in
                let soundName = !success ? INAudioManager.fileURL(for: audio)?.lastPathComponent : nil
                self.handleDefaultAlert(payload, soundName: soundName)
            }
        } else {
            handleDefaultAlert(payload)
        }
    }
}
