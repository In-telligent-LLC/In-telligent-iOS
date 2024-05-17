//
//  AuthLoginViewController.swift
//  Intelligent
//
//  Created by Kurt Jensen on 9/27/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit
import IntelligentKit

class AuthLoginViewController: AuthSocialLoginViewController {
    
    @IBOutlet weak var toForgotPasswordButton: INButton!
    @IBOutlet weak var toSignUpButton: INButton!
    @IBOutlet weak var orLabel: UILabel!

    @IBOutlet weak var emailInputView: INInputView!
    @IBOutlet weak var passwordInputView: INInputView!
    
    @IBOutlet weak var loginWithEmailButton: INLoadingButton!
    @IBOutlet weak var loginWithFacebookButton: INLoadingButton!
    @IBOutlet weak var loginWithGoogleButton: INLoadingButton!

    override var inInputViews: [INInputView] {
        return [
            emailInputView,
            passwordInputView
        ]
    }
    
    override var loadableViews: [UIView] {
        return [
            loginWithEmailButton,
            loginWithFacebookButton,
            loginWithGoogleButton
        ]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override internal func setupView() {
        super.setupView()
        
        titleLabel?.text = NSLocalizedString("My Account", comment: "")
        emailInputView.textField?.placeholder = NSLocalizedString("Email", comment: "")
        passwordInputView.textField?.placeholder = NSLocalizedString("Password", comment: "")

        loginWithEmailButton.title = NSLocalizedString("LOG IN", comment: "")
        toForgotPasswordButton.title = NSLocalizedString("FORGOT/CHANGE PASSWORD", comment: "")
        toSignUpButton.title = NSLocalizedString("JOIN NOW", comment: "")
        orLabel.text = NSLocalizedString("OR", comment: "")
        
        loginWithFacebookButton.title = NSLocalizedString("Log in with Facebook", comment: "")
        loginWithGoogleButton.title = NSLocalizedString("Log in with Google", comment: "")
    }
    
    private func validateRequest() throws -> LoginPasswordRequest {
        guard let email = emailInputView.stringValue, email.isValidEmail else {
            throw INError(message: NSLocalizedString("Please input a valid email", comment: ""))
        }
        guard let password = passwordInputView.stringValue, !password.isEmpty else {
            throw INError(message: NSLocalizedString("Please input a valid password", comment: ""))
        }
        return LoginPasswordRequest(email: email, password: password)
    }

    @IBAction func loginTapped(_ sender: INLoadingButton) {
        do {
            let request = try validateRequest()
            showLoading(sender)
            API.login(request, success: { [weak self] (token) in
                self?.login(token)
            }) { [weak self] (error) in
                self?.hideLoading()
                self?.showError(error)
            }
        } catch {
            self.showError(error)
        }
    }

    @IBAction func loginWithFacebookTapped(_ sender: INLoadingButton) {
        showLoading(sender)
        loginWithFacebook()
    }
    
    @IBAction func loginWithGoogleTapped(_ sender: INLoadingButton) {
        showLoading(sender)
        loginWithGoogle()
    }
    
    @IBAction func toSignupTapped(_ sender: Any) {
        guard let vc = Storyboard.auth.viewController(vc: AuthSignupInitialViewController.self) else { return }
        navigationController?.replace(with: vc, animated: true)
    }
    
    @IBAction func toResetPasswordTapped(_ sender: Any) {
        guard let vc = Storyboard.auth.viewController(vc: AuthForgotPasswordViewController.self) else { return }
        navigationController?.replace(with: vc, animated: true)
    }
}
