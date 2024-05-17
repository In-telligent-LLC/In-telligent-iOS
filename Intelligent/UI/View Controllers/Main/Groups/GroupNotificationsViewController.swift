//
//  GroupNotificationsViewController.swift
//  Intelligent
//
//  Created by Kurt on 10/18/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit
import IntelligentKit

class GroupNotificationsViewController: INViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var building: Building!
    private var notifications: [INNotification] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchBuildingNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override internal func setupView() {
        super.setupView()
        
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.registerNib(cell: GroupNotificationTableViewCell.self)
        tableView.dataSource = self
        tableView.delegate = self
    }

    @IBAction func backTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}

//MARK: fetch building notifications
extension GroupNotificationsViewController {
    private func fetchBuildingNotifications() {
        API.getBuildingNotifications(building.id, success: { [weak self] (notifications) in
            self?.didFetchBuildingNotifications(notifications)
        }) { [weak self] (error) in
            self?.showError(error)
        }
    }
    private func didFetchBuildingNotifications(_ notifications: [INNotification]) {
        self.notifications = notifications
        tableView.reloadData()
    }
}

extension GroupNotificationsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(cell: GroupNotificationTableViewCell.self, for: indexPath)
        let notification = notifications[indexPath.row]
        cell.configure(with: notification)
        cell.delegate = self
        return cell
    }
    
}

extension GroupNotificationsViewController: GroupNotificationTableViewCellDelegate {
    func groupNotificationTableViewCellDidTapView(_ cell: GroupNotificationTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell),
            let vc = Storyboard.groups.viewController(vc: GroupInboxNotificationViewController.self) else { return }

        let notification = notifications[indexPath.row]
        vc.notification = notification
        navigationController?.pushViewController(vc, animated: true)
    }
}
