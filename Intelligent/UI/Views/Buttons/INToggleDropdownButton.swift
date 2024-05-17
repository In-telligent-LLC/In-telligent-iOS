//
//  INToggleDropdownButton.swift
//  Intelligent
//
//  Created by Kurt Jensen on 10/19/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit

class INToggleDropdownButton: INDropdownButton {

    private (set)var isToggling = false { didSet { setupToggle(true) } }

    override func commonInit() {
        super.commonInit()
        
        setupToggle()
        addTarget(self, action: #selector(toggleTapped), for: .touchUpInside)
    }
    
    private func setupToggle(_ animated: Bool = false) {
        let transform = isToggling ? CGAffineTransform.identity.rotated(by: CGFloat.pi): CGAffineTransform.identity
        UIView.animate(withDuration: animated ? 0.2: 0) { [weak self] in
            self?.dropdownImageView.transform = transform
        }
    }
    
    @objc func toggleTapped() {
        isToggling = !isToggling
        setupToggle(true)
        sendActions(for: .valueChanged)
    }
    
}
