//
//  INTabBar.swift
//  Intelligent
//
//  Created by Kurt Jensen on 10/8/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit

class INTabBar: UIControl {
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.spacing = 0.5
        return stackView
    }()
    
    /*
    private lazy var bannerAdContainerView: BannerAdContainerView = {
        let view = BannerAdContainerView()
        return view
    }()
    */
    
    var tabBarItems: [INTabBarItem] {
        return stackView.arrangedSubviews as! [INTabBarItem]
    }
    
    var selectedIndex: Int? {
        didSet {
            for (index, item) in tabBarItems.enumerated() {
                item.isSelected = index == selectedIndex
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = UIColor(hex: "#E9E9E9")
        
        addStackView()
    }
    
    private func addStackView() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: UITabBar.height).isActive = true

        /*
        bannerAdContainerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bannerAdContainerView)
        bannerAdContainerView.topAnchor.constraint(equalTo: stackView.bottomAnchor).isActive = true
        bannerAdContainerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        bannerAdContainerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        bannerAdContainerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        */
    }
    
    func configure(with tabs: [Tab]) {
        stackView.arrangedSubviews.forEach({ $0.removeFromSuperview() })
        
        tabs.forEach({
            let item = INTabBarItem()
            item.configure(with: $0)
            item.addTarget(self, action: #selector(trTabBarItemDidSelect(_:)), for: .touchUpInside)
            stackView.addArrangedSubview(item)
        })
        
        selectedIndex = 0
    }
    
    @objc func trTabBarItemDidSelect(_ item: INTabBarItem) {
        selectedIndex = tabBarItems.index(of: item)
        
        sendActions(for: .valueChanged)
    }

}

extension UITabBar {
    
    static let height: CGFloat = 56
    
    // Make UITabBar taller
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        guard let window = UIApplication.shared.keyWindow else {
            return super.sizeThatFits(size)
        }
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = window.safeAreaInsets.bottom + UITabBar.height //+ BannerAdContainerView.size.height
        return sizeThatFits
    }
    
}
