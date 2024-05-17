//
//  AuthSignupFinalViewController.swift
//  Intelligent
//
//  Created by Kurt on 9/28/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit
import IntelligentKit

class AuthSignupFinalViewController: AuthViewController {
    
    @IBOutlet weak var passwordInputView: INInputView!
    @IBOutlet weak var password2InputView: INInputView!
    
    @IBOutlet weak var toLogInButton: INButton!
    @IBOutlet weak var signUpButton: INLoadingButton!

    override var inInputViews: [INInputView] {
        return [
            passwordInputView,
            password2InputView
        ]
    }

    var validatedRequest: ValidateSignupRequest!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override internal func setupView() {
        super.setupView()
        
        titleLabel?.text = NSLocalizedString("Create Account", comment: "")
        passwordInputView.textField?.placeholder = NSLocalizedString("Password", comment: "")
        password2InputView.textField?.placeholder = NSLocalizedString("Confirm Password", comment: "")
        
        signUpButton.title = NSLocalizedString("JOIN NOW", comment: "")
        toLogInButton.title = NSLocalizedString("Already have an account? LOG IN", comment: "")
    }
    
    private func validateRequest() throws -> SignupPasswordRequest {
        guard let password = passwordInputView.stringValue, !password.isEmpty else {
            throw INError(message: NSLocalizedString("Please input a valid password", comment: ""))
        }
        guard let password2 = password2InputView.stringValue, !password2.isEmpty else {
            throw INError(message: NSLocalizedString("Please input a valid confirmed password", comment: ""))
        }
        guard password == password2 else {
            throw INError(message: NSLocalizedString("Passwords must match", comment: ""))
        }
        return SignupPasswordRequest(password: password, password2: password2)
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        do {
            let request = try validateRequest()
            API.signup(validatedRequest, request: request, success: { [weak self] (token) in
                self?.login(token)
            }) { [weak self] (error) in
                self?.showError(error)
            }
        } catch {
            self.showError(error)
        }
    }
    
    @IBAction func toLoginTapped(_ sender: Any) {
        guard let vc = Storyboard.auth.viewController(vc: AuthLoginViewController.self) else { return }
        navigationController?.replace(with: vc, animated: true)
    }
}
