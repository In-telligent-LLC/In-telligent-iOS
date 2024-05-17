//
//  GroupFilterView.swift
//  Intelligent
//
//  Created by Kurt on 10/16/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit
import IntelligentKit

protocol GroupFilterViewDelegate: class {
    func didChangeFilter(_ view: GroupFilterView, filter: GroupFilter)
}

class GroupFilterView: UIView {
    
    weak var delegate: (UIViewController & GroupFilterViewDelegate)?
    
    lazy var filterButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = tintColor
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        button.setImage(UIImage(named: "icon_eye"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        button.addTarget(self, action: #selector(changeFilterTapped), for: .touchUpInside)
        return button
    }()
    
    override var tintColor: UIColor! {
        didSet {
            filterButton.tintColor = tintColor
        }
    }
    
    private (set)var filter: GroupFilter = .none {
        didSet {
            setupFilterButton()
            delegate?.didChangeFilter(self, filter: filter)
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
        addFilterButton()
        setupFilterButton()
    }
    
    private func setupFilterButton() {
        filterButton.setTitle("\(NSLocalizedString("FILTER", comment: "")): \(filter.localizedString.uppercased())", for: .normal)
    }
    
    private func addFilterButton() {
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(filterButton)
        filterButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
        filterButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
    }
    
    @objc func changeFilterTapped() {
        let vc = SelectGroupFilterViewController.vc(filter: filter)
        vc.delegate = self
        vc.configurePopover(filterButton)
        delegate?.present(vc, animated: true, completion: nil)
    }
    
}

extension GroupFilterView: SelectGroupFilterViewControllerDelegate {
    func selectGroupFilterViewControllerDidSelect(_ vc: SelectGroupFilterViewController, filter: GroupFilter) {
        vc.dismiss(animated: true, completion: nil)
        self.filter = filter
    }
}
