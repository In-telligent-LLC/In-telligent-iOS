//
//  String.swift
//  Intelligent
//
//  Created by Kurt Jensen on 9/28/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import Foundation

extension String {
    
    public var url: URL? {
        return URL(string: self)
    }
    
}
