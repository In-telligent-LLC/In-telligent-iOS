//
//  INTabBarController.swift
//  Intelligent
//
//  Created by Kurt Jensen on 10/8/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit
import SideMenu
import IntelligentKit

class INTabBarController: UITabBarController {

    private lazy var _tabBar: INTabBar = {
        let tabBar = INTabBar()
        tabBar.shadowColor = Color.darkGray
        tabBar.shadowOffset = CGSize(width: 0, height: 1)
        tabBar.shadowRadius = 4
        tabBar.shadowOpacity = 0.5
        tabBar.addTarget(self, action: #selector(trTabBarDidChangeSelection(_:)), for: .valueChanged)
        return tabBar
    }()
    
    var actualTabBarFrame: CGRect {
        var frame = tabBar.frame
        frame.size.height += 1 // hide the border
        frame.origin.y -= 1 // hide the border
        return frame
    }
    
    override var selectedIndex: Int {
        didSet {
            _tabBar.selectedIndex = selectedIndex
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupSideMenu()
        
        PushKitManager.shared.registerForPush()
        
        INLocationManager.start()
        INGeofencer.start()

        NotificationCenter.default.addObserver(self, selector: #selector(receivedPushNotification), name: .receivedPushNotification, object: nil)
    }
    
    private func checkSubscriber() {
        guard let subscriber = INSubscriber.current else { return }
        
        if !subscriber.isLightningConfirmed {
            let alert = UIAlertController(title: NSLocalizedString("Do you want to disable Audible Lightning Alerts", comment: ""),
                                          message: nil,
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("No", comment: ""), style: .default, handler: { action in
                API.setWeatherAlertSounds(isLightningEnabled: true, success: nil, failure: nil)
            }))
            alert.addAction(UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .destructive, handler: {
                action in
                API.setWeatherAlertSounds(isLightningEnabled: false, success: nil, failure: nil)
            }))
            present(alert, animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.bringSubviewToFront(_tabBar)
    }
    
    private func setupView() {
        addTabBar()
        
        _tabBar.configure(with: Tab.allCases)
    }
    
    private func setupSideMenu() {
        guard let vc = Storyboard.sideMenu.viewController(vc: SideMenuViewController.self) else { return }
        vc.delegate = self
        
        let nc = UISideMenuNavigationController(rootViewController: vc)
        nc.isNavigationBarHidden = true
        SideMenuManager.default.menuLeftNavigationController = nc
        SideMenuManager.default.menuFadeStatusBar = false
        SideMenuManager.default.menuPresentMode = .menuSlideIn
        SideMenuManager.default.menuWidth = view.frame.size.width - 60
        SideMenuManager.default.menuAddPanGestureToPresent(toView: view)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        _tabBar.frame = actualTabBarFrame
        view.bringSubviewToFront(_tabBar)
    }
    
    private func addTabBar() {
        _tabBar.frame = actualTabBarFrame
        view.insertSubview(_tabBar, aboveSubview: tabBar)
    }
    
    override func setViewControllers(_ viewControllers: [UIViewController]?, animated: Bool) {
        super.setViewControllers(viewControllers, animated: animated)
        
        _tabBar.configure(with: Tab.allCases)
    }
    
    @objc func trTabBarDidChangeSelection(_ tabBar: INTabBar) {
        guard let selectedIndex = tabBar.selectedIndex else { return }
        
        if self.selectedIndex != selectedIndex {
            self.selectedIndex = selectedIndex
        } else if let nc = selectedViewController as? UINavigationController {
            nc.popToRootViewController(animated: true)
        }
    }
    
    private var notificationPopup: NotificationPopup?
    @objc func receivedPushNotification(_ notification: Foundation.Notification) {
        NotificationCenter.default.post(name: .resetInbox, object: nil)
        notificationPopup = NotificationPopup(notification: notification, delegate: self)
    }

}

extension INTabBarController {
    
    func toSendMessage(_ building: INBuilding) {
        guard let vc = Storyboard.contact.viewController(vc: SendMessageViewController.self),
            let nc = viewControllers?[safe: 1] as? UINavigationController,
            let rootVC = nc.viewControllers.first else { return }
        
        vc.building = building
        nc.setViewControllers([rootVC, vc], animated: true)
        selectedIndex = 1
    }
    
    func toCall(_ building: INBuilding) {
        guard let vc = Storyboard.contact.viewController(vc: CallViewController.self),
            let nc = viewControllers?[safe: 1] as? UINavigationController else { return }
        
        vc.building = building
        nc.present(vc, animated: true, completion: nil)
    }
    
    func toNotification(_ notification: INNotification) {
        guard let vc = Storyboard.inbox.viewController(vc: InboxNotificationViewController.self),
            let nc = viewControllers?[safe: 2] as? UINavigationController,
            let inboxVC = nc.viewControllers.first as? InboxViewController else { return }
        
        vc.notification = notification
        nc.setViewControllers([inboxVC, vc], animated: true)
        selectedIndex = 2
    }
    
    func toSavedMessages() {
        guard let nc = viewControllers?[safe: 2] as? UINavigationController,
            let inboxVC = nc.viewControllers.first as? InboxViewController else { return }
        
        inboxVC.changeFilter(.saved)
        nc.setViewControllers([inboxVC], animated: true)
        selectedIndex = 2
    }
    
    func toCreateGroup() {
        guard let vc = Storyboard.groups.viewController(vc: GroupEditViewController.self),
            let nc = viewControllers?[safe: 0] as? UINavigationController,
            let rootVC = nc.viewControllers.first else { return }
        
        nc.setViewControllers([rootVC, vc], animated: true)
        selectedIndex = 0
    }
}


extension INTabBarController: NotificationPopupDelegate, NotificationPopupViewControllerDelegate {
    func presentAlert(vc: UIViewController) {
        guard presentedViewController == nil else {
            dismiss(animated: false) {
                self.presentAlert(vc: vc)
            }
            return
        }
        
        present(vc, animated: true, completion: nil)
    }
    func notificationPopupDidTapView(_ notification: INNotification, isPersonalSafety: Bool) {
        guard isPersonalSafety else {
            toNotification(notification)
            return
        }
        
        let vc = Storyboard.notification.viewController(vc: NotificationPersonalSafetyPopupViewController.self)!
        
        vc.notification = notification
        vc.delegate = self
        let nc = UINavigationController(rootViewController: vc)
        nc.isNavigationBarHidden = true
        present(nc, animated: true, completion: nil)
    }
    
    func notificationPopupViewControllerDidTapCallCommunityManager(_ notification: INNotification) {
        guard let building = notification.getBuilding() else { return }
        
        toCall(building)
    }
}

extension INTabBarController: SideMenuViewControllerDelegate {
    func sideMenuViewControllerDidTapSettings(_ vc: SideMenuViewController) {
        guard let vc = Storyboard.sideMenu.viewController(vc: SettingsViewController.self) else { return }
        
        let nc = UINavigationController(rootViewController: vc)
        present(nc, animated: true, completion: nil)
    }
    
    func sideMenuViewControllerDidTapCreateAGroup(_ vc: SideMenuViewController) {
        toCreateGroup()
    }
    
    func sideMenuViewControllerDidTapSavedMessages(_ vc: SideMenuViewController) {
        toSavedMessages()
    }
}

extension UIViewController {
    var inTabBarController: INTabBarController? {
        return tabBarController as? INTabBarController
    }
}
