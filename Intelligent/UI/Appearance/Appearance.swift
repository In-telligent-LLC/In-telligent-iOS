//
//  Appearance.swift
//  Intelligent
//
//  Created by Kurt Jensen on 10/5/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit

class Appearance {
    
    class func configure() {
        UITextField.appearance().tintColor = Color.green
        UITextView.appearance().tintColor = Color.green
        UIBarButtonItem.appearance().tintColor = Color.green
        
        UISegmentedControl.appearance().tintColor = Color.green

        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().barTintColor = UIColor.white
        
        UITabBar.appearance().isOpaque = true
        UITabBar.appearance().barTintColor = UIColor.white

        UITableView.appearance().tintColor = Color.green
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
        UITableView.appearance().separatorColor = .clear
        UITableView.appearance().separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    }

}
