//
//  GroupMemberInviteBaseViewController.swift
//  Intelligent
//
//  Created by Kurt Jensen on 11/20/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit
import IntelligentKit

class GroupMemberInviteBaseViewController: INViewController {
    
    @IBOutlet weak var submitButton: INLoadingButton!
    
    @IBOutlet weak var nameInputView: INInputView!
    @IBOutlet weak var emailInputView: INInputView!
    @IBOutlet weak var phoneNumberInputView: INInputView!
    
    override var inInputViews: [INInputView] {
        return [
            nameInputView,
            emailInputView,
            phoneNumberInputView
        ]
    }
        
    override internal func setupView() {
        super.setupView()
        
        submitButton.title = NSLocalizedString("SAVE CHANGES", comment: "")
        
        nameInputView.textField?.placeholder = NSLocalizedString("Name", comment: "")
        emailInputView.textField?.placeholder = NSLocalizedString("Email", comment: "")
        phoneNumberInputView.textField?.placeholder = NSLocalizedString("Phone Number", comment: "")
    }
    
    @IBAction func backTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
