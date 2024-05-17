//
//  HeaderView.swift
//  Intelligent
//
//  Created by Kurt on 10/17/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit

class HeaderView: UIView {
        
    var title: String? {
        get { return titleLabel.text }
        set { titleLabel.text = newValue }
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.italicSystemFont(ofSize: 13)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    private func commonInit() {
        addTitleLabel()
    }

    private func addTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
    }

}
