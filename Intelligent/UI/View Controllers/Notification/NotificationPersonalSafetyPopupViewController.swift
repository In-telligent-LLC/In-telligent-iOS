//
//  NotificationPersonalSafetyPopupViewController.swift
//  Intelligent
//
//  Created by Kurt Jensen on 11/6/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit
import IntelligentKit

class NotificationPersonalSafetyPopupViewController: NotificationPopupBaseViewController {
    
    @IBOutlet weak var noButton: INButton!
    
    override func setupView() {
        super.setupView()
        
        titleLabel?.text = NSLocalizedString("Are you OK?", comment: "")
        
        cancelButton.title = NSLocalizedString("Yes", comment: "")
        noButton.title = NSLocalizedString("No", comment: "")
    }
    
    @IBAction func helpTapped() {
        API.markOpened(notification, success: nil, failure: nil)
        
        guard let vc = Storyboard.notification.viewController(vc: NotificationCallBuildingManagerViewController.self) else { return }
        
        vc.notification = notification
        vc.delegate = delegate
        navigationController?.setViewControllers([vc], animated: true)
    }
    
}
