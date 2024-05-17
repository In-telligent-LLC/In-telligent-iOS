//
//  INTextField.swift
//  Intelligent
//
//  Created by Kurt on 9/27/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit

class INTextField: UITextField, INInputViewDataSource {
    
    weak var inInputView: INInputView?

    override var isEnabled: Bool {
        didSet {
            alpha = isEnabled ? 1: 0.4
        }
    }
    
    var hasError = false {
        didSet {
        }
    }
    
    override var placeholder: String? {
        didSet { inInputView?.manager?.inputPlaceholderLabel.text = placeholder }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    internal func commonInit() {
        autocorrectionType = .no
        smartDashesType = .no
        smartQuotesType = .no
    }
    
    override func becomeFirstResponder() -> Bool {
        inInputView?.manager?.updateEnability()
        return super.becomeFirstResponder()
    }
    
    @IBInspectable
    var sideInset: CGFloat = .greatestFiniteMagnitude
    
    private var insets: UIEdgeInsets? {
        guard sideInset != .greatestFiniteMagnitude else { return nil }
        return UIEdgeInsets(top: 0, left: sideInset, bottom: 0, right: sideInset)
    }
    
    override public func editingRect(forBounds bounds: CGRect) -> CGRect {
        guard let insets = insets else { return super.editingRect(forBounds: bounds) }
        return bounds.inset(by: insets)
    }
    override public func textRect(forBounds bounds: CGRect) -> CGRect {
        guard let insets = insets else { return super.textRect(forBounds: bounds) }
        return bounds.inset(by: insets)
    }
    override public func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        guard let insets = insets else { return super.placeholderRect(forBounds: bounds) }
        return bounds.inset(by: insets)
    }
    
}
