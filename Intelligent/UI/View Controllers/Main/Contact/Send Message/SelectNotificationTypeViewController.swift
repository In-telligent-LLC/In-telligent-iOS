//
//  SelectNotificationTypeViewController.swift
//  Intelligent
//
//  Created by Kurt Jensen on 10/25/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit
import IntelligentKit

protocol SelectNotificationTypeViewControllerDelegate: class {
    func selectNotificationTypeViewControllerDidSelect(_ vc: SelectNotificationTypeViewController, notificationType: NotificationType)
}

class SelectNotificationTypeViewController: INPopoverViewController {
    
    class func vc(notificationType: NotificationType?, notificationTypes: [NotificationType]) -> SelectNotificationTypeViewController {
        let vc = SelectNotificationTypeViewController()
        vc.selectedNotificationType = notificationType
        vc.notificationTypes = notificationTypes
        return vc
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.bounds)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.backgroundColor = UIColor.clear
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 44
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    override var preferredHeight: CGFloat {
        tableView.reloadData()
        return tableView.rowHeight*CGFloat(tableView.numberOfRows(inSection: 0))
    }
    
    private var notificationTypes: [NotificationType] = []
    private var selectedNotificationType: NotificationType?
    weak var delegate: SelectNotificationTypeViewControllerDelegate?
    
    override internal func setupView() {
        super.setupView()
        
        addTableView()
        
        tableView.reloadData()
    }
    
    private func addTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        view.leadingAnchor.constraint(equalTo: tableView.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: tableView.trailingAnchor).isActive = true
        view.topAnchor.constraint(equalTo: tableView.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: tableView.bottomAnchor).isActive = true
    }
    
}

extension SelectNotificationTypeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let notificationType = notificationTypes[indexPath.row]
        cell.textLabel?.text = notificationType.localizedString
        //cell.textLabel?.font = Style.Font.regular(ofSize: 17)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let notificationType = notificationTypes[indexPath.row]
        let isSelected = notificationType == selectedNotificationType
        cell.accessoryType = isSelected ? .checkmark: .none
        cell.textLabel?.textColor = isSelected ? Color.green: Color.darkGray
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let notificationType = notificationTypes[indexPath.row]
        delegate?.selectNotificationTypeViewControllerDidSelect(self, notificationType: notificationType)
    }
    
}
