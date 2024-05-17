//
//  UIViewController+MFMail.swift
//  Intelligent
//
//  Created by Kurt on 11/13/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit
import MessageUI

extension UIViewController: MFMailComposeViewControllerDelegate {
    
    public func sendEmail(to email: String) {
        if MFMailComposeViewController.canSendMail() {
            let vc = MFMailComposeViewController()
            vc.mailComposeDelegate = self
            vc.setToRecipients([email])
            vc.setSubject("Feedback")
            present(vc, animated: true, completion: nil)
        } else {
            showAlert("You can contact us at", message: email)
        }
    }
    
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true) { () -> Void in
            if (result == .sent) {
                self.showAlert("Email Sent", message: nil)
            }
        }
        
    }
    
}
