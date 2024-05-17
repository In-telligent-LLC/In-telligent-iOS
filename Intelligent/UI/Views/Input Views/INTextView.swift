//
//  INTextView.swift
//  Intelligent
//
//  Created by Kurt on 9/27/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit

public class INTextView: PlaceholderTextView, INInputViewDataSource {
    
    weak var inInputView: INInputView?
    
    override var placeholder: String? {
        didSet { inInputView?.manager?.inputPlaceholderLabel.text = placeholder }
    }
    
    public var isEnabled: Bool = true {
        didSet {
            alpha = isEnabled ? 1: 0.4
        }
    }
    
    public var hasError = false {
        didSet {
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
        autocorrectionType = .no
        smartDashesType = .no
        smartQuotesType = .no
        
        placeholder = NSLocalizedString(placeholder ?? "", comment: "")
    }

}
