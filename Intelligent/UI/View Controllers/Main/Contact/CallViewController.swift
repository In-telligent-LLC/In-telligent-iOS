//
//  CallViewController.swift
//  Intelligent
//
//  Created by Kurt on 10/11/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit
import TwilioVoice
import IntelligentKit

class CallViewController: INViewController {
    
    @IBOutlet weak var startCallButton: INButton!
    @IBOutlet weak var endCallButton: INButton!
    @IBOutlet weak var cancelButton: INButton!

    @IBOutlet weak var statusDotsStackView: UIStackView!
    @IBOutlet weak var statusLinesStackView: UIStackView!
    @IBOutlet weak var statusImagesStackView: UIStackView!
    @IBOutlet weak var timeLabel: UILabel!

    @IBOutlet weak var phonePadCollectionView: PhonePadCollectionView!
    
    override var loadableViews: [UIView] {
        return [
            startCallButton,
            endCallButton
        ]
    }
    
    weak var call: TwilioCall?
    var building: INBuilding!

    var autoCall = false
    private var answered = false
    private var timer: Timer? {
        didSet { timeElapsed = 0 }
    }
    private var timeElapsed: TimeInterval = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if autoCall {
            makeCall()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        timer?.invalidate()
    }
    
    override internal func setupView() {
        super.setupView()
        
        startCallButton.title = NSLocalizedString("Begin Call", comment: "")
        endCallButton.title = NSLocalizedString("End Call", comment: "")
        cancelButton.title = NSLocalizedString("CANCEL", comment: "")

        phonePadCollectionView.inputDelegate = self
        setupStatus(.none)
    }
    
    private func setupStatus(_ status: TwilioCall.CallStatus) {
        for (i, view) in statusDotsStackView.arrangedSubviews.enumerated() {
            view.backgroundColor = i <= status.intValue ? Color.green : UIColor.black
        }
        for (i, imageView) in statusImagesStackView.arrangedSubviews.enumerated() {
            imageView.tintColor = i <= status.intValue ? Color.green : UIColor.black
        }
        for (i, view) in statusLinesStackView.arrangedSubviews.enumerated() {
            view.backgroundColor = (i+1) <= status.intValue ? Color.green : UIColor.black
        }
        
        startCallButton.isHidden = status.isActive
        cancelButton.isHidden = status.isActive
        endCallButton.isHidden = !status.isActive
        phonePadCollectionView.isHidden = !status.isActive
    }
    
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] (timer) in
            self?.updateTimer()
        })
    }
    
    private func updateTimer() {
        timeElapsed += 1
        let format = NSLocalizedString("Timer: %@", comment: "")
        timeLabel.text = String.localizedStringWithFormat(format, timeElapsed.MMSSvalue)
    }
    
    private func stopTimer() {
        timer?.invalidate()
    }
    
    @IBAction func makeCallTapped(_ sender: Any) {
        makeCall()
    }
    
    private func makeCall() {
        INCallManager.makeNewCall(to: building.id, success: { [weak self] (call) in
            self?.didMakeCall(call)
        }) { [weak self] (error) in
            self?.showError(error)
        }
        answered = false
    }
    
    private func didMakeCall(_ call: TwilioCall) {
        call.callDelegate = self
        setupStatus(call.status)

        self.call = call
    }
    
    @IBAction func endCallTapped(_ sender: Any) {
        guard let id = call?.conferenceId else { return }
        
        INCallManager.endCall(id)
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension CallViewController: PhonePadCollectionViewDelegate {
    func phonePadCollectionViewDidInputDigit(_ digit: Int) {
        call?.tvoCall.sendDigits("\(digit)")
    }
}

extension CallViewController: TwilioCallDelegate {
    
    func callStatusChanged(_ call: TwilioCall) {
        setupStatus(call.status)
        
        switch call.status {
        case .disconnected,
             .failed:
            didEndCall()
        case .connected:
            didStartCall()
        default:
            break
        }
    }

    private func didStartCall() {
        answered = true
        startTimer()
    }
    
    private func didEndCall() {
        stopTimer()
        
        if !answered {
            showAlert("Call Unanswered", message: "No community managers are available. Please consider sending a text alert instead")
        }
    }
}
