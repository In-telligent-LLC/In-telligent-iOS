//
//  OpenAPI.swift
//  Open API
//
//  Created by Zachary Zeno on 11/12/18.
//  Copyright © 2018 In-telligent LLC. All rights reserved.
//

import Foundation

public class OpenAPI {
    
    /*
     Check if the current access token is valid (should only ever be false on first run)
     If access token is not valid, need to sign in with email/partnerToken
    */
    public static func checkToken() -> Bool {
        return INSessionManager.token != nil
    }
    
    public static var token: String? {
        return INSessionManager.token
    }
    
    public static var silenceExpirationDate: Date? {
        get {
            guard let date = UserDefaults.standard.object(forKey: #function) as? Date,
                date.timeIntervalSinceNow > 0 else { return nil }
            return date
        }
        set { UserDefaults.standard.set(newValue, forKey: #function) }
    }
    
    /*
     Register the user with the backend by sending the user's email and your partnerToken
     This will save an access token in UserDefaults that we use to identify the user
    */
    public static func signInWith(email: String, password: String, partnerToken: String, callback: @escaping (Bool) -> () = {_ in }) {
        let request = LoginPartnerRequest(email: email, password: password, partnerToken: partnerToken)
        API.loginPartner(request, success: { (token) in
            INSubscriberManager.login(token, success: {
                callback(true)
            }, failure: { (error) in
                callback(false)
            })
        }, failure: { (error) in
            callback(false)
        })
    }
    
    /*
     Cannot be called until after the signIn callback triggers
     Should send the pushToken that is returned from PushKit, this will register the user to receive push notifications
    */
    public static func reportPushKitToken(token: String, callback: @escaping (Bool) -> () = {_ in }) {
        let request = RegisterPushTokenRequest(pushToken: token)
        API.registerPushToken(request, success: {
            callback(true)
        }) { (error) in
            callback(false)
        }
    }
    
    /*
     When a PushKit notification comes in, pass to this function. If it is an In-telligent notification it will handle it and return true, otherwise it will return false
     You can also check the payload for the "_sid" key which will have the "in-telligent" value if it is an In-telligent notification
    */
    @discardableResult
    public static func relayPushKitNotification(dictionaryPayload: [AnyHashable: Any]) -> Bool {
        guard dictionaryPayload["_sid"] as? String == "in-telligent" else {
            return false
        }
        
        INPushManager.shared.handlePush(dictionaryPayload)
        return true
    }
    
    /*
     Start playing life safety noise, this will be called automatically in response to a relayed life safety notification but can also be used manually (eg for testing)
    */
    public static func startLifeSafetyNoise(audio: Audio, callback: @escaping (Bool) -> () = {_ in }) {
        INAudioManager.play(audio, completion: callback)
    }

    public static func startLifeSafetyNoise(url: URL, callback: @escaping (Bool) -> () = {_ in }) {
        INAudioManager.play(url, completion: callback)
    }
    
    /*
     Stop currently playing life safety noise, you would usually call this when the app enters the foreground, but we give you control.
    */
    public static func stopLifeSafetyNoise() {
        INAudioManager.stop()
    }
    
    public static func makeCall(buildingId: Int, delegate: TwilioCallDelegate, callback: @escaping (Bool) -> () = {_ in }) {
        INCallManager.makeNewCall(to: buildingId, success: { (call) in
            call.callDelegate = delegate
            callback(true)
        }) { (error) in
            callback(false)
        }
    }
    
    public static func acceptCall(callId: UUID, delegate: TwilioCallDelegate, callback: @escaping (Bool) -> () = {_ in }) {
        INCallManager.acceptCall(callId, success: { (call) in
            call.callDelegate = delegate
            callback(true)
        }) { (error) in
            callback(false)
        }
    }
    
    public static func endCall(callId: UUID) {
        INCallManager.endCall(callId)
    }
    
}
