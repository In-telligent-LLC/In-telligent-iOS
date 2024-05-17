//
//  NUIAdView.swift
//  Intelligent
//
//  Created by Kurt Jensen on 11/19/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit

class NUIAdView: UIWebView {
    
    enum AdSize {
        case fullBanner,
        halfBanner
        
        var size: CGSize {
            switch self {
            case .fullBanner: return CGSize(width: 468, height: 60)
            case .halfBanner: return CGSize(width: 234, height: 60)
            }
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
        self.delegate = self
    }
    
    func load(_ url: URL) {
        let request = URLRequest(url: url)
        self.loadRequest(request)
    }
}

extension NUIAdView: UIWebViewDelegate {
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        Logging.info("nuiadview request: \(request) \(navigationType)")
        if let url = request.url,
            navigationType == .linkClicked {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            return false
        }
        return true
    }
}
