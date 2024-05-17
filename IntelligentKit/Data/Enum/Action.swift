//
//  Action.swift
//  Intelligent
//
//  Created by Kurt Jensen on 11/23/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import Foundation

public enum Action: CaseIterable {
    case connect, disconnect
    
    public var localizedString: String {
        switch self {
        case .connect: return NSLocalizedString("CONNECT", comment: "")
        case .disconnect: return NSLocalizedString("DISCONNECT", comment: "")
        }
    }
}
