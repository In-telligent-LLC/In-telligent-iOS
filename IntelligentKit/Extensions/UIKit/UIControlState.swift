//
//  UIControlState.swift
//  Intelligent
//
//  Created by Kurt Jensen on 11/4/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit

extension UIControl.State {
    
    static let all: [UIControl.State] = {
        return [.normal, .selected, .disabled, .highlighted, .focused]
    }()
    
}
