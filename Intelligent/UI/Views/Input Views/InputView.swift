//
//  InputView.swift
//  Intelligent
//
//  Created by Kurt Jensen on 11/23/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit

protocol INInputViewDataSource {
    var inInputView: INInputView? { get set }
}

@objc
protocol INInputViewDelegate: class {
    @objc var inInputViews: [INInputView] { get }
    @objc optional func inputDoneEditing(_ input: INInputView)
    @objc optional func inputValueChanged(_ input: INInputView, value: Any)
}

class INInputView: UIStackView {
    
    @IBInspectable
    var addAccessoryView: Bool = true {
        didSet {
            textField?.inputAccessoryView = addAccessoryView ? manager?.toolbar : nil
        }
    }
    
    var delegate: INInputViewDelegate? { didSet { manager?.updateEnability() }}
    private (set)var manager: INInputViewManager?
    
    @discardableResult
    override func becomeFirstResponder() -> Bool {
        let beginEditingTF = textField?.becomeFirstResponder() ?? false
        let beginEditingTV = textView?.becomeFirstResponder() ?? false
        return beginEditingTF || beginEditingTV
    }
    
    @discardableResult
    override func resignFirstResponder() -> Bool {
        let endEditingTF = textField?.resignFirstResponder() ?? false
        let endEditingTV = textView?.resignFirstResponder() ?? false
        return endEditingTF || endEditingTV
    }
    
    var textField: INTextField? {
        return arrangedSubviews.first(where: { return $0 is INTextField }) as? INTextField
    }
    
    var textView: INTextView? {
        return arrangedSubviews.first(where: { return $0 is INTextView }) as? INTextView
    }
    
    var errorLabel: UILabel? {
        return arrangedSubviews.last(where: { return $0 is UILabel }) as? UILabel
    }
    
    var stringValue: String? {
        return textField?.text ?? textView?.text
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        
        commonInit()
    }
    
    private func commonInit() {
        manager = INInputViewManager(view: self, configurePlaceholderLabel: { (label) in
            //
        })
        manager?.delegate = self
        if addAccessoryView {
            textField?.inputAccessoryView = manager?.toolbar
            textView?.inputAccessoryView = manager?.toolbar
        }
        textField?.delegate = manager
        textView?.delegate = manager

        textField?.inInputView = self
        textView?.inInputView = self

        errorLabel?.text = NSLocalizedString("This field is required.", comment: "")
    }
    
}

extension INInputView: INInputManagerDelegate {
    func inputs() -> [INInputView] {
        return delegate?.inInputViews ?? []
    }
    
    func inputDoneEditing(_ input: INInputView) {
        delegate?.inputDoneEditing?(input)
    }
    
    func inputDidBeginEditing(_ input: INInputView) {
    }
    
    func inputDidEndEditing(_ input: INInputView) {
    }
    
    func inputValueChanged(_ input: INInputView, value: Any) {
        delegate?.inputValueChanged?(input, value: value)
    }
}
