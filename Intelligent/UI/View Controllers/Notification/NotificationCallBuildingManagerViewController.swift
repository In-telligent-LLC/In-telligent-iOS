//
//  NotificationCallBuildingManagerViewController.swift
//  Intelligent
//
//  Created by Kurt Jensen on 11/9/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit
import IntelligentKit

class NotificationCallBuildingManagerViewController: NotificationPopupBaseViewController {
    
    @IBOutlet weak var callButton: INButton!

    override func setupView() {
        super.setupView()
        
        titleLabel?.text = NSLocalizedString("Would you like to call your community manager?", comment: "")
        
        callButton.title = NSLocalizedString("CALL COMMUNITY MANAGER", comment: "")
        cancelButton.title = NSLocalizedString("OK", comment: "")
    }
    
    @IBAction func callBuildingManagerTapped() {
        dismiss(animated: true) {
            self.delegate?.notificationPopupViewControllerDidTapCallCommunityManager(self.notification)
        }
    }
}
