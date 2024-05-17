//
//  SelectSendToViewController.swift
//  Intelligent
//
//  Created by Kurt on 11/13/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit
import IntelligentKit

protocol SelectSendToViewControllerDelegate: class {
    func selectSendToViewControllerDidSelect(_ vc: SelectSendToViewController, sendTo: SendTo)
}

class SelectSendToViewController: INPopoverViewController {
    
    class func vc(sendTo: SendTo?) -> SelectSendToViewController {
        let vc = SelectSendToViewController()
        vc.selectedSendTo = sendTo
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
        return 260
    }
    
    private let sendTos: [SendTo] = {
        return SendTo.allCases
    }()
    private var selectedSendTo: SendTo?
    weak var delegate: SelectSendToViewControllerDelegate?
    
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

extension SelectSendToViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sendTos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let sendTo = sendTos[indexPath.row]
        cell.textLabel?.text = sendTo.localizedString
        //cell.textLabel?.font = Style.Font.regular(ofSize: 17)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let sendTo = sendTos[indexPath.row]
        let isSelected = sendTo == selectedSendTo
        cell.accessoryType = isSelected ? .checkmark: .none
        cell.textLabel?.textColor = isSelected ? Color.green: Color.darkGray
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sendTo = sendTos[indexPath.row]
        delegate?.selectSendToViewControllerDidSelect(self, sendTo: sendTo)
    }
    
}
