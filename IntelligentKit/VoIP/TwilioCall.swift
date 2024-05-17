//
//  SinchCall.swift
//  ScaIntelligent
//
//  Created by Zachary Zeno on 10/10/16.
//  Copyright © 2016 Zachary Zeno. All rights reserved.
//

import Foundation
import TwilioVoice

@objc
public protocol TwilioCallDelegate: class {
    @objc optional func callEnded(_ call: TwilioCall)
    @objc optional func callStatusChanged(_ call: TwilioCall)
}

public class TwilioCall: NSObject {
    
    public enum CallStatus {
        case none, initialized, connecting, connected(Date), disconnected(Error?), failed(Error)
        
        public var isActive: Bool {
            return intValue != -1
        }
        
        public var intValue: Int {
            switch self {
            case .initialized:
                return 0
            case .connecting:
                return 1
            case .connected(_):
                return 2
            default:
                return -1
            }
        }
    }
    
    public let conferenceId: UUID
    public var tvoCall: TVOCall!
    
    public weak var callDelegate: TwilioCallDelegate?
    weak var managerDelegate: TwilioCallDelegate?
    
    public var status: CallStatus = .none {
        didSet {
            callDelegate?.callStatusChanged?(self)
            managerDelegate?.callStatusChanged?(self)

            switch status {
            case .disconnected(_), .failed(_):
                callDelegate?.callEnded?(self)
                managerDelegate?.callEnded?(self)
            default:
                break
            }
        }
    }

    init(conferenceId: UUID) {
        self.conferenceId = conferenceId
        
        super.init()
    }
    
    func start(tvoCall: TVOCall) {
        self.tvoCall = tvoCall
        status = .connecting
    }
    
    func end() {
        tvoCall.disconnect()
    }
    
    func fail() {
        Logging.info("Call Failed")
        // TODO?
    }
}

extension TwilioCall: TVOCallDelegate {
    
    public func callDidConnect(_ call: TVOCall) {
        Logging.info("callDidConnect")
        status = .connected(Date())
    }
    
    public func call(_ call: TVOCall, didFailToConnectWithError error: Error) {
        Logging.info("callDidFail")
        status = .failed(error)
    }
    
    public func call(_ call: TVOCall, didDisconnectWithError optError: Error?) {
        Logging.info("callDidEnd")
        status = .disconnected(optError)
    }
}
