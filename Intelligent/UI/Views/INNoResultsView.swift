//
//  INNoResultsView.swift
//  Intelligent
//
//  Created by Kurt on 2/12/19.
//  Copyright © 2019 Kurt Jensen. All rights reserved.
//

import UIKit

protocol INNoResultsViewDelegate: class {
    func noResultsViewActionTapped(_ view: INNoResultsView)
}

class INNoResultsView: UIView {
    
    weak var delegate: INNoResultsViewDelegate?
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = Color.darkGray
        return label
    }()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = Color.lightGray
        return label
    }()
    
    let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.tintColor = Color.green
        button.addTarget(self, action: #selector(actionTapped), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    internal func commonInit() {
        addStackView()
    }
    
    private func addStackView() {
        let stackView = UIStackView(arrangedSubviews: [imageView, titleLabel, infoLabel, actionButton])
        stackView.axis = .vertical
        stackView.spacing = 16
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        stackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        stackView.widthAnchor.constraint(equalToConstant: 240).isActive = true
    }
    
    func configure(image: UIImage?, title: String?, info: String?, actionTitle: String?, actionImage: UIImage?) {
        imageView.image = image
        titleLabel.text = title
        infoLabel.text = info
        actionButton.setTitle(actionTitle, for: .normal)
        actionButton.setImage(actionImage, for: .normal)
    }
    
    @objc func actionTapped() {
        delegate?.noResultsViewActionTapped(self)
    }
}

