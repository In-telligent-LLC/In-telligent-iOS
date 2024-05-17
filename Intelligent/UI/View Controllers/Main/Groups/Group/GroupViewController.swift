//
//  GroupViewController.swift
//  Intelligent
//
//  Created by Kurt on 10/17/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit
import IntelligentKit

protocol BuildingsDataSource: class {
    func nextBuilding(after building: Building) -> Building?
    func previousBuilding(before building: Building) -> Building?
}

class GroupViewController: INViewController {

    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var websiteButton: UIButton!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var moreToggleDropdownButton: INToggleDropdownButton!
    
    @IBOutlet weak var editActionsView: UIView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteButton: INLoadingButton!
    
    @IBOutlet weak var manageActionsView: UIView!
    @IBOutlet weak var inviteButton: INButton!
    @IBOutlet weak var viewAlertsButton: INButton!
    @IBOutlet weak var viewMembersButton: INButton!

    @IBOutlet weak var actionsView: UIView!
    @IBOutlet weak var messageFeedButton: INButton!
    @IBOutlet weak var actionButton: INLoadingButton!
    
    override var loadableViews: [UIView] {
        return [
            actionButton
        ]
    }
    
    var PCManagerViews: [UIView] {
        return [
            editActionsView,
            manageActionsView
        ]
    }
    
    var nonPCManagerViews: [UIView] {
        return [
            actionsView
        ]
    }
    
    var building: Building!

    weak var dataSource: BuildingsDataSource?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func setupView() {
        super.setupView()
        
        inviteButton.title = NSLocalizedString("INVITE OTHERS TO JOIN", comment: "")
        viewAlertsButton.title = NSLocalizedString("VIEW ALERTS", comment: "")
        viewMembersButton.title = NSLocalizedString("VIEW MEMBERS", comment: "")
        
        messageFeedButton.title = NSLocalizedString("MESSAGE FEED", comment: "")
        
        setupBuilding()
    }
    
    private func changeBuilding(to building: Building) {
        self.building = building
        setupBuilding()
    }
    
    private func setupBuilding() {
        if let url = building.imageURL?.url {
            imageView.sd_setImage(with: url, completed: nil)
        } else {
            imageView.image = building.image
        }
        nameLabel.text = building.name
        infoLabel.text = building.info
        if let dateString = building.createdAt?.formatted(with: DateFormatter.shortDateTimeFormatter) {
            let format = NSLocalizedString("Created on %@", comment: "")
            dateLabel.text = String.localizedStringWithFormat(format, dateString)
        } else {
            dateLabel.text = nil
        }
        websiteButton.setTitle(building.websiteURL?.url?.absoluteString, for: .normal)
        
        let hasPrevious = dataSource?.previousBuilding(before: building) != nil
        let hasNext = dataSource?.nextBuilding(after: building) != nil
        previousButton.isEnabled = hasPrevious
        nextButton.isEnabled = hasNext
        
        let isPCManager = building.isPersonal && building.isManagedByCurrentUser
        
        for view in PCManagerViews {
            view.isHidden = !isPCManager
        }
        for view in nonPCManagerViews {
            view.isHidden = isPCManager
        }
        
        setupInfo(moreToggleDropdownButton.isToggling)
        setupAction()
    }
    
    private func setupAction() {
        if let action = building.action {
            actionButton.isHidden = false
            actionButton.setTitle(action.localizedString, for: .normal)
        } else {
            actionButton.isHidden = true
        }
    }

    private func setupInfo(_ isShowing: Bool) {
        moreToggleDropdownButton.title = isShowing ? NSLocalizedString("Read less", comment: "") : NSLocalizedString("Read more", comment: "")
        infoLabel.numberOfLines = isShowing ? 0: 2
        moreToggleDropdownButton.isHidden = infoLabel.calculateMaxLines() <= 2
    }
    
    @IBAction func websiteTapped(_ sender: Any) {
        guard let url = building.websiteURL?.url else { return }
        
        showURL(url)
    }
    
    @IBAction func toggleChanged(_ sender: INToggleDropdownButton) {
        setupInfo(sender.isToggling)
    }
    
    @IBAction func backTapped(_ sender: Any) {        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextTapped(_ sender: Any) {
        guard let building = dataSource?.nextBuilding(after: building) else { return }
        changeBuilding(to: building)
    }
    
    @IBAction func previousTapped(_ sender: Any) {
        guard let building = dataSource?.previousBuilding(before: building) else { return }
        changeBuilding(to: building)
    }
}

//MARK: Non-Personal actions
extension GroupViewController {
    
