//
//  ContactGroupsViewController.swift
//  Intelligent
//
//  Created by Kurt on 10/11/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit
import IntelligentKit

class ContactGroupsViewController: INViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchInputView: INInputView!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    override var inInputViews: [INInputView] {
        return [searchInputView]
    }
    
    private var contactGroupsManager: ContactGroupsManager!
    var buildings: [INBuilding] {
        return contactGroupsManager.contactableBuildings
    }
    
    override func viewDidLoad() {
        contactGroupsManager = ContactGroupsManager()
        contactGroupsManager.delegate = self
        
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }        
    }
    
    override func setupView() {
        super.setupView()

        titleLabel?.text = NSLocalizedString("Contact", comment: "")
        subTitleLabel.text = NSLocalizedString("Please select a group that you would like to contact", comment: "")

        searchInputView.textField?.placeholder = NSLocalizedString("Search for Group", comment: "")
        
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerNib(cell: BuildingTableViewCell.self)
    }
    
    private func toCall(_ building: INBuilding) {
        guard let vc = Storyboard.contact.viewController(vc: CallViewController.self) else { return }
        
        vc.building = building
        navigationController?.present(vc, animated: true, completion: nil)
    }
    
    private func toSendMessage(_ building: INBuilding) {
        guard let vc = Storyboard.contact.viewController(vc: SendMessageViewController.self) else { return }
        
        vc.building = building
        navigationController?.pushViewController(vc, animated: true)
    }

    override var shouldAutoResignInputViews: Bool {
        return false
    }
}

extension ContactGroupsViewController: ContactGroupsManagerDelegate {
    func didUpdateContactGroups() {
        tableView.reloadData()
    }
}

extension ContactGroupsViewController {
    func inputValueChanged(_ input: INInputView, value: Any) {
        guard let searchText = value as? String else { return }

        contactGroupsManager.searchText = searchText
    }
}

extension ContactGroupsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return buildings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(cell: BuildingTableViewCell.self, for: indexPath)
        let building = buildings[indexPath.row]
        cell.configure(with: building)
        cell.delegate = self
        return cell
    }

}

extension ContactGroupsViewController: BuildingTableViewCellDelegate {
    
    func buildingTableViewCellCallTapped(_ cell: BuildingTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let building = buildings[indexPath.row]

        toCall(building)
    }
    
    func buildingTableViewCellMessageTapped(_ cell: BuildingTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let building = buildings[indexPath.row]
        
        toSendMessage(building)
    }
    
}
