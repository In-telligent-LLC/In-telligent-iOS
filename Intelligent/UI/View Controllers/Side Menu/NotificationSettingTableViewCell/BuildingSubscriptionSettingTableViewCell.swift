//
//  BuildingSubscriptionSettingTableViewCell.swift
//  Intelligent
//
//  Created by Kurt Jensen on 11/3/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit
import IntelligentKit

protocol BuildingSubscriptionSettingTableViewCellDelegate: class {
    func notificationSettingWeatherTableViewCellChangedSubscription(_ cell: BuildingSubscriptionSettingTableViewCell, subscription: Subscription)
}

class BuildingSubscriptionSettingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var buildingImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var subscriptionSegmentedControl: UISegmentedControl!

    weak var delegate: BuildingSubscriptionSettingTableViewCellDelegate?
    
    private var availableSubscriptions: [Subscription] = [] {
        didSet {
            subscriptionSegmentedControl.removeAllSegments()
            for (i, subscription) in availableSubscriptions.enumerated() {
                subscriptionSegmentedControl.insertSegment(withTitle: subscription.localizedString, at: i, animated: false)
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        
        infoLabel.text = NSLocalizedString("Receive regular alerts", comment: "")
        
        setupSubcriptionControl()
    }
    
    private func setupSubcriptionControl() {
        let segmentedControlAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 12)
        ]
        for state in UIControl.State.all {
            subscriptionSegmentedControl.setTitleTextAttributes(segmentedControlAttributes, for: state)
        }
        subscriptionSegmentedControl.tintColor = Color.green
        subscriptionSegmentedControl.apportionsSegmentWidthsByContent = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with building: INBuilding) {
        if let url = building.imageURL?.url {
            buildingImageView.sd_setImage(with: url, completed: nil)
        } else {
            buildingImageView.image = building.image
        }
        nameLabel.text = building.name
        availableSubscriptions = building.availableSubscriptions
        if let subscription = building.subscriber?.alertsSubscription,
            let index = availableSubscriptions.index(of: subscription) {
            subscriptionSegmentedControl.selectedSegmentIndex = index
        }
    }
    
    @IBAction func subscriptionChanged(_ sender: UISegmentedControl) {
        guard let subscription = availableSubscriptions[safe: sender.selectedSegmentIndex] else { return }
        
        delegate?.notificationSettingWeatherTableViewCellChangedSubscription(self, subscription: subscription)
    }
    
}
