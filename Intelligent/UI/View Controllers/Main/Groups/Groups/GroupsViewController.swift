//
//  GroupsViewController.swift
//  Intelligent
//
//  Created by Kurt on 10/13/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit
import IntelligentKit

class GroupsViewController: INViewController {
    
    lazy var suggestedGroupsToggleHeaderView: ToggleHeaderView = {
       let view = ToggleHeaderView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 44))
        view.title = NSLocalizedString("Suggested Groups", comment: "")
        view.tintColor = Color.blue
        view.delegate = self
        return view
    }()
    
    lazy var myGroupsHeaderView: HeaderView = {
        let view = HeaderView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 44))
        view.title = NSLocalizedString("My Groups", comment: "")
        return view
    }()
    
    lazy var otherGroupsHeaderView: HeaderView = {
        let view = HeaderView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 44))
        view.title = NSLocalizedString("Other Groups", comment: "")
        return view
    }()
    
    @IBOutlet weak var groupFilterView: GroupFilterView!
    @IBOutlet weak var searchInputView: INInputView!
    @IBOutlet weak var tableView: UITableView!
    
    override var inInputViews: [INInputView] {
        return [searchInputView]
    }
    
    private var groupsManager: GroupsManager!
    var myBuildings: [INBuilding] {
        return groupsManager.myBuildings
    }
    var suggestedBuildings: [OtherBuilding] {
        return groupsManager?.suggestedBuildings ?? []
    }
    var otherBuildingsFiltered: [OtherBuilding] {
        return groupsManager?.otherBuildingsFiltered ?? []
    }
    
    override func viewDidLoad() {
        groupsManager = GroupsManager()
        groupsManager.delegate = self
        
        super.viewDidLoad()
        
        groupsManager.update([.suggested(andRemoveBuildingId: nil), .mine])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }        
    }
    
    override func setupView() {
        super.setupView()
        
        searchInputView.textField?.placeholder = NSLocalizedString("Search for Groups", comment: "")
        
        groupFilterView.delegate = self
        groupFilterView.tintColor = Color.darkGray
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.registerNib(cell: SuggestedGroupTableViewCell.self)
        tableView.registerNib(cell: GroupTableViewCell.self)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func toGroup(_ building: Building) {
        guard let vc = Storyboard.groups.viewController(vc: GroupViewController.self) else { return }
        
        vc.dataSource = groupsManager
        vc.building = building
        
        navigationController?.pushViewController(vc, animated: true)
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
    
    private func toDisconnect(_ building: Building) {
        showLoading(nil, showLoadingHUD: true)
        let request = UnsubscribeBuildingRequest(buildingId: building.id, automatic: false)
        API.unsubscribeFromBuilding(request, success: { [weak self] in
            self?.groupsManager.update([.mine])
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
        showLoading(nil, showLoadingHUD: true)
        let request = SubscribeBuildingRequest(buildingId: building.id, automatic: false, inviteId: nil, optIn: true)
        API.subscribeToBuilding(request, success: { [weak self] in
            self?.hideLoading()
            self?.groupsManager.update([.mine])
        }, failure: { [weak self] (error) in
            self?.hideLoading()
            self?.showError(error)
        })
    }
    
    private func toConnectPasswordProtected(_ building: Building, password: String) {
        let alert = UIAlertController(title: NSLocalizedString("Password Required", comment: ""), message: "", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = NSLocalizedString("Password", comment: "")
            textField.isSecureTextEntry = true
        }
        alert.addAction(UIAlertAction(title: NSLocalizedString("Connect", comment: ""), style: .default, handler: {
            (action) in
            guard let input = alert.textFields?.first?.text, input == password else {
                self.showErrorMessage(NSLocalizedString("Invalid Password", comment: ""))
                return
            }
            
            self.toConnect(building)
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    override var shouldAutoResignInputViews: Bool {
        return false
    }
}

extension GroupsViewController {
    func inputValueChanged(_ input: INInputView, value: Any) {
        guard let searchText = value as? String else { return }
        
        groupsManager.searchText = searchText
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            self?.groupsManager.update([.search(onlyIfSearchTextIs: searchText)])
        }
    }
}

extension GroupsViewController: GroupsManagerDelegate {
    func didUpdateGroups() {
        tableView.reloadData()
    }
}

extension GroupsViewController: GroupFilterViewDelegate {
    func didChangeFilter(_ view: GroupFilterView, filter: GroupFilter) {
        groupsManager.filter = filter
    }
}

extension GroupsViewController: ToggleHeaderViewDelegate {
    func toggleHeaderViewDidToggle(_ view: ToggleHeaderView, isShowing: Bool) {
        tableView.reloadData()
    }
}

extension GroupsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return suggestedGroupsToggleHeaderView.isShowing ? min(2, suggestedBuildings.count) : 0
        case 1:
            return myBuildings.count
        case 2:
            return otherBuildingsFiltered.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            return suggestedGroupsToggleHeaderView
        case 1:
            return myGroupsHeaderView
        case 2:
            return otherBuildingsFiltered.count > 0 ? otherGroupsHeaderView: nil
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func building(for indexPath: IndexPath) -> Building {
        let building: Building

        switch indexPath.section {
        case 0:
            building = suggestedBuildings[indexPath.row]
        case 1:
            building = myBuildings[indexPath.row]
        default: //case 2
            building = otherBuildingsFiltered[indexPath.row]
        }

        return building
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let building = self.building(for: indexPath)
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeue(cell: SuggestedGroupTableViewCell.self, for: indexPath)
            cell.configure(with: building)
            cell.delegate = self
            return cell
        case 1:
            let cell = tableView.dequeue(cell: GroupTableViewCell.self, for: indexPath)
            cell.configure(with: building)
            cell.delegate = self
            return cell
        case 2:
            let cell = tableView.dequeue(cell: GroupTableViewCell.self, for: indexPath)
            cell.configure(with: building)
            cell.delegate = self
            return cell
        default:
            return UITableViewCell()
        }
    }
}

extension GroupsViewController: SuggestedGroupTableViewCellDelegate {
    func suggestedGroupTableViewCellDidSelectIgnore(_ cell: SuggestedGroupTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        let building = self.building(for: indexPath)
        groupsManager.removeSuggested(building)
    }
    func suggestedGroupTableViewCellDidSelectSubscribe(_ cell: SuggestedGroupTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }

        let building = self.building(for: indexPath)
        groupsManager.removeSuggested(building)
        toConnect(building)
    }
}

extension GroupsViewController: GroupTableViewCellDelegate {

    func groupTableViewCellDidSelectAbout(_ cell: GroupTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }

        let building = self.building(for: indexPath)
        toGroup(building)
    }
    
    func groupTableViewCellDidSelectAction(_ cell: GroupTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell)  else { return }
        
        let building = self.building(for: indexPath)
        toAction(building)
    }
    
    private func toAction(_ building: Building) {
        guard let action = building.action else { return }
        
        switch action {
        case .disconnect:
            toDisconnect(building)
        case .connect:
            if let password = building.password, !password.isEmpty {
                toConnectPasswordProtected(building, password: password)
            } else {
                toConnect(building)
            }
        }
    }
}
