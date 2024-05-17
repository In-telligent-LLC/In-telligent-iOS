//
//  GroupNotificationDeliveryInfoTableViewCell.swift
//  Intelligent
//
//  Created by Kurt on 10/19/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit
import IntelligentKit

class GroupNotificationDeliveryInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var buildingSubscriberNameLabel: UILabel!
    @IBOutlet weak var openedImageView: UIImageView!
    @IBOutlet weak var deliveredImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with notificationDeliveryInfo: NotificationSubscriberDeliveryInfo) {
        buildingSubscriberNameLabel.text = notificationDeliveryInfo.buildingSubscriberName
        openedImageView.image = notificationDeliveryInfo.wasOpened ? NotificationSubscriberDeliveryInfo.yesImage : NotificationSubscriberDeliveryInfo.noImage
        openedImageView.tintColor = notificationDeliveryInfo.wasOpened ? Color.green : Color.red
        deliveredImageView.image = notificationDeliveryInfo.wasDelivered ? NotificationSubscriberDeliveryInfo.yesImage : NotificationSubscriberDeliveryInfo.noImage
        deliveredImageView.tintColor = notificationDeliveryInfo.wasDelivered ? Color.green : Color.red
    }
    
}
