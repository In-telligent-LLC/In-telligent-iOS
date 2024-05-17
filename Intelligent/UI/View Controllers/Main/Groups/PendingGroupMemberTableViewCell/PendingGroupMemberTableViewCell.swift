//
//  PendingGroupMemberTableViewCell.swift
//  Intelligent
//
//  Created by Kurt on 10/17/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit
import IntelligentKit

protocol PendingGroupMemberTableViewCellDelegate: class {
    func pendingGroupMemberTableViewCellDidTapCancel(_ cell: PendingGroupMemberTableViewCell)
}

class PendingGroupMemberTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    
    weak var delegate: PendingGroupMemberTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        cancelButton.tintColor = .black
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with buildingSubscriber: BuildingSubscriber) {
        nameLabel.text = buildingSubscriber.name
        statusLabel.text = buildingSubscriber.status.localizedString
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        delegate?.pendingGroupMemberTableViewCellDidTapCancel(self)
    }
    
}
