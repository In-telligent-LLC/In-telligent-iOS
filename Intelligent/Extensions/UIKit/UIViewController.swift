//
//  UIViewController.swift
//  Intelligent
//
//  Created by Kurt on 9/28/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit
import SafariServices

extension UIViewController {
    
    func showAlert(_ title: String?, message: String?, okTitle: String = NSLocalizedString("OK", comment: ""), completion: (()  -> ())? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: okTitle, style: .cancel) { (action) in
            completion?()
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }

    func showError(_ error: Error?, okTitle: String = NSLocalizedString("OK", comment: ""), completion: (()  -> ())? = nil) {
        showErrorMessage(error?.localizedDescription, okTitle: okTitle, completion: completion)
    }
    
    func showErrorMessage(_ message: String?, okTitle: String = NSLocalizedString("OK", comment: ""), completion: (()  -> ())? = nil) {
        let m = message ?? NSLocalizedString("An unknown error occurred. Please contact support if the issue persists", comment: "")
        let title = NSLocalizedString("Error", comment: "")
        showAlert(title, message: m, okTitle: okTitle, completion: completion)
    }
    
    func showURL(_ url: URL) {
        if url.scheme == "http" || url.scheme == "https" {
            let svc = SFSafariViewController(url: url)
            present(svc, animated: true, completion: nil)
        } else {
            if #available(iOS 10.0, *) {
                let _ = UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                let _ = UIApplication.shared.openURL(url)
            }
        }
    }
    
}

extension UIViewController: UIPopoverPresentationControllerDelegate {
    
    public func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
}

extension UIViewController {
    
    var topMostViewController: UIViewController? {
        if let nc = self as? UINavigationController {
            return nc.visibleViewController?.topMostViewController
        } else if let tbc = self as? UITabBarController {
            return tbc.selectedViewController?.topMostViewController
        } else {
            if let vc = presentedViewController {
                return vc.topMostViewController
            } else {
                return self
            }
        }
    }
    
}
