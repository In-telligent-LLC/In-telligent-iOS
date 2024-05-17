//
//  NotificationPersonalSafetyPopupController.swift
//  Intelligent
//
//  Created by Kurt Jensen on 11/6/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit

class NotificationPersonalSafetyPopupController: INViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    weak var delegate: NotificationPopupDelegate?
    var notification: Notification!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = notification.title
        messageLabel.text = notification.description
    }
    
    @IBAction func actionYes() {
        API.markOpened(notification, success: nil, failure: nil)
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func actionNo() {
        API.markOpened(notification, success: nil, failure: nil)
        
        guard let vc = Storyboard.alert.viewController(vc: CallBuildingManagerViewController.self) else { return }
        
        vc.notification = notification
        navigationController?.setViewControllers([vc], animated: true)
    }
    
}
