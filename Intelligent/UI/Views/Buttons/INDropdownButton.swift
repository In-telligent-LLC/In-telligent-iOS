//
//  INDropdownButton.swift
//  Intelligent
//
//  Created by Kurt on 10/11/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit

class INDropdownButton: INButton {

    public lazy var dropdownImageView: IconImageView = {
        let imageView = IconImageView(image: UIImage(named: "icon_arrow_dropdown"))
        imageView.tintColor = tintColor
        return imageView
    }()
    
    override var tintColor: UIColor! {
        didSet {
            dropdownImageView.tintColor = tintColor
        }
    }
    
    override func commonInit() {
        super.commonInit()
        
        contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 24)
        
        addDropdownImageView()
    }
    
    private func addDropdownImageView() {
        dropdownImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(dropdownImageView)
        dropdownImageView.heightAnchor.constraint(equalToConstant: 12).isActive = true
        dropdownImageView.widthAnchor.constraint(equalTo: dropdownImageView.heightAnchor).isActive = true
        dropdownImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        dropdownImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
}
