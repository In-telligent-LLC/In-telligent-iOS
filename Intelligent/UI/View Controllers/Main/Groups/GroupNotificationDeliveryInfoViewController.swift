//
//  GroupNotificationDeliveryInfoViewController.swift
//  Intelligent
//
//  Created by Kurt on 10/19/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit
import IntelligentKit

class GroupNotificationDeliveryInfoViewController: INViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameTitleLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var deliveryOpenedLabel: UILabel!
    @IBOutlet weak var deliveryDeliveredLabel: UILabel!

    var notification: INNotification!
    
    private var notificationDeliveryInfo: NotificationDeliveryInfo? {
        didSet { setupCountLabel() }
    }
    private var subscriberInfos: [NotificationSubscriberDeliveryInfo] {
        return notificationDeliveryInfo?.subscriberInfos ?? []
    }

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
    
    override func setupView() {
        super.setupView()
                
        titleLabel?.text = notification.title
        nameTitleLabel.text = NSLocalizedString("Name:", comment: "")
        deliveryOpenedLabel.text = NSLocalizedString("Viewed:", comment: "")
        deliveryDeliveredLabel.text = NSLocalizedString("Received:", comment: "")
        countLabel.text = nil
        
        setupTableView()
    }
    
    private func setupCountLabel() {
        guard let notificationDeliveryInfo = notificationDeliveryInfo else { return }
        
        var texts: [String] = []
        let format = NSLocalizedString("Total Members (%d)", comment: "")
        texts.append(String.localizedStringWithFormat(format, notificationDeliveryInfo.totalCount))
        texts.append(String(format: "%@ %d", arguments: [NSLocalizedString("Received:", comment: ""), notificationDeliveryInfo.deliveredCount]))
        texts.append(String(format: "%@ %d", arguments: [NSLocalizedString("Viewed:", comment: ""), notificationDeliveryInfo.openedCount]))

        countLabel.text = texts.joined(separator: ", ")
    }
    
    private func setupTableView() {
        tableView.registerNib(cell: GroupNotificationDeliveryInfoTableViewCell.self)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @IBAction func backTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}

//MARK: fetch building notifications
extension GroupNotificationDeliveryInfoViewController {
    private func fetchBuildingNotifications() {
        guard let buildingId = notification.buildingId else { return }
        
        showLoading(nil, showLoadingHUD: true)
        API.getBuildingNotificationDeliveryInfo(buildingId, notificationId: notification.id, success: { [weak self] (notificationDeliveryInfo) in
            self?.hideLoading()
            self?.didFetchBuildingNotificationDeliveryInfo(notificationDeliveryInfo)
        }) { [weak self] (error) in
            self?.hideLoading()
            self?.showError(error)
        }
    }
    private func didFetchBuildingNotificationDeliveryInfo(_ notificationDeliveryInfo: NotificationDeliveryInfo) {
        self.notificationDeliveryInfo = notificationDeliveryInfo
        tableView.reloadData()
    }
}


extension GroupNotificationDeliveryInfoViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subscriberInfos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(cell: GroupNotificationDeliveryInfoTableViewCell.self, for: indexPath)
        let notificationDeliveryInfo = subscriberInfos[indexPath.row]
        cell.configure(with: notificationDeliveryInfo)
        return cell
    }
    
}
