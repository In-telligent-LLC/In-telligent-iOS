//
//  AuthSocialLoginViewController.swift
//  Intelligent
//
//  Created by Kurt Jensen on 10/2/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import GoogleSignIn
import IntelligentKit

class AuthSocialLoginViewController: AuthViewController {
}

//MARK: Facebook
extension AuthSocialLoginViewController {
    
    func loginWithFacebook() {
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        loginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { [weak self] (result, error) in
            guard let fbToken = result?.token?.tokenString else {
                self?.hideLoading()
                self?.showError(error)
                return
            }
            
            self?.loginWithFacebookToken(fbToken, success: { [weak self] (token) in
                self?.login(token)
            }, failure: { [weak self] (error) in
                self?.hideLoading()
                self?.showError(error)
            })
        }
    }
    
    private func loginWithFacebookToken(_ facebookAccessToken: String, success: @escaping (_ token: String) -> Void, failure: @escaping (_ error: Error?) -> Void) {
        let request = FacebookLoginSignupRequest(
            facebookAccessToken: facebookAccessToken
        )
        API.loginSignupWithFacebook(request, success: success, failure: failure)
    }
    
}

//MARK: Google
extension AuthSocialLoginViewController: GIDSignInDelegate, GIDSignInUIDelegate {
    
    func loginWithGoogle() {
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance()?.signOut()

        let button = GIDSignInButton()
        button.sendActions(for: .touchUpInside)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        guard let gToken = user?.authentication?.idToken else {
            showError(error)
            hideLoading()
            return
        }
        
        loginWithGoogleToken(gToken, success: { [weak self] (token) in
            self?.login(token)
            }, failure: { [weak self] (error) in
                self?.hideLoading()
                self?.showError(error)
        })
    }
    
    private func loginWithGoogleToken(_ gToken: String, success: @escaping (_ token: String) -> Void, failure: @escaping (_ error: Error?) -> Void) {
        let request = GoogleLoginSignupRequest(
            googleAccessToken: gToken
        )
        API.loginSignupWithGoogle(request, success: success, failure: failure)
    }
    
}
