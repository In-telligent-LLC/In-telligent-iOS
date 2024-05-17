//
//  InboxManager.swift
//  Intelligent
//
//  Created by Kurt Jensen on 11/14/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit
import IntelligentKit

protocol InboxManagerDelegate: class {
    func didUpdateInbox()
}

class PagedInbox: NSObject {
    var page: Int? = 0
    var notifications: [INNotification] = []
}

class InboxManager: NSObject {
    
    weak var delegate: (INViewController & InboxManagerDelegate)?
    
    var filter: NotificationFilter = .none { didSet { update() } }
    
    private var isFetching = false
    
    private var all = PagedInbox()
    private var unread = PagedInbox()
    private var savedNotifications: [INNotification] = []
    var notifications: [INNotification] {
        switch filter {
        case .none:
            return all.notifications
        case .saved:
            return savedNotifications
        case .unread:
            return unread.notifications
        }
    }
    
    override init() {
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reset), name: .resetInbox, object: nil)
    }
    
    public func update() {
        switch filter {
        case .none:
            if all.page == 0 {
                fetchNextAllPage()
            }
        case .saved:
            updateSavedIfNeeded()
        case .unread:
            if unread.page == 0 {
                fetchNextUnreadPage()
            }
        }
        delegate?.didUpdateInbox()
    }
    
    public func loadMore() {
        switch filter {
        case .none:
            fetchNextAllPage()
        case .unread:
            fetchNextUnreadPage()
        case .saved:
            break
        }
    }
    
    public func updateSavedIfNeeded() {
        if savedNotifications.count == 0 {
            fetchSaved()
        }
        delegate?.didUpdateInbox()
    }
    
    @objc private func reset() {
        all.notifications.removeAll()
        all.page = 0
        unread.notifications.removeAll()
        unread.page = 0
        savedNotifications.removeAll()
        update()
    }
    
    public func deleteNotification(_ notification: INNotification) {
        if let index = all.notifications.index(of: notification) {
            all.notifications.remove(at: index)
        }
        if let index = savedNotifications.index(of: notification) {
            savedNotifications.remove(at: index)
        }
        if let index = unread.notifications.index(of: notification) {
            unread.notifications.remove(at: index)
        }
        delegate?.didUpdateInbox() // just reload, don't mess with animations.
    }
}

//MARK: Fetch All
extension InboxManager {
    
    private func fetchNextAllPage() {
        guard !isFetching, let page = all.page else { return }
        isFetching = true
        
        delegate?.showLoading(nil, showLoadingHUD: true)
        API.getInbox(page, success: { [weak self] (notifications, hasMoreData) in
            self?.delegate?.hideLoading()
            self?.isFetching = false
            self?.didFetchAll(notifications, hasMoreData: hasMoreData, currentPage: page)
        }) { [weak self] (error) in
            self?.delegate?.hideLoading()
            self?.isFetching = false
            //self?.delegate?.showError(error)
        }
    }
    
    private func didFetchAll(_ notifications: [INNotification], hasMoreData: Bool, currentPage: Int) {
        self.all.notifications.append(contentsOf: notifications)

        if hasMoreData {
            all.page = currentPage + 1
        } else {
            all.page = nil
        }

        delegate?.didUpdateInbox()
    }
    
}

//MARK: Fetch Unread
extension InboxManager {
    
    private func fetchNextUnreadPage() {
        guard !isFetching, let page = unread.page else { return }
        isFetching = true
        
        delegate?.showLoading(nil, showLoadingHUD: true)
        API.getUnread(page, success: { [weak self] (notifications, hasMoreData) in
            self?.delegate?.hideLoading()
            self?.isFetching = false
            self?.didFetchUnread(notifications, hasMoreData: hasMoreData, currentPage: page)
        }) { [weak self] (error) in
            self?.isFetching = false
            self?.delegate?.hideLoading()
            //self?.delegate?.showError(error)
        }
    }
    
    private func didFetchUnread(_ notifications: [INNotification], hasMoreData: Bool, currentPage: Int) {
        self.unread.notifications = notifications
        
        if hasMoreData {
            unread.page = currentPage + 1
        } else {
            unread.page = nil
        }

        delegate?.didUpdateInbox()
    }
    
}

//MARK: Fetch Saved
extension InboxManager {

    private func fetchSaved() {
        delegate?.showLoading(nil, showLoadingHUD: true)
        API.getSaved({ [weak self] (notifications) in
            self?.delegate?.hideLoading()
            self?.didFetchSaved(notifications)
        }) { [weak self] (error) in
            self?.delegate?.hideLoading()
            //self?.delegate?.showError(error)
        }
    }
    
    private func didFetchSaved(_ notifications: [INNotification]) {
        self.savedNotifications = notifications
        delegate?.didUpdateInbox()
    }
    
}

extension InboxManager: InboxNotificationsDataSource, InboxNotificationsDelegate {
    func nextNotification(after notification: INNotification) -> INNotification? {
        guard let index = notifications.index(of: notification) else { return nil }
        return notifications[safe: index+1]
    }
    
    func previousNotification(before notification: INNotification) -> INNotification? {
        guard let index = notifications.index(of: notification) else { return nil }
        return notifications[safe: index-1]
    }
    
    func updateNotification(_ notification: INNotification, updater: (INNotification) -> Void) {
        let unread = self.unread.notifications.filter({ return $0.id == notification.id })
        let saved = self.savedNotifications.filter({ return $0.id == notification.id })
        let all = self.all.notifications.filter({ return $0.id == notification.id })
        (unread + saved + all).forEach(updater)
    }
    
    func didView(notification: INNotification) {
        guard !notification.isRead else { return }
        
        updateNotification(notification, updater: { $0.isRead = true })

        API.markOpened(notification, success: { [weak self] in
            self?.delegate?.didUpdateInbox()
            Logging.info("marked read: \(notification.id)")
        }) { (error) in
            Logging.error(error)
        }
    }
    
    func didToggleSave(notification: INNotification) {
        updateNotification(notification, updater: { $0.isSaved = notification.isSaved })
        
        savedNotifications = savedNotifications.filter({ return $0.isSaved })
        delegate?.didUpdateInbox()
    }
}
