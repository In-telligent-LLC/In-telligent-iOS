//
//  INSubscriberManager.swift
//  Intelligent
//
//  Created by Kurt on 10/4/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import RealmSwift

public protocol INSubscriberManagerDelegate: class {
    func currentSubscriberDidChange(_ manager: INSubscriberManager, isLoggedIn: Bool)
}

public class INSubscriberManager {
    
    static public let shared: INSubscriberManager = INSubscriberManager()
    
    class public func login(_ token: String, success: @escaping API.APIResponseSuccessVoidHandler, failure: @escaping API.APIResponseFailureHandler) {
        shared.startLogin(token, success: success, failure: failure)
    }
    
    class public func updateCurrentSubscriber(_ subscriber: INSubscriber) {
        shared.updateCurrentSubscriber(subscriber)
    }
    
    class public func logOut() {
        shared.logOut()
    }
    
    static public var currentSubscriber: INSubscriber? {
        return shared.currentSubscriber
    }
    
    public var currentSubscriber: INSubscriber? {
        return subscribers?.first
    }
    
    static public var isLoggedIn: Bool {
        return shared.isLoggedIn
    }
    
    public var isLoggedIn: Bool {
        guard let subscribers = subscribers else { return false }
        return subscribers.count > 0 && INSessionManager.token != nil
    }
    
    private (set)var subscribers: Results<INSubscriber>?
    private var notificationToken: NotificationToken?
    
    private weak var delegate: INSubscriberManagerDelegate?
    
    public func start(_ delegate: INSubscriberManagerDelegate) {
        self.delegate = delegate
        setupNotificationToken()
    }
    
    private func setupNotificationToken() {
        notificationToken?.invalidate()
        let realm = try? Realm()
        subscribers = realm?.objects(INSubscriber.self)
        notificationToken = subscribers?.observe({ [weak self] (changes) in
            guard let strongSelf = self else { return }
            
            //let subscriber = strongSelf.subscribers?.first
            switch changes {
            case .initial(_):
                strongSelf.delegate?.currentSubscriberDidChange(strongSelf, isLoggedIn: strongSelf.isLoggedIn)
            case .update(_, deletions: let deletions, insertions: let insertions, modifications: _):
                if insertions.count > 0 || deletions.count > 0 {
                    strongSelf.delegate?.currentSubscriberDidChange(strongSelf, isLoggedIn: strongSelf.isLoggedIn)
                }
            case .error(let error):
                Logging.info(error)
            }
        })
    }
}

extension INSubscriberManager {
    private func startLogin(_ token: String, success: @escaping API.APIResponseSuccessVoidHandler, failure: @escaping API.APIResponseFailureHandler) {
        API.loginCurrentSubscriber(token, success: { (subscriber) in
            self.finishLogin(subscriber, token: token)
            success()
        }, failure: failure)
    }
    
    private func finishLogin(_ subscriber: INSubscriber, token: String) {
        logIn(subscriber, token: token)
    }
    
    private func logIn(_ subscriber: INSubscriber, token: String) {
        logOut()
        
        INSessionManager.token = token
        Realm.write { (realm) in
            realm.add(subscriber, update: .all)
        }
    }
    
    private func updateCurrentSubscriber(_ subscriber: INSubscriber) {
        Realm.write { (realm) in
            realm.add(subscriber, update: .all)
        }
    }
    
    private func logOut() {
        INSessionManager.token = nil
        Realm.write { (realm) in
            realm.deleteAll()
        }
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
}
