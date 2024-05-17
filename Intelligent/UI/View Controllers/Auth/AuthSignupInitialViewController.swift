//
//  AuthSignupInitialViewController.swift
//  Intelligent
//
//  Created by Kurt Jensen on 9/27/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit
import IntelligentKit

class AuthSignupInitialViewController: AuthSocialLoginViewController {

    @IBOutlet weak var nameInputView: INInputView!
    @IBOutlet weak var emailInputView: INInputView!

    @IBOutlet weak var nextButton: INLoadingButton!
    @IBOutlet weak var toLogInButton: INButton!
    @IBOutlet weak var orLabel: UILabel!

    @IBOutlet weak var signUpWithFacebookButton: INLoadingButton!
    @IBOutlet weak var signUpWithGoogleButton: INLoadingButton!
    
    override var loadableViews: [UIView] {
        return [
            nextButton,
            signUpWithFacebookButton,
            signUpWithGoogleButton
        ]
    }
    
    override var inInputViews: [INInputView] {
        return [
            nameInputView,
            emailInputView
        ]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override internal func setupView() {
        super.setupView()
        
        titleLabel?.text = NSLocalizedString("Create Account", comment: "")
        nameInputView.textField?.placeholder = NSLocalizedString("Full Name", comment: "")
        emailInputView.textField?.placeholder = NSLocalizedString("Email", comment: "")
        
        nextButton.title = NSLocalizedString("NEXT", comment: "")
        toLogInButton.title = NSLocalizedString("Already have an account? LOG IN", comment: "")
        orLabel.text = NSLocalizedString("OR", comment: "")
        
        signUpWithFacebookButton.title = NSLocalizedString("Join now with Facebook", comment: "")
        signUpWithGoogleButton.title = NSLocalizedString("Join now with Google", comment: "")
    }
    
    private func validateRequest() throws -> ValidateSignupRequest {
        guard let name = nameInputView.stringValue, !name.isEmpty else {
            throw INError(message: NSLocalizedString("Please input a valid name", comment: ""))
        }
        guard let email = emailInputView.stringValue, email.isValidEmail else {
            throw INError(message: NSLocalizedString("Please input a valid email", comment: ""))
        }
        return ValidateSignupRequest(name: name, email: email)
    }
    
    @IBAction func nextTapped(_ sender: Any) {
        do {
            let request = try validateRequest()
            showLoading(nextButton)
            API.validateSignup(request, success: { [weak self] in
                self?.hideLoading()
                self?.toSignupFinal(request)
            }) { [weak self] (error) in
                self?.hideLoading()
                self?.showError(error)
            }
        } catch {
            self.showError(error)
        }
    }
    
    @IBAction func signUpWithFacebookTapped(_ sender: INLoadingButton) {
        showLoading(sender)
        loginWithFacebook()
    }
    
    @IBAction func signUpWithGoogleTapped(_ sender: INLoadingButton) {
        showLoading(sender)
        loginWithGoogle()
    }
    
    private func toSignupFinal(_ validatedRequest: ValidateSignupRequest) {
        guard let vc = Storyboard.auth.viewController(vc: AuthSignupFinalViewController.self) else { return }
        
        vc.validatedRequest = validatedRequest
        navigationController?.replace(with: vc, animated: true)
    }
    
    @IBAction func toLoginTapped(_ sender: Any) {
        guard let vc = Storyboard.auth.viewController(vc: AuthLoginViewController.self) else { return }
        
        navigationController?.replace(with: vc, animated: true)
    }
}
