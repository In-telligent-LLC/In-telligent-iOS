//
//  UIScrollView.swift
//  Intelligent
//
//  Created by Kurt Jensen on 10/31/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit

extension UIScrollView {
    var currentHorizontalPage: Int {
        let offsetX = contentOffset.x
        let percent = offsetX/bounds.size.width
        guard !percent.isNaN else { return 0 }
        let index = Int(round(percent))
        return index
    }
    
    var visibleRect: CGRect {
        return CGRect(origin: contentOffset, size: contentSize)
    }
}
