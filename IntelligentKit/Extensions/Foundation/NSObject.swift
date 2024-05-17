//
//  NSObject.swift
//  Intelligent
//
//  Created by Kurt Jensen on 9/27/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import Foundation

extension NSObject {
    public var className: String {
        return NSStringFromClass(type(of: self)).components(separatedBy: ".").last!
    }
    public class var className: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
}
