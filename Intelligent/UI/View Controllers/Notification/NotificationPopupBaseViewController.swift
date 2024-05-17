//
//  NotificationPopupViewController.swift
//  Intelligent
//
//  Created by Kurt Jensen on 11/9/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit
import IntelligentKit

protocol NotificationPopupViewControllerDelegate: class {
    func notificationPopupViewControllerDidTapCallCommunityManager(_ notification: INNotification)
}

class NotificationPopupBaseViewController: INViewController {

    @IBOutlet weak var cancelButton: INButton!
    @IBOutlet weak var messageTextView: UITextView?

    var notification: INNotification!
    weak var delegate: NotificationPopupViewControllerDelegate?
    
    override func setupView() {
        super.setupView()
        
        cancelButton.title = NSLocalizedString("OK", comment: "")
        
        let title = NSAttributedString(string: notification.title, attributes: [.font: UIFont.boldSystemFont(ofSize: 20)])
        let message = NSAttributedString(string: notification.message, attributes: [.font: UIFont.systemFont(ofSize: 15)])
        
        let text = NSMutableAttributedString(attributedString: title)
        text.append(NSAttributedString(string: "\n\n"))
        text.append(message)
        messageTextView?.attributedText = text
    }

    @IBAction func closeTapped() {
        API.markOpened(notification, success: nil, failure: nil)
        dismiss(animated: true, completion: nil)
    }

}
