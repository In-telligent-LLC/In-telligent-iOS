//
//  InboxNotificationViewController.swift
//  Intelligent
//
//  Created by Kurt on 10/5/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import IntelligentKit

protocol InboxNotificationsDataSource: class {
    func nextNotification(after notification: INNotification) -> INNotification?
    func previousNotification(before notification: INNotification) -> INNotification?
}

protocol InboxNotificationsDelegate: class {
    func didView(notification: INNotification)
    func didToggleSave(notification: INNotification)
}

class InboxNotificationViewController: BaseNotificationViewController {
    
    @IBOutlet weak var textToSpeechButton: INButton!
    @IBOutlet weak var translateButton: INLoadingButton!
    @IBOutlet weak var toggleSaveButton: INLoadingButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    
    override var loadableViews: [UIView] {
        return [
            translateButton,
            toggleSaveButton
        ]
    }
    
    private var translation: Translation? {
        didSet { setupTranslation() }
    }
    weak var delegate: InboxNotificationsDelegate?
    weak var dataSource: InboxNotificationsDataSource?

    private var isTextToSpeechPlaying = false { didSet { setupTextToSpeechButton() } }
    private var speechSynthesizer: AVSpeechSynthesizer?

    override internal func setupView() {
        super.setupView()

        translateButton.title = NSLocalizedString("TRANSLATE", comment: "")
        setupTextToSpeechButton()
    }
    
    override internal func setupNotification() {
        super.setupNotification()
        
        let hasPrevious = dataSource?.previousNotification(before: notification) != nil
        let hasNext = dataSource?.nextNotification(after: notification) != nil
        previousButton.isEnabled = hasPrevious
        nextButton.isEnabled = hasNext
        
        stopTextToSpeech()
        setupToggleSaveButton()
        delegate?.didView(notification: notification)
    }
    
    private func setupTranslation() {
        titleTextView?.text = translation?.title
        textView?.text = translation?.message
    }
    
    private func setupTextToSpeechButton() {
        let title: String
        if isTextToSpeechPlaying {
            title = NSLocalizedString("STOP SPEAKING", comment: "")
        } else {
            title = NSLocalizedString("TEXT TO SPEECH", comment: "")
        }
        textToSpeechButton.title = title
    }
    
    private func setupToggleSaveButton() {
        let title: String
        if notification.isSaved {
            title = NSLocalizedString("UNSAVE MESSAGE", comment: "")
        } else {
            title = NSLocalizedString("SAVE MESSAGE", comment: "")
        }
        toggleSaveButton.title = title
    }
    
    private func changeNotification(to notification: INNotification) {
        self.notification = notification
        self.translation = nil
        setupNotification()
    }
    
    @IBAction func toggleSaveTapped(_ sender: Any) {
        toggleSave()
    }
    
    @IBAction func textToSpeechTapped(_ sender: Any) {
        toggleTextToSpeech()
    }
    
    @IBAction func translateTapped(_ sender: Any) {
        startTranslation()
    }
    
    @IBAction func nextTapped(_ sender: Any) {
        guard let notification = dataSource?.nextNotification(after: notification) else { return }
        changeNotification(to: notification)
    }
    
    @IBAction func previousTapped(_ sender: Any) {
        guard let notification = dataSource?.previousNotification(before: notification) else { return }
        changeNotification(to: notification)
    }
}

//MARK: Toggle Save
extension InboxNotificationViewController {

    private func toggleSave() {
        guard let notification = self.notification else { return }
        let isSaving = !notification.isSaved
        
        showLoading(toggleSaveButton)
        API.toggleSaveNotification(notification, isSaving: isSaving, success: { [weak self] in
            self?.hideLoading()
            self?.notification.isSaved = isSaving
            self?.setupToggleSaveButton()
            self?.delegate?.didToggleSave(notification: notification)
        }) { [weak self] (error) in
            self?.hideLoading()
            self?.showError(error)
        }
    }

}

//MARK: Text to Speech
extension InboxNotificationViewController: AVSpeechSynthesizerDelegate {
    
    private func stopTextToSpeech() {
        let _ = speechSynthesizer?.stopSpeaking(at: .immediate)
        speechSynthesizer = nil
        isTextToSpeechPlaying = false
    }
    
    private func toggleTextToSpeech() {
        isTextToSpeechPlaying = !isTextToSpeechPlaying
        
        guard isTextToSpeechPlaying else {
            stopTextToSpeech()
            return
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            Logging.error(error)
        }
        
        let utterance = AVSpeechUtterance(string: "\(notification!.title) \(notification!.message)")
        let speechSynthesizer = AVSpeechSynthesizer()
        speechSynthesizer.delegate = self
        speechSynthesizer.speak(utterance)
        self.speechSynthesizer = speechSynthesizer
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        isTextToSpeechPlaying = false
        speechSynthesizer = nil
    }
    
}

//MARK: Translation
extension InboxNotificationViewController {
    
    private func startTranslation() {
        showLoading(translateButton)
        LanguageManager.getLanguages({ [weak self] (languages) in
            self?.hideLoading()
            self?.promptLanguages(languages)
        }) { [weak self] (error) in
            self?.hideLoading()
            self?.showError(error)
        }
    }
    
    private func promptLanguages(_ languages: [Language]) {
        let title = NSLocalizedString("Translate to:", comment: "")
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        alert.popoverPresentationController?.sourceView = translateButton
        for language in languages {
            alert.addAction(UIAlertAction(title: language.name, style: .default, handler: { (action) in
                self.translate(to: language)
            }))
        }
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func translate(to language: Language) {
        showLoading(translateButton)
        API.getTranslation(for: notification, to: language, success: { [weak self] (translation) in
            self?.hideLoading()
            self?.didTranslate(translation)
        }) { [weak self] (error) in
            self?.hideLoading()
            self?.showError(error)
        }
    }
    
    private func didTranslate(_ translation: Translation) {
        guard translation.notificationId == notification.id else { return }
        
        self.translation = translation
        setupTranslation()
    }
    
}
