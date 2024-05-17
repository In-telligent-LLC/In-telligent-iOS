//
//  UITableView.swift
//  Intelligent
//
//  Created by Kurt on 10/4/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit

extension UITableView {

    func registerNib<T: UITableViewCell>(cell: T.Type) {
        register(UINib(nibName: cell.className, bundle: Bundle(for: T.self)), forCellReuseIdentifier: cell.className)
    }
    
    func register<T: UITableViewCell>(cell: T.Type) {
        register(cell.self, forCellReuseIdentifier: cell.className)
    }
    
    func dequeue<T: UITableViewCell>(cell: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: cell.className, for: indexPath) as! T
    }
    
    func updateWithoutAnimation(_ updates: () -> ()) {
        let lastScrollOffset = contentOffset
        beginUpdates()
        updates()
        endUpdates()
        layer.removeAllAnimations()
        setContentOffset(lastScrollOffset, animated: false)
    }
}
