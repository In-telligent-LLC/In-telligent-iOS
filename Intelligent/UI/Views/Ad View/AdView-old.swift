//
//  AdView.swift
//  Intelligent
//
//  Created by Kurt Jensen on 9/28/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit
import AdSupport
import iSoma

class AdView: UIView {
    
    private var smaatoAdView: SOMAAdView?
    private var nuiAdView: NUIAdView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    private func commonInit() {
        loadAds()
    }
    
    private func loadAds() {
        loadSmaatoAd()
    }
    
    private func loadSmaatoAd() {
        Logging.info("Loading Smaato ad.")

        let adView = SOMAAdView(frame: bounds)
        adView.adSettings.httpsOnly = true
        adView.delegate = self
        
        adView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(adView)

        adView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        adView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        adView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        adView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        adView.load()
        
        self.smaatoAdView = adView
    }
    
    private func loadNuiAd() {
        Logging.info("Loading NUI ad.")
        
        let adView = NUIAdView(frame: bounds)
        adView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(adView)
        
        adView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        adView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        adView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        adView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        adView.load(Constants.Ads.NUI.adURL)
        
        self.nuiAdView = adView
    }
    
}

extension AdView: SOMAAdViewDelegate {
    
    func somaAdViewDidLoadAd(_ adView: SOMAAdView!) {
        guard adView == smaatoAdView else { return }
        
        bringSubviewToFront(adView)
    }
    
    func somaAdView(_ adview: SOMAAdView!, didFailToReceiveAdWithError error: Error!) {
        Logging.error(error)
        
        guard adview == smaatoAdView else { return }
        switchToNUI()
    }
    
    func switchToNUI() {
        smaatoAdView?.removeFromSuperview()
        smaatoAdView = nil
        
        loadNuiAd()
    }
    
}
