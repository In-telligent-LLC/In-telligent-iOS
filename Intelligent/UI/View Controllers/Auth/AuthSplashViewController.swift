//
//  AuthSplashViewController.swift
//  Intelligent
//
//  Created by Kurt Jensen on 9/27/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit
import IntelligentKit

class AuthSplashViewController: AuthViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var toSignUpButton: INButton!
    @IBOutlet weak var toLogInButton: INButton!

    private var timer: Timer?
    private var index = 0

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        timer?.invalidate()
    }
    
    override func setupView() {
        super.setupView()
        
        toSignUpButton.title = NSLocalizedString("FIRST TIME USER", comment: "")
        toLogInButton.title = NSLocalizedString("RETURNING SUBSCRIBER", comment: "")

        transitionImage()
    }
    
    private func setupTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: { [weak self] (timer) in
            self?.transitionImage()
        })
    }
    
    private func transitionImage() {
        let imageName: String?
        if let name = HeroImage.imageNames[safe: index] {
            imageName = name
        } else {
            imageName = HeroImage.imageNames.first
            index = 0
        }
        guard imageName != nil else { return }
        
        let nextImage = UIImage(named: imageName!)
        UIView.transition(with: imageView, duration: 1, options: [.transitionCrossDissolve], animations: {
            self.imageView.image = nextImage
        }, completion: nil)
        
        index += 1
    }
    
    @IBAction func toSignupTapped(_ sender: Any) {
        guard let vc = Storyboard.auth.viewController(vc: AuthSignupInitialViewController.self) else { return }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func toLoginTapped(_ sender: Any) {
        guard let vc = Storyboard.auth.viewController(vc: AuthLoginViewController.self) else { return }
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

