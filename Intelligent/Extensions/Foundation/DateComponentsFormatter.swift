//
//  DateComponentsFormatter.swift
//  Intelligent
//
//  Created by Kurt on 11/13/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import Foundation

extension DateComponentsFormatter {
    
    static let HHMMSSFormatter: DateComponentsFormatter = {
       let formatter = DateComponentsFormatter()
        formatter.zeroFormattingBehavior = .pad
        formatter.allowedUnits = [.hour, .minute, .second]
        return formatter
    }()
    
    static let MMSSFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.zeroFormattingBehavior = .pad
        formatter.allowedUnits = [.minute, .second]
        return formatter
    }()

}
