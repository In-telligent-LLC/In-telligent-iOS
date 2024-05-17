//
//  PlaceholderTextView.swift
//  Intelligent
//
//  Created by Kurt on 9/27/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit

@IBDesignable
public class PlaceholderTextView: UITextView {
    
    lazy var leftConstraint: NSLayoutConstraint = {
        return placeholderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0)
    }()
    
    lazy var topConstraint: NSLayoutConstraint = {
        return placeholderLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0)
    }()
    
    lazy var widthConstraint: NSLayoutConstraint = {
        return placeholderLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: 0)
    }()
    
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.backgroundColor = UIColor.clear
        label.textColor = placeholderFontColor
        label.text = placeholder
        label.font = font
        return label
    }()
    
    @IBInspectable
    var sideInset: CGFloat = .greatestFiniteMagnitude { didSet { setupInsets() } }
    
    @IBInspectable
    var topInset: CGFloat = .greatestFiniteMagnitude { didSet { setupInsets() } }
    
    @IBInspectable
    var placeholderFontColor: UIColor = UIColor(hex: "#C7C7CD") {
        didSet {
            placeholderLabel.textColor = placeholderFontColor
        }
    }
    
    @IBInspectable
    var placeholder: String? {
        didSet {
            placeholderLabel.text = placeholder
        }
    }
    
    override public var text: String! {
        didSet {
            textDidChange()
        }
    }
    
    override public var attributedText: NSAttributedString! {
        didSet {
            textDidChange()
        }
    }
    
    override public var textContainerInset: UIEdgeInsets {
        didSet {
            updateConstraintsForPlaceholderLabel()
        }
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textDidChange),
                                               name: UITextView.textDidChangeNotification,
                                               object: nil)
        addPlaceholderLabel()
        setupInsets()
    }
    
    private func addPlaceholderLabel() {
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(placeholderLabel)
        updateConstraintsForPlaceholderLabel()
    }
    
    private func updateConstraintsForPlaceholderLabel() {
        leftConstraint.constant = textContainerInset.left + textContainer.lineFragmentPadding
        leftConstraint.isActive = true
        topConstraint.constant = textContainerInset.top
        topConstraint.isActive = true
        widthConstraint.constant = -(textContainerInset.left + textContainerInset.right + textContainer.lineFragmentPadding * 2.0)
        widthConstraint.isActive = true
    }
    
    private func setupInsets() {
        guard sideInset != .greatestFiniteMagnitude, topInset != .greatestFiniteMagnitude else { return }
        textContainerInset = UIEdgeInsets(top: topInset, left: sideInset, bottom: 0, right: 0)
    }
    
    @objc fileprivate func textDidChange() {
        placeholderLabel.isHidden = !text.isEmpty
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        placeholderLabel.preferredMaxLayoutWidth = textContainer.size.width - textContainer.lineFragmentPadding * 2.0
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: UITextView.textDidChangeNotification,
                                                  object: nil)
    }
    
}

