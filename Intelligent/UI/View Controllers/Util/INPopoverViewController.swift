//
//  INPopoverViewController.swift
//  Intelligent
//
//  Created by Kurt Jensen on 10/5/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit

class INPopoverViewController: INViewController {

    var preferredWidth: CGFloat {
        return 200
    }
    
    var preferredHeight: CGFloat {
        return 200
    }
    
    func configurePopover(_ sourceView: UIView? = nil, barButtonItem: UIBarButtonItem? = nil) {
        modalPresentationStyle = .popover
        preferredContentSize = CGSize(width: preferredWidth, height: preferredHeight)
        
        if let barButtonItem = barButtonItem {
            popoverPresentationController?.barButtonItem = barButtonItem
        } else if let sourceView = sourceView ?? view {
            popoverPresentationController?.sourceView = sourceView
            popoverPresentationController?.sourceRect = CGRect(x: sourceView.bounds.width/2, y: 0, width: 0, height: sourceView.bounds.height)
        }
        popoverPresentationController?.permittedArrowDirections = [.up, .down]
        popoverPresentationController?.canOverlapSourceViewRect = false
        popoverPresentationController?.delegate = self
    }
    
}
