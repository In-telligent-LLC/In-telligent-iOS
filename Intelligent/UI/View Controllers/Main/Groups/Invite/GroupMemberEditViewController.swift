//
//  GroupMemberEditViewController.swift
//  Intelligent
//
//  Created by Kurt on 10/18/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit
import IntelligentKit

class GroupMemberEditViewController: GroupMemberInviteBaseViewController {
    
    @IBOutlet weak var findButton: INButton!
    
    var buildingSubscriber: BuildingSubscriber!

    override internal func setupView() {
        super.setupView()
        
        titleLabel?.text = NSLocalizedString("Edit Member", comment: "")
        findButton.title = NSLocalizedString("FIND", comment: "")
        submitButton.title = NSLocalizedString("SAVE CHANGES", comment: "")
        
        nameInputView.textField?.text = buildingSubscriber.name
        emailInputView.textField?.text = buildingSubscriber.email
        phoneNumberInputView.textField?.text = buildingSubscriber.phoneNumber
    }
    
    @IBAction func findTapped(_ sender: Any) {
        guard let vc = Storyboard.groups.viewController(vc: GroupMemberFindViewController.self) else { return }
        
        vc.buildingSubscriber = buildingSubscriber
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func submitTapped(_ sender: Any) {
        submitEditBuildingSubscriber()
    }
}

//MARK: Edit Invite Member
extension GroupMemberEditViewController {
    
    private func validateEditBuildingSubscriberRequest() throws -> EditBuildingSubscriberRequest {
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
        return EditBuildingSubscriberRequest(inviteId: buildingSubscriber.id, name: name, phoneNumber: phoneNumber, email: email)
    }
    
    private func submitEditBuildingSubscriber() {
        do {
            let request = try validateEditBuildingSubscriberRequest()
            showLoading(submitButton)
            API.editBuildingSubscriber(request, success: { [weak self] in
                self?.hideLoading()
                self?.didEditBuildingSubscriber()
            }) { [weak self] (error) in
                self?.hideLoading()
                self?.showError(error)
            }
        } catch {
            showError(error)
        }
    }
    
    private func didEditBuildingSubscriber() {
        showAlert(NSLocalizedString("Changes Saved", comment: ""), message: nil) {
            self.navigationController?.popViewController(animated: true)
        }
    }
}


