//
//  ToggleHeaderView.swift
//  Intelligent
//
//  Created by Kurt on 10/17/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit

protocol ToggleHeaderViewDelegate: class {
    func toggleHeaderViewDidToggle(_ view: ToggleHeaderView, isShowing: Bool)
}

class ToggleHeaderView: UIView {

    weak var delegate: (UIViewController & ToggleHeaderViewDelegate)?
        
    var title: String? {
        get { return toggleButton.title(for: .normal) }
        set { toggleButton.setTitle(newValue, for: .normal) }
    }
    
    var isShowing: Bool {
        return toggleButton.isToggling
    }
    
    lazy var toggleButton: INToggleDropdownButton = {
        let button = INToggleDropdownButton(type: .system)
        button.titleLabel?.font = UIFont.boldItalicSystemFont(ofSize: 13)
        button.addTarget(self, action: #selector(toggleChanged), for: .valueChanged)
        return button
    }()
    
    override var tintColor: UIColor! {
        didSet {
            toggleButton.tintColor = tintColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    private func commonInit() {
        addToggleButton()
    }
    
    private func addToggleButton() {
        toggleButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(toggleButton)
        toggleButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        toggleButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
    }
    
    @objc func toggleChanged() {
        delegate?.toggleHeaderViewDidToggle(self, isShowing: isShowing)
    }

}
