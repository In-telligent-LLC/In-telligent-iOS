//
//  GroupMemberInviteNewViewController.swift
//  Intelligent
//
//  Created by Kurt on 10/18/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit
import IntelligentKit

class GroupMemberInviteNewViewController: GroupMemberInviteBaseViewController {
    
    @IBOutlet weak var orLabel: UILabel!
    
    var building: Building!
    
    override func setupView() {
        super.setupView()
        
        titleLabel?.text = NSLocalizedString("Invite New Member", comment: "")
        orLabel.text = NSLocalizedString("or", comment: "")
        submitButton.title = NSLocalizedString("SEND INVITE & SAVE CONTACT", comment: "")
    }

    @IBAction func submitTapped(_ sender: Any) {
        submitInviteGroupMember()
    }
}

//MARK: Invite New Member
extension GroupMemberInviteNewViewController {
    
    private func validateInviteSubscriber() throws -> InviteSubscriberRequest {
        guard let name = nameInputView.stringValue, !name.isEmpty else {
            throw INError(message: NSLocalizedString("Please input a valid name", comment: ""))
        }
        let email = emailInputView.stringValue ?? ""
        if !email.isEmpty {
            guard email.isValidEmail else {
                throw INError(message: NSLocalizedString("Please input a valid email", comment: ""))
            }
        }
        let phoneNumber = phoneNumberInputView.stringValue ?? ""
        if !phoneNumber.isEmpty {
            guard phoneNumber.isValidPhoneNumber else {
                throw INError(message: NSLocalizedString("Please input a valid phone number", comment: ""))
            }
        }
        guard email.isValidEmail || phoneNumber.isValidPhoneNumber else {
            throw INError(message: NSLocalizedString("Please input a valid email or phone number", comment: ""))
        }
        return InviteSubscriberRequest(building: building, name: name, phoneNumber: phoneNumber, email: email)
    }
    
    private func submitInviteGroupMember() {
        do {
            let request = try validateInviteSubscriber()
            showLoading(submitButton)
            API.inviteSubscriber(request, success: { [weak self] in
                self?.hideLoading()
                self?.didInviteGroupMember()
            }) { [weak self] (error) in
                self?.hideLoading()
                self?.showError(error)
            }
        } catch {
            showError(error)
        }
    }
    
    private func didInviteGroupMember() {        
        showAlert(NSLocalizedString("Invited", comment: ""), message: nil) {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

