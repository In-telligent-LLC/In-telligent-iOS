//
//  UIApplication.swift
//  Intelligent
//
//  Created by Kurt on 10/4/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit

extension UIApplication {
    var build: String {
        return Bundle.main.infoDictionary?[kCFBundleVersionKey as String] as? String ?? ""
    }
}
