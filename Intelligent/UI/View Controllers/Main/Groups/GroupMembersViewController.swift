//
//  GroupMembersViewController.swift
//  Intelligent
//
//  Created by Kurt on 10/17/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit
import IntelligentKit

class GroupMembersViewController: INViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchInputView: INInputView!
    @IBOutlet weak var countLabel: UILabel!

    lazy var noResultsView: INNoResultsView = {
        let view = INNoResultsView()
        view.configure(
            image: UIImage(named: "icon_tab_groups"),
            title: NSLocalizedString("There are no subscribers in this group", comment: ""),
            info: nil,
            actionTitle: nil,
            actionImage: nil
        )
        return view
    }()
    
    override var inInputViews: [INInputView] {
        return [searchInputView]
    }
    
    var building: Building!

    private var groupMembersManager: GroupMembersManager!
    var buildingSubscribers: [BuildingSubscriber] {
        return groupMembersManager!.filteredBuildingSubscribers
    }
    var pendingBuildingSubscribers: [BuildingSubscriber] {
        return groupMembersManager!.filteredPendingBuildingSubscribers
    }
    
    override func viewDidLoad() {
        groupMembersManager = GroupMembersManager(building)
        groupMembersManager.delegate = self

        super.viewDidLoad()
        
        groupMembersManager.update()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func setupView() {
        super.setupView()
        
        searchInputView.textField?.placeholder = NSLocalizedString("Search for Members", comment: "")
        titleLabel?.text = building.name
        setupCountLabel()

        setupTableView()
    }
    
    private func setupCountLabel() {
        let count = pendingBuildingSubscribers.count + buildingSubscribers.count
        if count > 0 {
            let format = NSLocalizedString("Total Members (%d)", comment: "")
            countLabel.text = String.localizedStringWithFormat(format, count)
        } else {
            countLabel.text = nil
        }
    }
    
    private func setupTableView() {
        tableView.registerNib(cell: PendingGroupMemberTableViewCell.self)
        tableView.registerNib(cell: GroupMemberTableViewCell.self)
        tableView.separatorColor = Color.lightGray
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func reloadData() {
        // don't call this in setup, only after data has tried to load and finished or errored
        let count = pendingBuildingSubscribers.count + buildingSubscribers.count
        tableView.backgroundView = count > 0 ? nil : noResultsView
        tableView.reloadData()
        setupCountLabel()
    }
    
    @IBAction func backTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

}

extension GroupMembersViewController {
    func inputValueChanged(_ input: INInputView, value: Any) {
        guard let searchText = value as? String else { return }

        groupMembersManager.searchText = searchText
    }
}

extension GroupMembersViewController: GroupMembersManagerDelegate {
    
    func didUpdateGroupMembers() {
        reloadData()
    }
    
}

extension GroupMembersViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return pendingBuildingSubscribers.count
        case 1:
            return buildingSubscribers.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeue(cell: PendingGroupMemberTableViewCell.self, for: indexPath)
            let buildingSubscriber = pendingBuildingSubscribers[indexPath.row]
            cell.configure(with: buildingSubscriber)
            cell.delegate = self
            return cell
        case 1:
            let cell = tableView.dequeue(cell: GroupMemberTableViewCell.self, for: indexPath)
            let buildingSubscriber = buildingSubscribers[indexPath.row]
            cell.configure(with: buildingSubscriber)
            cell.delegate = self
            return cell
        default:
            return UITableViewCell()
        }
    }
}

extension GroupMembersViewController: PendingGroupMemberTableViewCellDelegate {
    func pendingGroupMemberTableViewCellDidTapCancel(_ cell: PendingGroupMemberTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        let buildingSubscriber = pendingBuildingSubscribers[indexPath.row]
        deletePendingInvite(buildingSubscriber)
    }
}

// Delete Building Subscriber
extension GroupMembersViewController {
    
    private func confirmDeletePendingInvite(_ buildingSubscriber: BuildingSubscriber) {
        let format = NSLocalizedString("Are you sure you want to delete the invite for %@?", comment: "")
        let title = String.localizedStringWithFormat(format, buildingSubscriber.name)
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Delete", comment: ""), style: .destructive, handler: { (action) in
            self.deletePendingInvite(buildingSubscriber)
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func deletePendingInvite(_ buildingSubscriber: BuildingSubscriber) {
        showLoading(nil, showLoadingHUD: true)
        API.deleteBuildingSubscriber(buildingSubscriber.id, success: { [weak self] in
            self?.hideLoading()
            self?.didDeletePending(buildingSubscriber)
        }) { [weak self] (error) in
            self?.hideLoading()
        }
    }
    
    private func didDeletePending(_ buildingSubscriber: BuildingSubscriber) {
        groupMembersManager.deletePendingBuildingSubscriber(buildingSubscriber)
    }
}

extension GroupMembersViewController: GroupMemberTableViewCellDelegate {
    func groupMemberTableViewCellDidTapEdit(_ cell: GroupMemberTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell),
            let vc = Storyboard.groups.viewController(vc: GroupMemberEditViewController.self) else { return }
        
        let buildingSubscriber = buildingSubscribers[indexPath.row]
        vc.buildingSubscriber = buildingSubscriber
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func groupMemberTableViewCellDidTapLocate(_ cell: GroupMemberTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell),
            let vc = Storyboard.groups.viewController(vc: GroupMemberFindViewController.self) else { return }
        
        let buildingSubscriber = buildingSubscribers[indexPath.row]
        vc.buildingSubscriber = buildingSubscriber
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func groupMemberTableViewCellDidTapDelete(_ cell: GroupMemberTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        let buildingSubscriber = buildingSubscribers[indexPath.row]
        confirmDeleteSubscriber(buildingSubscriber)
    }
}

// Delete Building Subscriber
extension GroupMembersViewController {
    
    private func confirmDeleteSubscriber(_ buildingSubscriber: BuildingSubscriber) {
        let format = NSLocalizedString("Are you sure you want to delete %@?", comment: "")
        let title = String.localizedStringWithFormat(format, buildingSubscriber.name)
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Delete", comment: ""), style: .destructive, handler: { (action) in
            self.deleteSubscriber(buildingSubscriber)
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func deleteSubscriber(_ buildingSubscriber: BuildingSubscriber) {
        showLoading(nil, showLoadingHUD: true)
        API.deleteBuildingSubscriber(buildingSubscriber.id, success: { [weak self] in
            self?.hideLoading()
            self?.didDeleteSubscriber(buildingSubscriber)
        }) { [weak self] (error) in
            self?.hideLoading()
        }
    }
    
    private func didDeleteSubscriber(_ buildingSubscriber: BuildingSubscriber) {
        groupMembersManager.deleteBuildingSubscriber(buildingSubscriber)
    }
}
