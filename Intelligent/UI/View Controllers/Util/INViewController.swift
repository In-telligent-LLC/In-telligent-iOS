//
//  INViewController.swift
//  Intelligent
//
//  Created by Kurt Jensen on 9/28/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit
import IntelligentKit
import JGProgressHUD

@objc
protocol Loadable {
    func showLoading()
    func hideLoading()
}

class INViewController: UIViewController, INInputViewDelegate {
    
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var backButton: INButton?
    @IBOutlet weak var keyboardScrollView: UIScrollView?
    
    private let keyboardManager = KeyboardManager()
    private (set)var isLoading = false
    
    lazy var loadingHUD: JGProgressHUD = {
        let hud = JGProgressHUD(style: .dark)
        return hud
    }()

    var shouldHideBackButton: Bool { return true }
    var shouldAutoResignInputViews: Bool { return true }

    var loadableViews: [UIView] {
        return []
    }
    
    var inInputViews: [INInputView] {
        return []
    }
    
    private var barButtonItems: [UIBarButtonItem] {
        return []//(navigationItem.leftBarButtonItems ?? []) + (navigationItem.rightBarButtonItems ?? []) + (toolbarItems ?? [])
    }
    
    func showLoading(_ sender: (UIView & Loadable)?, showLoadingHUD: Bool = false) {
        if showLoadingHUD {
            loadingHUD.show(in: self.view)
        }
        isLoading = true
        loadableViews.forEach({
            if let sender = sender, $0 == sender {
                sender.showLoading()
            } else {
                $0.isUserInteractionEnabled = false
            }
        })
        barButtonItems.forEach({ $0.isEnabled = false })
        if shouldAutoResignInputViews {
            inInputViews.forEach {
                $0.resignFirstResponder()
            }
        }
    }
    
    func hideLoading() {
        loadingHUD.dismiss()
        isLoading = false
        loadableViews.forEach({
            if let loadable = $0 as? Loadable {
                loadable.hideLoading()
            } else {
                $0.isUserInteractionEnabled = true
            }
        })
        barButtonItems.forEach({ $0.isEnabled = true })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        keyboardManager.delegate = self
        setupView()
    }
    
    internal func setupView() {
        navigationItem.hidesBackButton = shouldHideBackButton
        
        backButton?.tintColor = Color.darkGray
        backButton?.title = NSLocalizedString("BACK", comment: "")
        
        inInputViews.forEach {
            $0.delegate = self
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if keyboardScrollView != nil {
            keyboardManager.registerForKeyboardNotifications()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if keyboardScrollView != nil {
            keyboardManager.deregisterForKeyboardNotifications()
        }
    }
    
}

//MARK: KeyboardManager delegate methods
extension INViewController: KeyboardManagerDelegate {
    
    func keyboardTransitioningToShowing(keyboardFrame: CGRect) {
        guard let scrollView = keyboardScrollView else { return }
        let frame: CGRect
        if #available(iOS 11.0, *) {
            frame = view.safeAreaLayoutGuide.layoutFrame
        } else {
            frame = view.frame
        }
        let intersection = frame.intersection(keyboardFrame)
        var insets = scrollView.contentInset
        insets.bottom = intersection.height
        scrollView.contentInset = insets
        scrollView.scrollIndicatorInsets = insets
    }
    
    func keyboardTransitioningToHiding() {
        guard let scrollView = keyboardScrollView else { return }
        var insets = scrollView.contentInset
        insets.bottom = 0
        scrollView.contentInset = insets
        scrollView.scrollIndicatorInsets = insets
    }
    
}
