//
//  InboxViewController.swift
//  Intelligent
//
//  Created by Kurt on 10/4/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit
import IntelligentKit

class InboxViewController: INViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    lazy var notificationFilterView: NotificationFilterView = {
        let view = NotificationFilterView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 44))
        view.delegate = self
        return view
    }()

    private var inboxManager: InboxManager!
    var notifications: [INNotification] {
        return inboxManager.notifications
    }
    
    override func viewDidLoad() {
        inboxManager = InboxManager()
        inboxManager.delegate = self
        
        super.viewDidLoad()
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
        changeFilter(.none)
    }
    
    private func setupTableView() {
        tableView.registerNib(cell: NotificationTableViewCell.self)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    public func changeFilter(_ filter: NotificationFilter) {
        guard isViewLoaded else { return }
        
        inboxManager.filter = filter
        
        if notificationFilterView.filter != filter {
            notificationFilterView.filter = filter
        }
    }
    
    private func didScrollToBottom() {
        inboxManager.loadMore()
    }
    
    private func toNotification(_ notification: INNotification) {
        guard let vc = Storyboard.inbox.viewController(vc: InboxNotificationViewController.self) else { return }
        
        vc.notification = notification
        vc.dataSource = inboxManager
        vc.delegate = inboxManager
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension InboxViewController: NotificationFilterViewDelegate {
    func didChangeFilter(_ view: NotificationFilterView, filter: NotificationFilter) {
        changeFilter(filter)
    }
}

extension InboxViewController: InboxManagerDelegate {
    func didUpdateInbox() {
        tableView.reloadData()
    }
}

extension InboxViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return notificationFilterView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return notificationFilterView.bounds.height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(cell: NotificationTableViewCell.self, for: indexPath)
        let notification = notifications[indexPath.row]
        cell.configure(with: notification)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let notification = notifications[indexPath.row]
        toNotification(notification)
    }
    
}

extension InboxViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height {
            didScrollToBottom()
        }
    }
}

extension InboxViewController: NotificationTableViewCellDelegate {
    
    func notificationTableViewCellDidTapView(_ cell: NotificationTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        let notification = notifications[indexPath.row]
        toNotification(notification)
    }
    
    func notificationTableViewCellDidTapDelete(_ cell: NotificationTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let notification = notifications[indexPath.row]

        promptDeleteNotification(notification, sender: cell.deleteButton)
    }

    private func promptDeleteNotification(_ notification: INNotification, sender: UIView) {
        let title = NSLocalizedString("Delete Notification", comment: "")
        let message = NSLocalizedString("Are you sure?", comment: "")
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        alert.popoverPresentationController?.sourceView = sender
        
        let deleteAction = UIAlertAction(title: NSLocalizedString("Delete", comment: ""), style: .destructive) { (action) in
            self.deleteNotification(notification)
        }
        alert.addAction(deleteAction)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    private func deleteNotification(_ notification: INNotification) {
        API.deleteNotification(notification, success: { [weak self] in
            self?.didDeleteNotification(notification)
        }) { [weak self] (error) in
            self?.showError(error)
        }
    }
    
    private func didDeleteNotification(_ notification: INNotification) {
        inboxManager.deleteNotification(notification)
    }
    
}
