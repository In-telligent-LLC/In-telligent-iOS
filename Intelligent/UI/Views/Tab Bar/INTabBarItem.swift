//
//  INTabBarItem.swift
//  Intelligent
//
//  Created by Kurt Jensen on 10/8/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit

class INTabBarItem: UIControl {

    override var isSelected: Bool { didSet { setupView() } }
    override var isHighlighted: Bool { didSet { setupView() } }
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageView, titleLabel])
        stackView.axis = .vertical
        stackView.spacing = 2
        return stackView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .center
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        return imageView
    }()
    
    lazy var backgroundView: RadialGradientView = {
        let view = RadialGradientView()
        view.colors = [UIColor.white, UIColor(hex: "#EAEAEA")]
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        commonInit()
    }
    
    private func commonInit() {
        addBackgroundView()
        addStackView()
        backgroundColor = .white
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        addGestureRecognizer(tapGesture)
    }
    
    private func addBackgroundView() {
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backgroundView)
        backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        backgroundView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    private func addStackView() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: topAnchor, constant: 6).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    private func setupView() {
        backgroundView.isHidden = !(isSelected || isHighlighted)
        titleLabel.textColor = (isSelected || isHighlighted) ? Color.green: UIColor(hex: "#929292")
        imageView.tintColor = (isSelected || isHighlighted) ? Color.green: UIColor(hex: "#929292")
    }
    
    func configure(with tab: Tab) {
        imageView.image = tab.image?.withRenderingMode(.alwaysTemplate)
        titleLabel.text = tab.localizedString
    }
    
    @objc func viewTapped(_ sender: UITapGestureRecognizer) {
        switch sender.state {
        case .ended:
            sendActions(for: .touchUpInside)
        default:
            break
        }
    }
    
}
