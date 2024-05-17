//
//  INNavigationBar.swift
//  Intelligent
//
//  Created by Kurt Jensen on 10/28/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit

protocol INNavigationBarDelegate: class {
    func inNavigationBarDidTapMenuButton(_ navigationBar: INNavigationBar)
    func inNavigationBarDidTapSOSButton(_ navigationBar: INNavigationBar)
}

class INNavigationBar: UIView {
    
    weak var delegate: INNavigationBarDelegate?

    lazy var logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "logo"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var menuButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "icon_menu"), for: .normal)
        button.addTarget(self, action: #selector(menuTapped), for: .touchUpInside)
        button.tintColor = Color.darkGray
        return button
    }()
    
    lazy var sosButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "icon_sos"), for: .normal)
        button.addTarget(self, action: #selector(sosTapped), for: .touchUpInside)
        return button
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
        backgroundColor = UIColor.white
        
        addLogoImageView()
        addMenuButton()
        addSOSButton()
    }
    
    private func addLogoImageView() {
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(logoImageView)
        logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        logoImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 36).isActive = true
    }
    
    private func addMenuButton() {
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(menuButton)
        menuButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        menuButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        menuButton.heightAnchor.constraint(equalToConstant: 36).isActive = true
    }
    
    private func addSOSButton() {
        sosButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(sosButton)
        sosButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
        sosButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        sosButton.heightAnchor.constraint(equalToConstant: 36).isActive = true
    }
    
    @objc func menuTapped() {
        delegate?.inNavigationBarDidTapMenuButton(self)
    }
    
    @objc func sosTapped() {
        delegate?.inNavigationBarDidTapSOSButton(self)
    }

}