    @IBAction func messageFeedTapped(_ sender: Any) {
        guard let subscriber = INSubscriber.current else { return }
        
        guard subscriber.isSubscribed(to: building.id) || building.password?.isEmpty != false else {
            let message = NSLocalizedString("This group is password protected, you must subscribe to see it's messages", comment: "")
            showErrorMessage(message)
            return
        }
        
        guard let vc = Storyboard.groups.viewController(vc: GroupNotificationsViewController.self) else { return }
        vc.building = building
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func actionTapped(_ sender: Any) {
        guard let action = building.action else { return }
        
        switch action {
        case .disconnect:
            toDisconnect(building)
        case .connect:
            toConnect(building)
        }
    }
    
    private func toDisconnect(_ building: Building) {
        showLoading(actionButton, showLoadingHUD: true)
        let request = UnsubscribeBuildingRequest(buildingId: building.id, automatic: false)
        API.unsubscribeFromBuilding(request, success: { [weak self] in
            self?.hideLoading()
            self?.setupAction()
            self?.promptAutoSubscribeOptOut(building)
            }, failure: { [weak self] (error) in
                self?.hideLoading()
                self?.showError(error)
        })
    }
    
    private func promptAutoSubscribeOptOut(_ building: Building) {
        guard !building.isVirtual else { return }
        
        let format = NSLocalizedString("Would you like to opt-out from automatic subscriptions to %@?", comment: "")
        let title = String.localizedStringWithFormat(format, building.name ?? "")
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Opt-Out", comment: ""), style: .destructive, handler: { (action) in
            let request = AutoSubscribeOptRequest.init(buildingId: building.id, optOut: true)
            API.autoSubscribe(request, success: nil, failure: nil)
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    private func toConnect(_ building: Building) {
        showLoading(actionButton, showLoadingHUD: true)
        let request = SubscribeBuildingRequest(buildingId: building.id, automatic: false, inviteId: nil, optIn: true)
        API.subscribeToBuilding(request, success: { [weak self] in
            self?.hideLoading()
            self?.setupAction()
            }, failure: { [weak self] (error) in
                self?.hideLoading()
                self?.showError(error)
        })
    }
    
    private func toContact(_ building: INBuilding) {
        let availableContactActions = building.availableContactActions
        guard availableContactActions.count > 1 else {
            if let contactAction = availableContactActions.first {
                toContactAction(building, contactAction: contactAction)
            }
            return
        }
        
        let alert = UIAlertController(title: NSLocalizedString("Contact", comment: ""), message: nil, preferredStyle: .actionSheet)
        for contactAction in availableContactActions {
            alert.addAction(UIAlertAction(title: contactAction.localizedString.capitalized, style: .default, handler: { (_) in
                self.toContactAction(building, contactAction: contactAction)
            }))
        }
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func toContactAction(_ building: INBuilding, contactAction: ContactAction) {
        switch contactAction {
        case .call:
            inTabBarController?.toCall(building)
        case .suggest, .message:
            inTabBarController?.toSendMessage(building)
        }
    }
}

//MARK: Personal actions
extension GroupViewController {
    
    @IBAction func editTapped(_ sender: Any) {
        guard let vc = Storyboard.groups.viewController(vc: GroupEditViewController.self) else { return }
        vc.building = building
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func deleteTapped(_ sender: Any) {
        let alert = UIAlertController(title: NSLocalizedString("Are you sure you want to delete this group?", comment: ""), message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Delete", comment: ""), style: .destructive, handler: { (action) in
            self.deleteGroup()
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func deleteGroup() {
        let request = DeleteBuildingRequest(building: building)
        
        showLoading(deleteButton, showLoadingHUD: true)
        API.deleteBuilding(request, success: { [weak self] in
            self?.hideLoading()
            self?.didDeleteGroup()
            }, failure: { [weak self] (error) in
                self?.hideLoading()
                self?.showError(error)
        })
    }
    
    private func didDeleteGroup() {
        showAlert(NSLocalizedString("Group Deleted", comment: ""), message: nil) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func viewGroupMembersTapped(_ sender: Any) {
        guard let vc = Storyboard.groups.viewController(vc: GroupMembersViewController.self) else { return }
        
        vc.building = building
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func viewAlertsTapped(_ sender: Any) {
        guard let vc = Storyboard.groups.viewController(vc: GroupNotificationsViewController.self) else { return }
        
        vc.building = building
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func inviteGroupMembersTapped(_ sender: Any) {
        guard let vc = Storyboard.groups.viewController(vc: GroupMemberInviteNewViewController.self) else { return }
        
        vc.building = building
        navigationController?.pushViewController(vc, animated: true)
    }
}
