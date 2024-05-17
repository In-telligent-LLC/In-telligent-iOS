//
//  Age.swift
//  Intelligent
//
//  Created by Kurt on 10/4/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import Foundation

public enum Age: Int, CaseIterable {
    case eighteen = 0,
    twentyFive = 1,
    thirtyFive = 2,
    fourtyFive = 3,
    unspecified = -1
    
    public var stringValue: String {
        switch self {
        case .eighteen: return "18 - 24"
        case .twentyFive: return "25 - 34"
        case .thirtyFive: return "35 - 44"
        case .fourtyFive: return "45+"
        case .unspecified: return "Unspecified"
        }
    }
}
