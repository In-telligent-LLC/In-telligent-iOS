//
//  SendMessageViewController.swift
//  Intelligent
//
//  Created by Kurt on 10/11/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit
import IntelligentKit

class SendMessageViewController: INViewController {

    @IBOutlet weak var titleInputView: INInputView!
    @IBOutlet weak var messageInputView: INInputView!
    @IBOutlet weak var attachmentInputView: INInputView!
    @IBOutlet weak var notificationTypeInputView: INInputView!
    @IBOutlet weak var sendToInputView: INInputView!

    @IBOutlet weak var attachmentsButton: INButton!
    @IBOutlet weak var notificationTypeButton: INDropdownButton!
    @IBOutlet weak var sendToButton: INDropdownButton!
    @IBOutlet weak var submitButton: INLoadingButton!

    override var inInputViews: [INInputView] {
        return [
            titleInputView,
            messageInputView,
            attachmentInputView,
            notificationTypeInputView,
            sendToInputView
        ]
    }

    var building: INBuilding! {
        didSet {
            print(building)
            isSendingActualAlert = building.isManagedByCurrentUser
        }
    }
    private var isSendingActualAlert = false
    
    private var attachments: [CustomImage] = [] { didSet { setupAttachmentsButton() } }
    private var notificationType: NotificationType? { didSet { setupNotificationTypeButton() } }
    private var sendTo: SendTo = .all {
        didSet {
            setupSendToButton()
            specifiedSubscribers.removeAll()
        }
    }
    private var specifiedSubscribers: [BuildingSubscriber] = []
    private let deliverTo: DeliverTo = .inTelligent

    override internal func setupView() {
        super.setupView()
        
        titleInputView.textField?.placeholder = NSLocalizedString("Enter Title", comment: "")
        messageInputView.textView?.placeholder = NSLocalizedString("Enter Message", comment: "")

        attachmentsButton.title = NSLocalizedString("Add Attachment", comment: "")
        attachmentInputView.isHidden = building.isPersonal
            
        notificationTypeInputView.isHidden = !isSendingActualAlert
        sendToInputView.isHidden = !building.isPersonal || !isSendingActualAlert
        
        submitButton.title = isSendingActualAlert ? NSLocalizedString("Send Message", comment: "") : NSLocalizedString("Suggest Message", comment: "")

        setupNotificationTypeButton()
        setupSendToButton()
    }
    
    private func setupNotificationTypeButton() {
        notificationTypeButton.title = notificationType?.localizedString ?? NSLocalizedString("Type of Alert", comment: "")
    }
    
    private func setupSendToButton() {
        let title = String(format: "%@: %@", arguments: [NSLocalizedString("Send To", comment: ""), NSLocalizedString(sendTo.localizedString, comment: "")])
        sendToButton.title = title
    }
    
    private func setupAttachmentsButton() {
        let format = NSLocalizedString("%d Attachments", comment: "")
        attachmentsButton.title = String.localizedStringWithFormat(format, attachments.count)
    }

