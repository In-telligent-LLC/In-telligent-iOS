//
//  AdManager.swift
//  IntelligentKit
//
//  Created by Kurt on 4/24/19.
//  Copyright © 2019 Kurt Jensen. All rights reserved.
//

import UIKit

public protocol AdManagerDelegate: class {
    func didClickAd(_ ad: Ad)
}

public class AdManager: NSObject {
    
    public static let shared = AdManager()
    
    public weak var delegate: AdManagerDelegate?
    
    public var currentAd: Ad? {
        didSet {
            NotificationCenter.default.post(name: .updatedBannerAd, object: currentAd)
        }
    }
    
    private var timer: Timer?
    
    public func start() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true, block: { [weak self] (_) in
            self?.getNewAd()
        })
        
        getNewAd()
    }
    
    public func didClickAd(_ ad: Ad) {
        API.sendAdClick(ad.id, success: nil, failure: nil)
        delegate?.didClickAd(ad)
    }
    
    private func getNewAd() {
        API.getAd({ [weak self] (ad) in
            self?.currentAd = ad
        }) { (error) in
            // do nothng
        }
    }
}
