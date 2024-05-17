//
//  TimeInterval.swift
//  Intelligent
//
//  Created by Kurt on 11/13/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import Foundation

extension TimeInterval {
    
    var HHMMSSvalue: String {
        var components = DateComponents()
        components.second = Int(max(0, self))
        
        return DateComponentsFormatter.HHMMSSFormatter.string(from: self) ?? "\(Int(self))"
    }
    
    var MMSSvalue: String {
        var components = DateComponents()
        components.second = Int(max(0, self))
        
        return DateComponentsFormatter.MMSSFormatter.string(from: self) ?? "\(Int(self))"
    }

}
