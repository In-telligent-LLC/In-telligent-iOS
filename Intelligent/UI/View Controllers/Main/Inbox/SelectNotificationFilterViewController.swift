//
//  SelectNotificationFilterViewController.swift
//  Intelligent
//
//  Created by Kurt Jensen on 10/5/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit
import IntelligentKit

protocol SelectNotificationFilterViewControllerDelegate: class {
    func selectNotificationFilterViewControllerDidSelect(_ vc: SelectNotificationFilterViewController, filter: NotificationFilter)
}

class SelectNotificationFilterViewController: INPopoverViewController {
    
    class func vc(filter: NotificationFilter) -> SelectNotificationFilterViewController {
        let vc = SelectNotificationFilterViewController()
        vc.selectedFilter = filter
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
    
    private let filters: [NotificationFilter] = {
        return NotificationFilter.allCases
    }()
    private var selectedFilter: NotificationFilter?
    weak var delegate: SelectNotificationFilterViewControllerDelegate?
    
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

extension SelectNotificationFilterViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let filter = filters[indexPath.row]
        cell.textLabel?.text = filter.localizedString
        //cell.textLabel?.font = Style.Font.regular(ofSize: 17)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let filter = filters[indexPath.row]
        let isSelected = filter == selectedFilter
        cell.accessoryType = isSelected ? .checkmark: .none
        cell.textLabel?.textColor = isSelected ? Color.green: Color.darkGray
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let filter = filters[indexPath.row]
        delegate?.selectNotificationFilterViewControllerDidSelect(self, filter: filter)
    }
    
}
