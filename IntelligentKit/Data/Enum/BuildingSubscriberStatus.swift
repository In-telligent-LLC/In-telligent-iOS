//
//  BuildingSubscriberStatus.swift
//  Intelligent
//
//  Created by Kurt Jensen on 11/2/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit

public enum BuildingSubscriberStatus: String {
    case none = "none",
    accepted = "accepted",
    pending = "pending"
    
    public var localizedString: String {
        switch self {
        case .none: return NSLocalizedString("None", comment: "")
        case .accepted: return NSLocalizedString("Accepted", comment: "")
        case .pending: return NSLocalizedString("Pending...", comment: "")
        }
    }
}
