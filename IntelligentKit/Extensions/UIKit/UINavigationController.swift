//
//  UINavigationController.swift
//  Intelligent
//
//  Created by Kurt Jensen on 9/27/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    func replace(with vc: UIViewController, animated: Bool) {
        var vcs: [UIViewController] = viewControllers
        vcs.removeLast()
        vcs.append(vc)
        setViewControllers(vcs, animated: animated)
    }
}
