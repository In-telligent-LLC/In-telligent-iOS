//
//  ImageViewController.swift
//  Intelligent
//
//  Created by Kurt Jensen on 10/5/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit
import IntelligentKit

class ImageViewController: INViewController {
    
    class func vc(_ url: URL) -> UINavigationController {
        let vc = ImageViewController()
        vc.url = url
        let nc = UINavigationController(rootViewController: vc)
        nc.isNavigationBarHidden = false
        return nc
    }
    
    lazy var closeBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(title: NSLocalizedString("Close", comment: ""), style: .plain, target: self, action: #selector(closeTapped(_:)))
    }()
    
    private let scrollView = UIScrollView()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private var url: URL!
    
    override internal func setupView() {
        super.setupView()
        
        navigationItem.leftBarButtonItem = closeBarButtonItem
        view.backgroundColor = UIColor.black
        
        addSubviews()
        
        imageView.sd_setImage(with: url, completed: nil)

        scrollView.delegate = self
        scrollView.maximumZoomScale = 5
    }
    
    private func addSubviews() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(imageView)
        imageView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
    
    @objc func closeTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension ImageViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
}
