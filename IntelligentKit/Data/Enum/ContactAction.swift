//
//  ContactAction.swift
//  Intelligent
//
//  Created by Kurt Jensen on 11/23/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import Foundation

public enum ContactAction: CaseIterable {
    case call, message, suggest
    
    public var localizedString: String {
        switch self {
        case .call: return NSLocalizedString("Call", comment: "")
        case .message: return NSLocalizedString("Message", comment: "")
        case .suggest: return NSLocalizedString("Suggest Message", comment: "")
        }
    }
}
