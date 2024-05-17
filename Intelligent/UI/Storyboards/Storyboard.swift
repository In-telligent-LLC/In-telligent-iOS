//
//  Storyboard.swift
//  Intelligent
//
//  Created by Kurt Jensen on 9/27/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit

enum Storyboard: String {
    case auth = "Auth",
    main = "Main",
    contact = "Contact",
    groups = "Groups",
    inbox = "Inbox",
    sideMenu = "SideMenu",
    notification = "Notification"

    var storyboard: UIStoryboard {
        return UIStoryboard(name: rawValue, bundle: nil)
    }
    
    func viewController<T: UIViewController>(vc: T.Type) -> T? {
        return storyboard.instantiateViewController(withIdentifier: vc.className) as? T
    }
}
