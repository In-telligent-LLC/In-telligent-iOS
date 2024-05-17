//
//  SelectDeliverToViewController.swift
//  Intelligent
//
//  Created by Kurt on 11/13/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit
import IntelligentKit

protocol SelectDeliverToViewControllerDelegate: class {
    func selectDeliverToViewControllerDidSelect(_ vc: SelectDeliverToViewController, deliverTo: DeliverTo)
}

class SelectDeliverToViewController: INPopoverViewController {
    
    class func vc(deliverTo: DeliverTo?) -> SelectDeliverToViewController {
        let vc = SelectDeliverToViewController()
        vc.selectedDeliverTo = deliverTo
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
    
    override var preferredWidth: CGFloat {
        return 300
    }
    
    private let deliverTos: [DeliverTo] = {
        return DeliverTo.allCases
    }()
    private var selectedDeliverTo: DeliverTo?
    weak var delegate: SelectDeliverToViewControllerDelegate?
    
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

extension SelectDeliverToViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deliverTos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let deliverTo = deliverTos[indexPath.row]
        cell.textLabel?.text = deliverTo.localizedString
        //cell.textLabel?.font = Style.Font.regular(ofSize: 17)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let deliverTo = deliverTos[indexPath.row]
        let isSelected = deliverTo == selectedDeliverTo
        cell.accessoryType = isSelected ? .checkmark: .none
        cell.textLabel?.textColor = isSelected ? Color.green: Color.darkGray
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let deliverTo = deliverTos[indexPath.row]
        delegate?.selectDeliverToViewControllerDidSelect(self, deliverTo: deliverTo)
    }
    
}
