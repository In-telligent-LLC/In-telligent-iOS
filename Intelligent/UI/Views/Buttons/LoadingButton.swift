//
//  INLoadingButton.swift
//  Intelligent
//
//  Created by Kurt Jensen on 9/28/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit

class INLoadingButton: INButton {
    
    struct ButtonState {
        let state: UIControl.State
        let title: String?
        let image: UIImage?
    }
    
    override var isHidden: Bool {
        didSet { _activityIndicatorConstraints.forEach({ $0.isActive = !isHidden }) }
    }
    
    private (set) var buttonStates: [ButtonState] = []
    private lazy var _activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .white)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = self.titleColor(for: .normal)
        return activityIndicator
    }()
    
    private lazy var _activityIndicatorConstraints: [NSLayoutConstraint] = []

    override internal func commonInit() {
        super.commonInit()
        
        addActivityIndicator()
    }
    
    private func addActivityIndicator() {
        let constraints = [
            _activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            _activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            _activityIndicator.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 8),
            _activityIndicator.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: 8),
            ]
        _activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(_activityIndicator)
        constraints.forEach({ $0.isActive = !isHidden })
        _activityIndicatorConstraints = constraints
    }
    
}

extension INLoadingButton: Loadable {
    func showLoading() {
        bringSubviewToFront(_activityIndicator)
        _activityIndicator.startAnimating()
        var buttonStates: [ButtonState] = []
        for state in [UIControl.State.normal] {
            let buttonState = ButtonState(state: state, title: title(for: state), image: image(for: state))
            buttonStates.append(buttonState)
            setTitle(nil, for: state)
            setImage(nil, for: state)
        }
        self.buttonStates = buttonStates
        isEnabled = false
    }
    
    func hideLoading() {
        _activityIndicator.stopAnimating()
        for buttonState in buttonStates {
            setTitle(buttonState.title, for: buttonState.state)
            setImage(buttonState.image, for: buttonState.state)
        }
        isEnabled = true
        isUserInteractionEnabled = true
    }
}
