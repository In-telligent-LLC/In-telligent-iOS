//
//  SideMenuViewController.swift
//  Intelligent
//
//  Created by Kurt Jensen on 10/28/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit
import IntelligentKit

protocol SideMenuViewControllerDelegate: class {
    func sideMenuViewControllerDidTapSettings(_ vc: SideMenuViewController)
    func sideMenuViewControllerDidTapSavedMessages(_ vc: SideMenuViewController)
    func sideMenuViewControllerDidTapCreateAGroup(_ vc: SideMenuViewController)
}

class SideMenuViewController: INViewController {
    
    enum TotalSilenceState: Int, CaseIterable {
        case off, on
        
        var localizedString: String {
            switch self {
            case .off: return NSLocalizedString("Off", comment: "")
            case .on: return NSLocalizedString("On", comment: "")
            }
        }
    }
    
    @IBOutlet weak var menuButton: INButton!
    
    @IBOutlet weak var totalSilenceControl: UISegmentedControl!
    @IBOutlet weak var totalSilenceCountdownLabel: UILabel!
    @IBOutlet weak var totalSilenceLabel: UILabel!

    @IBOutlet weak var settingsButton: INButton!
    @IBOutlet weak var savedMessagesButton: INButton!
    @IBOutlet weak var createAGroupButton: INButton!

    @IBOutlet weak var versionLabel: UILabel!
    
    private var timer: Timer?
    weak var delegate: SideMenuViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        timer?.invalidate()
    }
    
    override func setupView() {
        super.setupView()
        
        versionLabel.text = UIApplication.shared.versionDisplayString
        
        menuButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: -20)
        menuButton.title = NSLocalizedString("Menu", comment: "")

        settingsButton.title = NSLocalizedString("Settings", comment: "")
        savedMessagesButton.title = NSLocalizedString("Saved Messages", comment: "")
        createAGroupButton.title = NSLocalizedString("Create A Group", comment: "")
        
        totalSilenceLabel.text = NSLocalizedString("Total Silence", comment: "")

        setupTotalSilenceControl()
        updateTotalSilence()
    }
    
    private func setupTotalSilenceControl() {
        let segmentedControlAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 22),
            .foregroundColor: UIColor.white
        ]
        for state in UIControl.State.all {
            totalSilenceControl.setTitleTextAttributes(segmentedControlAttributes, for: state)
        }
        for (i, state) in TotalSilenceState.allCases.enumerated() {
            totalSilenceControl.setTitle(state.localizedString, forSegmentAt: i)
        }
    }
    
    private func setupTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] (timer) in
            self?.updateTotalSilence()
        })
    }
    
    private func updateTotalSilence() {
        let countdown: TimeInterval
        var isRunning = false
        if let date = OpenAPI.silenceExpirationDate {
            countdown = date.timeIntervalSinceNow
            isRunning = true
        } else {
            countdown = 0
            timer?.invalidate()
        }
        
        totalSilenceCountdownLabel.text = countdown.HHMMSSvalue
        totalSilenceControl.tintColor = isRunning ? Color.red: Color.blue
        
        let selectedIndex = isRunning ? 1: 0
        if totalSilenceControl.selectedSegmentIndex != selectedIndex {
            totalSilenceControl.selectedSegmentIndex = selectedIndex
        }
    }

    @IBAction func totalSilenceSwitchChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 1 {
            promptSilenceExpirationDate()
        } else {
            OpenAPI.silenceExpirationDate = nil
            updateTotalSilence()
        }
    }
    
    private func promptSilenceExpirationDate() {
        let title = NSLocalizedString("Total Silence", comment: "")
        let message = NSLocalizedString("How many hours would you like total silence for?", comment: "")
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        alert.popoverPresentationController?.sourceView = totalSilenceControl
        for hour in Array(1...12) {
            alert.addAction(UIAlertAction(title: "\(hour)", style: .default, handler: { (action) in
                let timeInterval = TimeInterval(hour)*3600
                self.startTotalSilence(for: timeInterval)
            }))
        }
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func startTotalSilence(for timeInterval: TimeInterval) {
        OpenAPI.silenceExpirationDate = Date().addingTimeInterval(timeInterval)
        setupTimer()
        updateTotalSilence()
    }

    @IBAction func settingsTapped() {
        dismiss(animated: true) {
            self.delegate?.sideMenuViewControllerDidTapSettings(self)
        }
    }
    
    @IBAction func savedMessagesTapped() {
        dismiss(animated: true) {
            self.delegate?.sideMenuViewControllerDidTapSavedMessages(self)
        }
    }
    
    @IBAction func createAGroupTapped() {
        dismiss(animated: true) {
            self.delegate?.sideMenuViewControllerDidTapCreateAGroup(self)
        }
    }
    
    @IBAction func closeTapped() {
        dismiss(animated: true, completion: nil)
    }

}
