//
//  SelectBuildingSubscribersViewController.swift
//  Intelligent
//
//  Created by Kurt on 11/13/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit
import IntelligentKit

protocol SelectBuildingSubscribersViewControllerDelegate: class {
    func selectBuildingSubscribersViewControllerDidSelect(_ vc: SelectBuildingSubscribersViewController, buildingSubscribers: [BuildingSubscriber])
}

class SelectBuildingSubscribersViewController: INViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var searchInputView: INInputView!
    @IBOutlet weak var countLabel: UILabel!

    lazy var closeBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(title: NSLocalizedString("Cancel", comment: ""), style: .plain, target: self, action: #selector(closeTapped(_:)))
    }()
    
    lazy var doneBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(title: NSLocalizedString("Done", comment: ""), style: .done, target: self, action: #selector(doneTapped(_:)))
    }()
    
    lazy var noResultsView: INNoResultsView = {
        let view = INNoResultsView()
        view.configure(
            image: UIImage(named: "icon_tab_contact"),
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
        
    var building: INBuilding!
    
    private var buildingSubscribersManager: BuildingSubscribersManager!
    var selectedBuildingSubscribers: [BuildingSubscriber] = [] {
        didSet {
            setupCountLabel()
            doneBarButtonItem.isEnabled = selectedBuildingSubscribers.count > 0
        }
    }
    private var buildingSubscribers: [BuildingSubscriber] {
        return buildingSubscribersManager.filteredBuildingSubscribers
    }
    
    weak var delegate: SelectBuildingSubscribersViewControllerDelegate?
    
    override func viewDidLoad() {
        buildingSubscribersManager = BuildingSubscribersManager(building)
        buildingSubscribersManager.delegate = self
        
        super.viewDidLoad()
        
        buildingSubscribersManager.update()
    }
    
    override internal func setupView() {
        super.setupView()
        
        view.backgroundColor = .white
        
        navigationItem.title = NSLocalizedString("Specify Subscribers", comment: "")
        navigationItem.leftBarButtonItem = closeBarButtonItem
        navigationItem.rightBarButtonItem = doneBarButtonItem
        
        searchInputView.textField?.placeholder = NSLocalizedString("Search for Members", comment: "")
        subTitleLabel.text = NSLocalizedString("Please select the group members that you would like to contact", comment: "")
        setupCountLabel()
        
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.separatorColor = Color.lightGray
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setupCountLabel() {
        guard isViewLoaded else { return }
        
        if selectedBuildingSubscribers.count > 0 {
            let format = NSLocalizedString("Selected Members (%d)", comment: "")
            countLabel.text = String.localizedStringWithFormat(format, selectedBuildingSubscribers.count)
        } else {
            countLabel.text = nil
        }
    }
    
    private func reloadData() {
        // don't call this in setup, only after data has tried to load and finished or errored
        tableView.backgroundView = buildingSubscribers.count > 0 ? nil : noResultsView
        tableView.reloadData()
    }
    
    @objc func closeTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func doneTapped(_ sender: UIBarButtonItem) {
        delegate?.selectBuildingSubscribersViewControllerDidSelect(self, buildingSubscribers: selectedBuildingSubscribers)
        dismiss(animated: true, completion: nil)
    }
    
}

extension SelectBuildingSubscribersViewController {
    func inputValueChanged(_ input: INInputView, value: Any) {
        guard let searchText = value as? String else { return }
        
        buildingSubscribersManager.searchText = searchText
    }
}

extension SelectBuildingSubscribersViewController: BuildingSubscribersManagerDelegate {
    func didUpdateGroupMembers() {
        reloadData()
    }
}

extension SelectBuildingSubscribersViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return buildingSubscribers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let buildingSubscriber = buildingSubscribers[indexPath.row]
        cell.textLabel?.text = buildingSubscriber.name
        //cell.textLabel?.font = Style.Font.regular(ofSize: 17)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let buildingSubscriber = buildingSubscribers[indexPath.row]
        let isSelected = selectedBuildingSubscribers.contains(buildingSubscriber)
        cell.accessoryType = isSelected ? .checkmark: .none
        cell.textLabel?.textColor = isSelected ? Color.green: Color.darkGray
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let buildingSubscriber = buildingSubscribers[indexPath.row]
        if let index = selectedBuildingSubscribers.index(of: buildingSubscriber) {
            selectedBuildingSubscribers.remove(at: index)
        } else {
            selectedBuildingSubscribers.append(buildingSubscriber)
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
}
