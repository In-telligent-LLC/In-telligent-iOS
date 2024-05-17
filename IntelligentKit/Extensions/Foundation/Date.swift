//
//  Date.swift
//  Intelligent
//
//  Created by Kurt Jensen on 10/5/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit

extension Date {
    
    func formatted(with formatter: DateFormatter) -> String? {
        return formatter.string(from: self)
    }
    
    func formatted(with isoFormatter: ISO8601DateFormatter) -> String? {
        return isoFormatter.string(from: self)
    }

}
