//
//  GroupInboxNotificationViewController.swift
//  Intelligent
//
//  Created by Kurt on 10/19/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit
import IntelligentKit

class GroupInboxNotificationViewController: BaseNotificationViewController {
    
    @IBOutlet weak var deliveryInfoButton: INButton!
    
    override func setupView() {
        super.setupView()
        
        setupDeliveryInfoButton()
    }
    
    private func setupDeliveryInfoButton() {
        deliveryInfoButton.title = NSLocalizedString("DELIVERY INFORMATION", comment: "")
        
        var deliveryInfoEnabled = false
        if let building = notification.getBuilding() {
            deliveryInfoEnabled = building.isPersonal && building.isManagedByCurrentUser
        }
        deliveryInfoButton.isHidden = !deliveryInfoEnabled
    }

    @IBAction func deliveryInfoTapped(_ sender: Any) {
        guard let vc = Storyboard.groups.viewController(vc: GroupNotificationDeliveryInfoViewController.self) else { return }
        
        vc.notification = notification
        navigationController?.pushViewController(vc, animated: true)
    }

}
