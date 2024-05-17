//
//  INCallManager.swift
//  ScaIntelligent
//
//  Created by Zachary Zeno on 10/10/16.
//  Copyright © 2016 Zachary Zeno. All rights reserved.
//

import UIKit
import CallKit
import TwilioVoice

public class INCallManager: NSObject {
    
    public typealias CreateCallResponseSuccessHandler = (_ call: TwilioCall) -> Void
    public typealias CreateCallResponseFailureHandler = (_ error: Error?) -> Void
    
    static public let shared = INCallManager()
    
    var availableCall: [String: Any]?
    private (set)var activeCall: TwilioCall?
    
    class public func makeNewCall(to buildingId: Int, success: @escaping CreateCallResponseSuccessHandler, failure: @escaping CreateCallResponseFailureHandler) {
        shared.getCallToken(to: buildingId, success: success, failure: failure)
    }
    
    class func acceptCall(_ uuid: UUID, success: @escaping CreateCallResponseSuccessHandler, failure: @escaping CreateCallResponseFailureHandler) {
        // TODO
    }
    
    class public func endCall(_ uuid: UUID) {
        shared.endActiveCall(uuid)
    }
    
    private func endActiveCall(_ uuid: UUID) {
        if let activeCall = activeCall, activeCall.conferenceId == uuid {
            Logging.info("Ending call with id \(uuid)...")
            activeCall.end()
        }
    }
    
    private func endAnyActiveCall() {
        if let activeCall = activeCall {
            Logging.info("Ending active call...")
            activeCall.end()
        }
    }
}

extension INCallManager {
    
    private func getCallToken(to buildingId: Int, success: @escaping CreateCallResponseSuccessHandler, failure: @escaping CreateCallResponseFailureHandler) {
        Logging.info("Making call to \(buildingId)")
        
        let request = RequestVoIPTokenRequest(
            isCM: false
        )
        API.requestVoIPToken(request, success: { [weak self] (token) in
            self?.createCall(token: token, to: buildingId, success: success, failure: failure)
            }, failure: { (error) in
                failure(error)
        })
    }
    
    private func createCall(token: String, to buildingId: Int, success: @escaping CreateCallResponseSuccessHandler, failure: @escaping CreateCallResponseFailureHandler) {
        guard let subscriberId = INSubscriber.current?.id else { return }
        
        endAnyActiveCall()
        
        let conferenceId = UUID()
        
        let twilioCall = TwilioCall(conferenceId: conferenceId)
        twilioCall.managerDelegate = self
        
        let parameters: [String: String] = [
            "isCM": "",
            "conferenceId": conferenceId.uuidString,
            "senderId": "\(subscriberId)",
            "buildingId": "\(buildingId)"
        ]
        let tvoCall = TwilioVoice.call(token, params: parameters, uuid: conferenceId, delegate: twilioCall)
        
        twilioCall.start(tvoCall: tvoCall)
        self.activeCall = twilioCall
        
        let request = MakeVoIPCallRequest(
            isCM: false,
            buildingId: buildingId,
            subscriberId: subscriberId,
            conferenceId: conferenceId.uuidString
        )
        API.makeVoIPCall(request, success: { [weak self] (accepted) in
            self?.didCreateCall(with: conferenceId, accepted: accepted, success: success, failure: failure)
            }, failure: { [weak self] (error) in
                self?.activeCall?.end()
                failure(error)
        })
    }
    
    private func didCreateCall(with conferenceId: UUID, accepted: Bool, success: @escaping CreateCallResponseSuccessHandler, failure: @escaping CreateCallResponseFailureHandler)  {
        guard let call = activeCall, call.conferenceId == conferenceId else { return }
        
        if !accepted {
            call.end()
            failure(nil)
        } else {
            success(call)
        }
    }
}

extension INCallManager: TwilioCallDelegate {
    
    public func callEnded(_ call: TwilioCall) {
        guard call == activeCall else {
            return Logging.info("Tried to end call that is not currently active")
        }
        
        self.activeCall = nil
    }
}
