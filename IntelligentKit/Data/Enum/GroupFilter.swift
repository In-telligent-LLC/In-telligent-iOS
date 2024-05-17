//
//  GroupFilter.swift
//  Intelligent
//
//  Created by Kurt on 10/16/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit

public enum GroupFilter: String, CaseIterable {
    case none = "none",
    people = "people",
    organizations = "organization",
    helplinesAndHotlines = "helpline",
    emergencyServices = "emergency"
    
    public var localizedString: String {
        switch self {
        case .none: return NSLocalizedString("None", comment: "")
        case .people: return NSLocalizedString("People", comment: "")
        case .organizations: return NSLocalizedString("Organizations", comment: "")
        case .helplinesAndHotlines: return NSLocalizedString("Helplines & Hotlines", comment: "")
        case .emergencyServices: return NSLocalizedString("Emergency Services", comment: "")
        }
    }
}
