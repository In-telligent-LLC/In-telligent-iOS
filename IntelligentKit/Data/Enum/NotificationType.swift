//
//  NotificationType.swift
//  Intelligent
//
//  Created by Kurt on 10/4/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit
import Foundation

public enum NotificationType: String, CaseIterable {
    // REGULAR
    case normal = "normal",
    critical = "critical",
    ping = "ping",
    weather = "weather-alert",
    lightningAlert = "lightning-alert",
    personalSafety = "personal-safety",
    lifeSafety = "life-safety",
    suggested = "suggested",
    response = "response",
    
    // PERSONAL
    pcEmergency = "pc-emergency",
    pcUrgent = "pc-urgent"
    
    static var pcSendable: [NotificationType] {
        return [.pcEmergency, .pcUrgent]
    }
    
    static func regularSendable(canSendLSA: Bool) -> [NotificationType] {
        if canSendLSA {
            return [.normal, .personalSafety, .critical, .ping, .lifeSafety]
        } else {
            return [.normal, .personalSafety]
        }
    }
    
    public var localizedString: String {
        switch self {
        case .normal: return NSLocalizedString("Normal", comment: "")
        case .lifeSafety: return NSLocalizedString("Life Safety", comment: "")
        case .critical: return NSLocalizedString("Critical", comment: "")
        case .ping: return NSLocalizedString("Ping", comment: "")
        case .personalSafety: return NSLocalizedString("Personal Safety", comment: "")
        case .weather: return NSLocalizedString("Weather", comment: "")
        case .suggested: return NSLocalizedString("Suggested", comment: "")
        case .pcEmergency: return NSLocalizedString("PC Emergency", comment: "")
        case .pcUrgent: return NSLocalizedString("PC Urgent", comment: "")
        case .lightningAlert: return NSLocalizedString("Lightning Alert", comment: "")
        case .response: return NSLocalizedString("Response", comment: "")
        }
    }
    
    public var image: UIImage? {
        get {
            switch self {
            case .normal,
                 .suggested,
                 .personalSafety,
                 .response:
                return nil
            case .lifeSafety,
                 .critical,
                 .pcUrgent,
                 .pcEmergency:
                return UIImage(named: "icon_notification_warning")
            case .ping:
                return UIImage(named: "icon_notification_ping")
            case .weather,
                 .lightningAlert:
                return UIImage(named: "icon_notification_weather")
            }
        }
    }
    
    public var color: UIColor {
        get {
            switch self {
            case .normal,
                 .suggested,
                 .personalSafety, // TODO
                 .response: // TODO
                return UIColor(hex: "#2388C6")
            case .lifeSafety,
                 .pcEmergency: // red
                return UIColor(hex: "#E70000")
            case .critical,
                 .pcUrgent,
                 .lightningAlert:  // yellow
                return UIColor(hex: "#C7940B")
            case .ping: // light blue
                return UIColor(hex: "#EE6A00")
            case .weather: // dark blue
                return UIColor(hex: "#123952")
            }
        }
    }
    
    public var textColor: UIColor {
        get {
            switch self {
            case .lifeSafety,
                 .pcEmergency,
                 .critical,
                 .pcUrgent:
                return color
            default:
                return .black
            }
        }
    }
    
    public var audio: Audio? {
        switch self {
        case .lifeSafety:
             return .alarm
        case .critical:
             return .critical
        case .pcUrgent:
            return .urgent
        case .pcEmergency:
            return .emergency
        case .ping:
            return .ping
        case .weather:
             return .weather
        case .lightningAlert:
            return .lightning
        case .normal,
             .suggested,
             .personalSafety,
             .response:
            return nil
        }
    }
    
}
