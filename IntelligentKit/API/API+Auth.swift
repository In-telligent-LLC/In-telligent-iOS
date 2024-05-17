//
//  API+Auth.swift
//  Intelligent
//
//  Created by Kurt on 9/28/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

//MARK: Get Current
extension API {
    
    public class func loginCurrentSubscriber(_ token: String, success: @escaping (_ subscriber: INSubscriber) -> Void, failure: @escaping APIResponseFailureHandler) {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        shared.get(endpoint: "/subscribers/me", headers: headers, success: { (json) in
            let result = json["success"].boolValue
            if result, let subscriber = INSubscriber(json: json["Subscriber"]) {
                success(subscriber)
            } else {
                let error = INError(json: json)
                failure(error)
            }
        }, failure: failure)
    }
    
    public class func updateCurrentSubscriber(_ success: ((_ subscriber: INSubscriber) -> Void)?, failure: APIResponseFailureHandler?) {
        shared.get(endpoint: "/subscribers/me", success: { (json) in
            let result = json["success"].boolValue
            if result, let subscriber = INSubscriber(json: json["Subscriber"]) {
                INSubscriberManager.updateCurrentSubscriber(subscriber)
                success?(subscriber)
            } else {
                let error = INError(json: json)
                failure?(error)
            }
        }, failure: failure)
    }
    
}

//MARK: Login
extension API {
    public class func login(_ request: LoginPasswordRequest, success: @escaping (_ token: String) -> Void, failure: @escaping APIResponseFailureHandler) {
        shared.post(endpoint: "/auth/token", parameters: request.parameters, success: { (json) in
            let result = json["success"].boolValue
            if result, let token = json["token"].string {
                success(token)
            } else {
                let error = INError(json: json)
                failure(error)
            }
        }, failure: failure)
    }
}

//MARK: Login/Signup with Facebook
extension API {
    public class func loginSignupWithFacebook(_ request: FacebookLoginSignupRequest, success: @escaping (_ token: String) -> Void, failure: @escaping APIResponseFailureHandler) {
        shared.post(endpoint: "/auth/tokenFacebook", parameters: request.parameters, success: { (json) in
            let result = json["success"].boolValue
            if result, let token = json["token"].string {
                success(token)
            } else {
                let error = INError(json: json)
                failure(error)
            }
        }, failure: failure)
    }
}

//MARK: Login/Signup with Google
extension API {
    public class func loginSignupWithGoogle(_ request: GoogleLoginSignupRequest, success: @escaping (_ token: String) -> Void, failure: @escaping APIResponseFailureHandler) {
        shared.post(endpoint: "/auth/tokenGoogle", parameters: request.parameters, success: { (json) in
            let result = json["success"].boolValue
            if result, let token = json["token"].string {
                success(token)
            } else {
                let error = INError(json: json)
                failure(error)
            }
        }, failure: failure)
    }
}

//MARK: Signup
extension API {
    public class func validateSignup(_ request: ValidateSignupRequest, success: @escaping APIResponseSuccessVoidHandler, failure: @escaping APIResponseFailureHandler) {
        shared.post(endpoint: "/subscribers/checkEmail", parameters: request.parameters, success: { (json) in
            let isValid = json["valid"].boolValue
            if !isValid {
                let error = INError(json: json)
                failure(error)
            } else {
                success()
            }
        }, failure: failure)
    }

    public class func signup(_ validated: ValidateSignupRequest, request: SignupPasswordRequest, success: @escaping (_ token: String) -> Void, failure: @escaping APIResponseFailureHandler) {
        let parameters: Parameters = validated.parameters.merging(request.parameters) { (key1, key2) -> Any in
            return key1 as! String != key2 as! String
        }
        shared.post(endpoint: "/auth/signup", parameters: parameters, success: { (json) in
            let result = json["success"].boolValue
            if result, let token = json["token"].string {
                success(token)
            } else {
                let error = INError(json: json)
                failure(error)
            }
        }, failure: failure)
    }
}

//MARK: Forgot Password
extension API {
    public class func forgotPassword(_ request: ForgotPasswordRequest, success: @escaping (_ success: Bool) -> Void, failure: @escaping APIResponseFailureHandler) {
        shared.post(endpoint: "/auth/forgotPassword", parameters: request.parameters, success: { (json) in
            let result = json["success"].boolValue
            success(result)
        }, failure: failure)
    }
}

//MARK: Reset Password
extension API {
    public class func resetPassword(_ request: ResetPasswordRequest, success: @escaping (_ token: String) -> Void, failure: @escaping APIResponseFailureHandler) {
        shared.post(endpoint: "/auth/resetPassword", parameters: request.parameters, success: { (json) in
            let result = json["success"].boolValue
            if result, let token = json["token"].string {
                success(token)
            } else {
                let error = INError(json: json)
                failure(error)
            }
        }, failure: failure)
    }
}

//MARK: Login
extension API {
    public class func loginPartner(_ request: LoginPartnerRequest, success: @escaping (String) -> Void, failure: @escaping APIResponseFailureHandler) {
        shared.post(endpoint: "/auth/token", parameters: request.parameters, success: { (json) in
            let result = json["success"].boolValue
            if result, let token = json["token"].string {
                success(token)
            } else {
                let error = INError(json: json)
                failure(error)
            }
        }, failure: failure)
    }
}
