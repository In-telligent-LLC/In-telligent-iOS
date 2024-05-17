//
//  GroupMembersManager.swift
//  Intelligent
//
//  Created by Kurt Jensen on 2/12/19.
//  Copyright © 2019 Kurt Jensen. All rights reserved.
//

import UIKit
import IntelligentKit

protocol GroupMembersManagerDelegate: class {
    func didUpdateGroupMembers()
}

class GroupMembersManager: NSObject {
    
    weak var delegate: (INViewController & GroupMembersManagerDelegate)?
    
    var searchText: String? { didSet { filterGroupMembers() } }
    
    private var pendingBuildingSubscribers: [BuildingSubscriber] = []
    private var buildingSubscribers: [BuildingSubscriber] = []

    var filteredPendingBuildingSubscribers: [BuildingSubscriber] = []
    var filteredBuildingSubscribers: [BuildingSubscriber] = []
    
    let building: Building
    
    init(_ building: Building) {
        self.building = building
        super.init()
    }
    
    public func update() {
        fetchBuildingSubscriberInvites()
    }
}

extension GroupMembersManager {
    
    public func deletePendingBuildingSubscriber(_ buildingSubscriber: BuildingSubscriber) {
        if let index = pendingBuildingSubscribers.index(of: buildingSubscriber) {
            pendingBuildingSubscribers.remove(at: index)
            filterGroupMembers()
        }
    }
    
    public func deleteBuildingSubscriber(_ buildingSubscriber: BuildingSubscriber) {
        if let index = buildingSubscribers.index(of: buildingSubscriber) {
            buildingSubscribers.remove(at: index)
            filterGroupMembers()
        }
    }
}

//MARK: Fetch Building Subscribers
extension GroupMembersManager {
    
    private func fetchBuildingSubscriberInvites() {
        delegate?.showLoading(nil, showLoadingHUD: true)
        API.getBuildingSubscriberInvites(building, success: { [weak self] (subscribers) in
            self?.delegate?.hideLoading()
            self?.didFetchSubscribers(subscribers)
            }, failure: { [weak self] (error) in
                self?.delegate?.hideLoading()
                self?.delegate?.showError(error)
        })
    }
    
    private func didFetchSubscribers(_ subscribers: [BuildingSubscriber]) {
        var pendingBuildingSubscribers: [BuildingSubscriber] = []
        var buildingSubscribers: [BuildingSubscriber] = []
        for subscriber in subscribers {
            switch subscriber.status {
            case .pending:
                pendingBuildingSubscribers.append(subscriber)
            default:
                buildingSubscribers.append(subscriber)
            }
        }
        
        self.pendingBuildingSubscribers = pendingBuildingSubscribers
        self.buildingSubscribers = buildingSubscribers
        self.filterGroupMembers()
    }
    
    private func filterGroupMembers() {
        if let searchText = searchText, searchText.count > 0 {
            filteredPendingBuildingSubscribers = pendingBuildingSubscribers.filter({ return $0.email?.contains(searchText) == true })
            filteredBuildingSubscribers = buildingSubscribers.filter({ return $0.email?.contains(searchText) == true })
        } else {
            filteredPendingBuildingSubscribers = pendingBuildingSubscribers
            filteredBuildingSubscribers = buildingSubscribers
        }
        delegate?.didUpdateGroupMembers()
    }
}
