//
//  AuthViewController.swift
//  Intelligent
//
//  Created by Kurt on 10/4/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit
import IntelligentKit

class AuthViewController: INViewController {
    
    func login(_ token: String) {
        showLoading(nil)
        INSubscriberManager.login(token,
                                  success: { [weak self] in
            self?.hideLoading()
            // do nothing: let subscriber manager notification handle transition.
        },
                                  failure: { [weak self] (error) in
            self?.hideLoading()
            self?.showError(error)
        })
    }
    
}
