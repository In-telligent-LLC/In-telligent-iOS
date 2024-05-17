//
//  SevereWeatherSubscriptionView.swift
//  Intelligent
//
//  Created by Kurt Jensen on 11/20/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit
import IntelligentKit

protocol SevereWeatherSubscriptionViewDelegate: class {
    //func severeWeatherSubscriptionViewChangedSubscription(_ building: INBuilding, subscription: Subscription)
}
class SevereWeatherSubscriptionView: UIView {
    
    struct SevereWeatherAlertChanges {
        var isWeatherEnabled: Bool?
        var isLightningEnabled: Bool?
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var lightningLabel: UILabel!
    @IBOutlet weak var weatherSwitch: UISwitch!
    @IBOutlet weak var lightningSwitch: UISwitch!
    
    weak var delegate: SevereWeatherSubscriptionViewDelegate?
    
    var building: INBuilding?
    var alertChanges = SevereWeatherAlertChanges()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        weatherLabel.text = NSLocalizedString("Severe Weather", comment: "")
        lightningLabel.text = NSLocalizedString("Lightning", comment: "")
    }
    
    func configure(with building: INBuilding) {
        self.building = building
        
        nameLabel.text = building.name
        
        weatherSwitch.isOn = INSubscriber.current?.isWeatherEnabled ?? false
        lightningSwitch.isOn = INSubscriber.current?.isLightningEnabled ?? false
    }

    @IBAction func isWeatherEnabledChanged(_ sender: UISwitch) {
        alertChanges.isWeatherEnabled = sender.isOn
    }
    
    @IBAction func isLightningEnabledChanged(_ sender: UISwitch) {
        alertChanges.isLightningEnabled = sender.isOn
    }

}
