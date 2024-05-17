//
//  KeyboardManager.swift
//  Intelligent
//
//  Created by Kurt Jensen on 9/28/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit

extension UIView {
    var firstResponder: UIView? {
        if (isFirstResponder) {
            return self
        }
        for subview in subviews {
            if let firstResponder = subview.firstResponder {
                return firstResponder
            }
        }
        return nil
    }
}

@objc protocol KeyboardManagerDelegate: class {
    @objc optional func keyboardWillShow(keyboardFrame: CGRect)
    @objc optional func keyboardTransitioningToShowing(keyboardFrame: CGRect)
    @objc optional func keyboardDidShow(keyboardFrame: CGRect)
    @objc optional func keyboardWillHide()
    @objc optional func keyboardTransitioningToHiding()
    @objc optional func keyboardDidHide()
}

class KeyboardManager: NSObject {
    
    weak var delegate: KeyboardManagerDelegate?
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func deregisterForKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: NSNotification?) {
        guard let userInfo = notification?.userInfo as? [String: AnyObject],
            let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        delegate?.keyboardWillShow?(keyboardFrame: keyboardFrame)
        let duration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0.25
        
        UIView.animate(withDuration: duration, animations: { [weak self] in
            self?.delegate?.keyboardTransitioningToShowing?(keyboardFrame: keyboardFrame)
            }, completion: { [weak self] (completed) in
                if completed {
                    self?.delegate?.keyboardDidShow?(keyboardFrame: keyboardFrame)
                }
        })
    }
    
    @objc private func keyboardWillHide(_ notification: NSNotification?) {
        guard let userInfo = notification?.userInfo as? [String: AnyObject] else { return }
        
        let duration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0.25
        
        delegate?.keyboardWillHide?()
        UIView.animate(withDuration: duration, animations: { [weak self] in
            self?.delegate?.keyboardTransitioningToHiding?()
            }, completion: { [weak self] (completed) in
                if completed {
                    self?.delegate?.keyboardDidHide?()
                }
        })
    }
    
}
