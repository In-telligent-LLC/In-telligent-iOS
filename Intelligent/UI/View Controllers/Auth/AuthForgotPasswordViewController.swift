//
//  AuthForgotPasswordViewController.swift
//  Intelligent
//
//  Created by Kurt on 9/27/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit
import IntelligentKit

class AuthForgotPasswordViewController: INViewController {
    
    @IBOutlet weak var emailInputView: INInputView!
    @IBOutlet weak var submitButton: INLoadingButton!

    override var inInputViews: [INInputView] {
        return [
            emailInputView
        ]
    }
    
    override internal func setupView() {
        super.setupView()
        
        titleLabel?.text = NSLocalizedString("Enter Email Address", comment: "")
        emailInputView.textField?.placeholder = NSLocalizedString("Email", comment: "")
        submitButton.title = NSLocalizedString("SUBMIT", comment: "")
    }
    
    private func validateRequest() throws -> ForgotPasswordRequest {
        guard let email = emailInputView.stringValue, email.isValidEmail else {
            throw INError(message: NSLocalizedString("Please input a valid email", comment: ""))
        }
        return ForgotPasswordRequest(email: email)
    }
    
    @IBAction func resetTapped(_ sender: Any) {
        do {
            let request = try validateRequest()
            showLoading(submitButton)
            API.forgotPassword(request, success: { [weak self] (success) in
                self?.hideLoading()
                self?.didResetPassword()
            }) { [weak self] (error) in
                self?.hideLoading()
                self?.showError(error)
            }
        } catch {
            self.showError(error)
        }
    }
    
    @IBAction func backTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    private func didResetPassword() {
        showAlert(NSLocalizedString("Forgot Password", comment: ""),
                  message: NSLocalizedString("Thanks! Check your email in a few minutes for the password reset link.", comment: ""),
                  completion: {
                    self.navigationController?.popToRootViewController(animated: true)
        })
    }
    
}
