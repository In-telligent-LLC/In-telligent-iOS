//
//  BannerAdContainerView.swift
//  Intelligent
//
//  Created by Kurt on 4/24/19.
//  Copyright © 2019 Kurt Jensen. All rights reserved.
//

import UIKit
import IntelligentKit

class BannerAdContainerView: UIView {
    
    static let size: CGSize = CGSize(width: 320, height: 50)
    
    public var ad: Ad? {
        didSet {
            let adImageURL = ad?.imageURL.url
            adImageView.sd_setImage(with: adImageURL, completed: nil)
        }
    }

    private let adImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
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
        addAdImageViewView()
        updateAd()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(adImageViewTapped(_:)))
        addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(forName: .updatedBannerAd, object: nil, queue: .main) { [weak self] (_) in
            self?.updateAd()
        }
    }

    private func addAdImageViewView() {
        adImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(adImageView)
        adImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        adImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        adImageView.widthAnchor.constraint(equalToConstant: BannerAdContainerView.size.width).isActive = true
        adImageView.heightAnchor.constraint(equalToConstant: BannerAdContainerView.size.height).isActive = true
    }
    
    private func updateAd() {
        ad = AdManager.shared.currentAd
    }
    
    @objc func adImageViewTapped(_ sender: UITapGestureRecognizer) {
        switch sender.state {
        case .ended:
            if let ad = ad {
                AdManager.shared.didClickAd(ad)
            }
        default:
            break
        }
    }
}
