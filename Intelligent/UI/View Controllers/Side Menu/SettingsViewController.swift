//
//  SettingsViewController.swift
//  Intelligent
//
//  Created by Kurt Jensen on 10/31/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit
import IntelligentKit

class SettingsViewController: INViewController {
    
    enum Tab: Int, CaseIterable {
        case notifications, account, support
        
        var localizedString: String {
            switch self {
            case .notifications: return NSLocalizedString("Notifications", comment: "")
            case .account: return NSLocalizedString("Account", comment: "")
            case .support: return NSLocalizedString("Support", comment: "")
            }
        }
    }
    
    var currentTab = 0 {
        didSet {
            tabSegmentedControl.selectedSegmentIndex = currentTab
        }
    }
    
    @IBOutlet weak var tabSegmentedControl: UISegmentedControl!

    // notifications
    @IBOutlet weak var notificationsTableView: UITableView!
    @IBOutlet var severeWeatherView: SevereWeatherSubscriptionView!
    
    // account
    @IBOutlet weak var accountInfoTitleLabel: UILabel!
    @IBOutlet weak var accountNameTitleLabel: UILabel!
    @IBOutlet weak var accountNameLabel: UILabel!
    @IBOutlet weak var accountEmailTitleLabel: UILabel!
    @IBOutlet weak var accountEmailLabel: UILabel!
    @IBOutlet weak var accountLanguageTitleLabel: UILabel!
    @IBOutlet weak var accountLanguageButton: INLoadingButton!

    // support
    @IBOutlet weak var supportTitleLabel: UILabel!
    @IBOutlet weak var sendSupportRequestButton: INLoadingButton!
    @IBOutlet weak var supportRequestTextView: INTextView!
    @IBOutlet weak var supportPhoneButton: INButton!
    @IBOutlet weak var supportAvailabilityLabel: UILabel!
    @IBOutlet weak var supportEmailButton: INButton!
    
    @IBOutlet weak var generalSupportTitleLabel: UILabel!
    @IBOutlet weak var generalSupportPhoneNumberTitleLabel: UILabel!
    @IBOutlet weak var generalSupportHoursTitleLabel: UILabel!
    @IBOutlet weak var generalSupportEmailTitleLabel: UILabel!
    
    override var loadableViews: [UIView] {
        return [
            accountLanguageButton,
            sendSupportRequestButton,
            supportPhoneButton,
            supportEmailButton
        ]
    }

    lazy var closeBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(title: NSLocalizedString("Close", comment: ""), style: .plain, target: self, action: #selector(closeTapped(_:)))
    }()
    
    lazy var logOutBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(title: NSLocalizedString("Log Out", comment: ""), style: .plain, target: self, action: #selector(logOutTapped(_:)))
    }()
    
    private var buildingSubscriptionsManager: BuildingSubscriptionsManager!
    var buildings: [INBuilding] {
        return buildingSubscriptionsManager.buildings
    }
    
    override func viewDidLoad() {
        buildingSubscriptionsManager = BuildingSubscriptionsManager()
        buildingSubscriptionsManager.delegate = self
        
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        updateSevereWeatherAlertsIfNeeded()
    }

    override internal func setupView() {
        super.setupView()
        
        navigationItem.leftBarButtonItem = closeBarButtonItem
        navigationItem.title = NSLocalizedString("Settings", comment: "")
        navigationItem.rightBarButtonItem = logOutBarButtonItem
        
        severeWeatherView.delegate = self
        notificationsTableView.tableHeaderView = nil
        
        setupTabControl()
        setupNotifications()
        setupAccount()
        setupSupport()
        
        keyboardScrollView?.delegate = self
    }

    private func setupTabControl() {
        let segmentedControlAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16),
        ]
        for state in UIControl.State.all {
            tabSegmentedControl.setTitleTextAttributes(segmentedControlAttributes, for: state)
        }
        for (i, state) in Tab.allCases.enumerated() {
            tabSegmentedControl.setTitle(state.localizedString, forSegmentAt: i)
        }
        tabSegmentedControl.tintColor = Color.blue
    }
    
    private func setupNotifications() {
        notificationsTableView.registerNib(cell: BuildingSubscriptionSettingTableViewCell.self)
        notificationsTableView.dataSource = self
    }
    
    private func setupAccount() {
        accountInfoTitleLabel.text = NSLocalizedString("My Info", comment: "")
        accountNameTitleLabel.text = NSLocalizedString("NAME", comment: "")
        accountEmailTitleLabel.text = NSLocalizedString("EMAIL", comment: "")
        accountLanguageTitleLabel.text = NSLocalizedString("ALERT LANGUAGE", comment: "")

        let subscriber = INSubscriber.current
        accountNameLabel.text = subscriber?.name
        accountEmailLabel.text = subscriber?.email
        accountLanguageButton.setTitle(subscriber?.languageName, for: .normal)
    }
    
    private func setupSupport() {
        supportTitleLabel.text = NSLocalizedString("Support", comment: "")
        sendSupportRequestButton.title = NSLocalizedString("SEND", comment: "")
        generalSupportTitleLabel.text = NSLocalizedString("General Inquires on In-telligent", comment: "")
        
        generalSupportHoursTitleLabel.text = NSLocalizedString("Hours", comment: "")
        generalSupportEmailTitleLabel.text = NSLocalizedString("Email", comment: "")
        generalSupportPhoneNumberTitleLabel.text = NSLocalizedString("Phone Number", comment: "")

        supportPhoneButton.setTitle(Constants.Support.phoneNumber, for: .normal)
        supportEmailButton.setTitle(Constants.Support.email, for: .normal)
        supportAvailabilityLabel.text = Constants.Support.availability
    }
    
    @objc func closeTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func logOutTapped(_ sender: UIBarButtonItem) {
        let title = NSLocalizedString("Are you sure?", comment: "")
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Log Out", comment: ""), style: .destructive, handler: { (action) in
            INSubscriberManager.logOut()
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    @IBAction func tabSegmentedControlDidChange(_ sender: UISegmentedControl) {
        guard let scrollView = keyboardScrollView else { return }
        
        currentTab = sender.selectedSegmentIndex
        let offsetX = CGFloat(currentTab)*scrollView.bounds.width
        scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }
}

