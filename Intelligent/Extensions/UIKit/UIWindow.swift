//
//  UIWindow.swift
//  Intelligent
//
//  Created by Kurt on 2/12/19.
//  Copyright © 2019 Kurt Jensen. All rights reserved.
//

import UIKit

extension UIWindow {
    
    var topMostViewController: UIViewController? {
        return rootViewController?.topMostViewController
    }

}
