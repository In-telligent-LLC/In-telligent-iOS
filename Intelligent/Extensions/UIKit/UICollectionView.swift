//
//  UICollectionView.swift
//  Intelligent
//
//  Created by Kurt on 10/4/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    func registerNib<T: UICollectionViewCell>(cell: T.Type) {
        register(UINib(nibName: cell.className, bundle: Bundle(for: T.self)), forCellWithReuseIdentifier: cell.className)
    }
    
    func register<T: UICollectionViewCell>(cell: T.Type) {
        register(cell.self, forCellWithReuseIdentifier: cell.className)
    }
    
    func dequeue<T: UICollectionViewCell>(cell: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: cell.className, for: indexPath) as! T
    }
    
}