//MARK: Change Language
extension SettingsViewController {
    
    @IBAction func changeLanguageTapped(_ sender: Any) {
        showLoading(accountLanguageButton)
        LanguageManager.getLanguages({ [weak self] (languages) in
            self?.hideLoading()
            self?.promptChangeLanguage(languages)
        }) { [weak self] (error) in
            self?.hideLoading()
            self?.showError(error)
        }
    }
    
    private func promptChangeLanguage(_ languages: [Language]) {
        let title = NSLocalizedString("Translate to:", comment: "")
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        alert.popoverPresentationController?.sourceView = accountLanguageButton
        for language in languages {
            alert.addAction(UIAlertAction(title: language.name, style: .default, handler: { (action) in
                self.changeLanguage(to: language)
            }))
        }
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func changeLanguage(to language: Language) {
        showLoading(accountLanguageButton)
        API.changeMyLanguage(to: language, success: { [weak self] in
            self?.hideLoading()
            self?.setupAccount()
            NotificationCenter.default.post(name: .resetInbox, object: nil)
        }) { [weak self] (error) in
            self?.hideLoading()
            self?.showError(error)
        }
    }
    
}

//MARK: Support
extension SettingsViewController {

    private func validateRequest() throws -> SupportRequest {
        guard let message = supportRequestTextView.text, !message.isEmpty else {
            throw INError(message: NSLocalizedString("Please input a valid message", comment: ""))
        }
        return SupportRequest(message: message)
    }
    
    @IBAction func submitSupportRequestTapped(_ sender: Any) {
        do {
            let request = try validateRequest()
            showLoading(sendSupportRequestButton)
            API.submitSupportRequest(request, success: { [weak self] () in
                self?.hideLoading()
                self?.didSubmitSupportRequest()
            }) { [weak self] (error) in
                self?.hideLoading()
                self?.showError(error)
            }
        } catch {
            self.showError(error)
        }
    }
    
    private func didSubmitSupportRequest() {
        supportRequestTextView.text = ""
        supportRequestTextView.resignFirstResponder()
        showAlert(NSLocalizedString("Request Submitted", comment: ""), message: nil)
    }
    
    @IBAction func phoneTapped(_ sender: Any) {
        if let url = URL(string: "tel://\(Constants.Support.phoneNumber)") {
            showURL(url)
        }
    }
    
    @IBAction func emailTapped(_ sender: Any) {
        sendEmail(to: Constants.Support.email)
    }

}

extension SettingsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = scrollView.currentHorizontalPage
        if page != currentTab {
            currentTab = page
        }
        supportRequestTextView.resignFirstResponder()
    }
}

//MARK: Notifications
extension SettingsViewController: BuildingSubscriptionsManagerDelegate {
    
    func didUpdateBuildingSubscriptions() {
        if let building = buildingSubscriptionsManager.severeWeatherBuilding {
            severeWeatherView.configure(with: building)
            notificationsTableView.tableHeaderView = severeWeatherView
        } else {
            notificationsTableView.tableHeaderView = nil
        }
        notificationsTableView.reloadData()
    }
}

extension SettingsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return buildings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let building = buildings[indexPath.row]
        let cell = tableView.dequeue(cell: BuildingSubscriptionSettingTableViewCell.self, for: indexPath)
        cell.delegate = self
        cell.configure(with: building)
        return cell
    }
    
}

//MAARK: Severe Weather
extension SettingsViewController: SevereWeatherSubscriptionViewDelegate {
    
    private func updateSevereWeatherAlertsIfNeeded() {
        let alertChanges = severeWeatherView.alertChanges
        guard alertChanges.isLightningEnabled != nil || alertChanges.isWeatherEnabled != nil else { return }
        API.setWeatherAlertSounds(isWeatherEnabled: alertChanges.isWeatherEnabled, isLightningEnabled: alertChanges.isLightningEnabled, success: {
            //
        }) { [weak self] (error) in
            self?.showError(error)
        }
    }
    
    func severeWeatherSubscriptionViewChangedSubscription(_ building: INBuilding, subscription: Subscription) {
        updateBuildingAlertSubscription(building, subscription: subscription)
    }
    
    private func updateBuildingAlertSubscription(_ building: INBuilding, subscription: Subscription) {
        showLoading(nil)
        let request = UpdateBuildingAlertSubscriptionRequest(building: building, subscription: subscription)
        API.updateBuildingAlertSubscription(request, success: { [weak self] in
            self?.hideLoading()
        }) { [weak self] (error) in
            self?.hideLoading()
            self?.showError(error)
        }
    }
}

extension SettingsViewController: BuildingSubscriptionSettingTableViewCellDelegate {
    
    func notificationSettingWeatherTableViewCellChangedSubscription(_ cell: BuildingSubscriptionSettingTableViewCell, subscription: Subscription) {
        guard let indexPath = notificationsTableView.indexPath(for: cell) else { return }
        
        let building = buildings[indexPath.row]
        updateBuildingAlertSubscription(building, subscription: subscription)
    }
}
