//
//  DeliverTo.swift
//  Intelligent
//
//  Created by Kurt on 11/13/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import Foundation

public enum DeliverTo: Int, CaseIterable {
    case inTelligent = 0,
        inTelligentAndImportedEmails = 1,
        inTelligentAndAllEmails = 2
    
    public var localizedString: String {
        switch self {
        case .inTelligent: return NSLocalizedString("In-telligent", comment: "")
        case .inTelligentAndImportedEmails: return NSLocalizedString("In-telligent and Imported Emails", comment: "")
        case .inTelligentAndAllEmails: return NSLocalizedString("In-telligent and All Emails", comment: "")
        }
    }
}
