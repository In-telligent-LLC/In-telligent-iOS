//
//  AuthResetPasswordViewController.swift
//  Intelligent
//
//  Created by Kurt on 9/27/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit
import IntelligentKit

class AuthResetPasswordViewController: AuthViewController {
    
    @IBOutlet weak var passwordInputView: INInputView!
    @IBOutlet weak var password2InputView: INInputView!
    @IBOutlet weak var submitButton: INLoadingButton!

    override var inInputViews: [INInputView] {
        return [
            passwordInputView,
            password2InputView
        ]
    }
    
    var validatedRequest: ValidateSignupRequest!
    var resetCode: String?
    
    override internal func setupView() {
        super.setupView()
        
        titleLabel?.text = NSLocalizedString("Reset Password", comment: "")
        passwordInputView.textField?.placeholder = NSLocalizedString("Password", comment: "")
        password2InputView.textField?.placeholder = NSLocalizedString("Confirm Password", comment: "")
        submitButton.title = NSLocalizedString("CHANGE PASSWORD", comment: "")
    }
    
    private func validateRequest() throws -> ResetPasswordRequest {
        guard let resetCode = resetCode, !resetCode.isEmpty else {
            throw INError(message: NSLocalizedString("Invalid reset code. Please try again.", comment: ""))
        }
        guard let password = passwordInputView.stringValue, !password.isEmpty else {
            throw INError(message: NSLocalizedString("Please input a valid password", comment: ""))
        }
        guard let password2 = password2InputView.stringValue, !password2.isEmpty else {
            throw INError(message: NSLocalizedString("Please input a valid confirmed password", comment: ""))
        }
        guard password == password2 else {
            throw INError(message: NSLocalizedString("Passwords must match", comment: ""))
        }
        return ResetPasswordRequest(resetCode: resetCode, password: password, password2: password2)
    }
    
    @IBAction func backTapped(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func changePasswordTapped(_ sender: Any) {
        do {
            let request = try validateRequest()
            showLoading(submitButton)
            API.resetPassword(request, success: { [weak self] (token) in
                self?.hideLoading()
                self?.login(token)
            }) { [weak self] (error) in
                self?.hideLoading()
                self?.showError(error)
            }
        } catch {
            self.showError(error)
        }
    }
}
