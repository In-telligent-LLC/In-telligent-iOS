//
//  NotificationFilter.swift
//  Intelligent
//
//  Created by Kurt on 10/5/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import Foundation

public enum NotificationFilter: CaseIterable {
    case none,
    unread,
    saved
    
    public var localizedString: String {
        switch self {
        case .none: return NSLocalizedString("None", comment: "")
        case .unread: return NSLocalizedString("Unread", comment: "")
        case .saved: return NSLocalizedString("Saved", comment: "")
        }
    }
}
