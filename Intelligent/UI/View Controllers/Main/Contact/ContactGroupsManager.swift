//
//  ContactGroupsManager.swift
//  Intelligent
//
//  Created by Kurt Jensen on 11/14/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import Foundation
import RealmSwift
import IntelligentKit

protocol ContactGroupsManagerDelegate: class {
    func didUpdateContactGroups()
}

class ContactGroupsManager: NSObject {
    
    weak var delegate: (INViewController & ContactGroupsManagerDelegate)?
    
    var searchText: String? { didSet { configureToken() } }
    
    private var contactableBuildingResults: Results<INBuilding>?
    private (set)var contactableBuildings: [INBuilding] = []
    
    private var token: NotificationToken?
    override init() {
        super.init()
        
        configureToken()
    }
    
    private func configureToken() {
        token?.invalidate()
        
        contactableBuildingResults = INSubscriber.current?.myBuildings
            .filter("(isManagedByCurrentUser = %@ AND isPersonal = %@) OR isPersonal = %@", true, true, false)
            .sorted(byKeyPath: "name")
        if let searchText = searchText, !searchText.isEmpty {
            contactableBuildingResults = contactableBuildingResults?.filter("name CONTAINS[c] %@", searchText)
        }
        
        token = contactableBuildingResults?.observe({ [weak self] (change) in
            guard let strongSelf = self,
                let results = strongSelf.contactableBuildingResults else { return }
            
            strongSelf.didUpdateContactableBuildings(Array(results))
        })
    }
}

//MARK: Fetch Buildings
extension ContactGroupsManager {

    private func didUpdateContactableBuildings(_ buildings: [INBuilding]) {
        self.contactableBuildings = buildings.filter({ return $0.availableContactActions.count > 0 })
        Logging.info(contactableBuildings)
        delegate?.didUpdateContactGroups()
    }
}
