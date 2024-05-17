//
//  Tab.swift
//  Intelligent
//
//  Created by Kurt on 11/23/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit

public enum Tab: CaseIterable {
    case groups, contact, inbox
    
    var image: UIImage? {
        switch self {
        case .groups: return UIImage(named: "icon_tab_groups")
        case .contact: return UIImage(named: "icon_tab_contact")
        case .inbox: return UIImage(named: "icon_tab_inbox")
        }
    }
    
    var localizedString: String {
        switch self {
        case .groups: return NSLocalizedString("Groups", comment: "")
        case .contact: return NSLocalizedString("Contact", comment: "")
        case .inbox: return NSLocalizedString("Inbox", comment: "")
        }
    }
}
