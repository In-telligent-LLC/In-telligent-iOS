//
//  OtherGroupViewController.swift
//  Intelligent
//
//  Created by Kurt Jensen on 11/20/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit
import IntelligentKit

class OtherGroupViewController: BaseGroupViewController {

    @IBOutlet weak var messageFeedButton: UIButton!
    @IBOutlet weak var actionButton: INLoadingButton!
    
    override var loadableViews: [UIView] {
        return [
            actionButton
        ]
    }

}