    @IBAction func typeOfAlertTapped(_ sender: INDropdownButton) {
        let vc = SelectNotificationTypeViewController.vc(notificationType: notificationType, notificationTypes: building.availableNotificationTypes)
        vc.delegate = self
        vc.configurePopover(sender.dropdownImageView)
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func sendToTapped(_ sender: INDropdownButton) {
        let vc = SelectSendToViewController.vc(sendTo: sendTo)
        vc.delegate = self
        vc.configurePopover(sender.dropdownImageView)
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func attachmentsTapped(_ sender: Any) {
        if attachments.count == 0 {
            addAttachment()
        } else {
            let alert = UIAlertController(title: NSLocalizedString("Attachments", comment: ""), message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Add Attachment", comment: ""), style: .default, handler: { (action) in
                self.addAttachment()
            }))
            alert.addAction(UIAlertAction(title: NSLocalizedString("Remove Attachment", comment: ""), style: .destructive, handler: { (action) in
                self.promptRemoveAttachments()
            }))
            alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    private func promptRemoveAttachments() {
        guard attachments.count > 1 else {
            attachments.removeAll()
            return
        }
        
        let alert = UIAlertController(title: NSLocalizedString("Remove Attachment", comment: ""), message: nil, preferredStyle: .actionSheet)
        for (i, attachment) in attachments.enumerated() {
            let format = NSLocalizedString("Remove %@", comment: "")
            let title = String.localizedStringWithFormat(format, attachment.imageName ?? "")
            alert.addAction(UIAlertAction(title: title, style: .default, handler: { (action) in
                self.attachments.remove(at: i)
            }))
        }
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    private func addAttachment() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func backTapped(_ sender: Any) {        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sendMessageTapped(_ sender: Any) {
        if isSendingActualAlert {
            sendMessage()
        } else {
            suggestMessage()
        }
    }
}

//MARK CM Send Message
extension SendMessageViewController {
    private func validateRequest() throws -> SendBuildingAlertRequest {
        guard let title = titleInputView.stringValue, !title.isEmpty else {
            throw INError(message: NSLocalizedString("Please input a valid title", comment: ""))
        }
        guard let message = messageInputView.stringValue, !message.isEmpty else {
            throw INError(message: NSLocalizedString("Please input a valid message", comment: ""))
        }
        guard let notificationType = notificationType else {
            throw INError(message: NSLocalizedString("Please select a notification type", comment: ""))
        }
        return SendBuildingAlertRequest(
            title: title,
            message: message,
            building: building,
            attachments: attachments,
            notificationType: notificationType,
            sendTo: sendTo,
            specifiedSubscribers: specifiedSubscribers,
            deliverTo: deliverTo
        )
    }
    
    private func sendMessage() {
        do {
            let request = try validateRequest()
            showLoading(submitButton)
            API.sendBuildingAlert(request, success: { [weak self] in
                self?.hideLoading()
                self?.didSendAlert()
            }) { [weak self] (error) in
                self?.hideLoading()
                self?.showError(error)
            }
        } catch {
            self.showError(error)
        }
    }
    
    private func didSendAlert() {
        showAlert(NSLocalizedString("Alert Sent", comment: ""), message: nil) {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

//MARK Subscriber Suggest Message
extension SendMessageViewController {
    private func validateSuggestRequest() throws -> SuggestBuildingAlertRequest {
        guard let title = titleInputView.stringValue, !title.isEmpty else {
            throw INError(message: NSLocalizedString("Please input a valid title", comment: ""))
        }
        guard let message = messageInputView.stringValue, !message.isEmpty else {
            throw INError(message: NSLocalizedString("Please input a valid message", comment: ""))
        }
        return SuggestBuildingAlertRequest(
            title: title,
            message: message,
            building: building,
            attachments: attachments
        )
    }
    
    private func suggestMessage() {
        do {
            let request = try validateSuggestRequest()
            showLoading(submitButton)
            API.suggestBuildingAlert(request, success: { [weak self] in
                self?.hideLoading()
                self?.didSendAlert()
            }) { [weak self] (error) in
                self?.hideLoading()
                self?.showError(error)
            }
        } catch {
            self.showError(error)
        }
    }
    
    private func didSuggestAlert() {
        showAlert(NSLocalizedString("Alert Suggested", comment: ""), message: nil) {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension SendMessageViewController: SelectNotificationTypeViewControllerDelegate {
    func selectNotificationTypeViewControllerDidSelect(_ vc: SelectNotificationTypeViewController, notificationType: NotificationType) {
        self.notificationType = notificationType
        vc.dismiss(animated: true, completion: nil)
    }
}

extension SendMessageViewController: SelectSendToViewControllerDelegate {
    func selectSendToViewControllerDidSelect(_ vc: SelectSendToViewController, sendTo: SendTo) {
        if self.sendTo != sendTo {
            self.sendTo = sendTo
        }
        vc.dismiss(animated: true, completion: {
            if sendTo == .specificSubscribers {
                self.toSpecifyBuildingSubscribers()
            }
        })
    }
    
    private func toSpecifyBuildingSubscribers() {
        guard let vc = Storyboard.contact.viewController(vc: SelectBuildingSubscribersViewController.self) else { return }
        
        vc.building = building
        vc.selectedBuildingSubscribers = specifiedSubscribers
        vc.delegate = self
        
        let nc = UINavigationController(rootViewController: vc)
        present(nc, animated: true, completion: nil)
    }
}

extension SendMessageViewController: SelectBuildingSubscribersViewControllerDelegate {
    func selectBuildingSubscribersViewControllerDidSelect(_ vc: SelectBuildingSubscribersViewController, buildingSubscribers: [BuildingSubscriber]) {
        self.specifiedSubscribers = buildingSubscribers
    }
}

extension SendMessageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let image = info[.originalImage] as? UIImage,
            let data = image
                .imageAspectScaled(toFill: CGSize(width: 500, height: 500))
                .jpegData(compressionQuality: 0.9) {
            if let url = info[.imageURL] as? URL {
                let name = url.lastPathComponent
                let customImage = CustomImage(imageName: name, imageData: data)
                attachments.append(customImage)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}
