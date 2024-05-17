//
//  NotificationTableViewCell.swift
//  Intelligent
//
//  Created by Kurt on 10/4/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit
import IntelligentKit

protocol NotificationTableViewCellDelegate: class {
    func notificationTableViewCellDidTapView(_ cell: NotificationTableViewCell)
    func notificationTableViewCellDidTapDelete(_ cell: NotificationTableViewCell)
}

class NotificationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var notificationImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var notificationTypeImageView: UIImageView!
    @IBOutlet weak var readImageView: UIImageView!

    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var viewButton: INButton!

    weak var delegate: NotificationTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewButton.title = NSLocalizedString("VIEW", comment: "")
        
        selectionStyle = .none
        readImageView.tintColor = Color.green
        prepareForReuse()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        notificationImageView.sd_cancelCurrentAnimationImagesLoad()
        notificationImageView.image = nil
    }
    
    func configure(with notification: INNotification) {
        if let image = notification.type.image {
            notificationTypeImageView.image = image
            notificationTypeImageView.tintColor = notification.type.color
            notificationTypeImageView.isHidden = false
        } else {
            notificationTypeImageView.isHidden = true
        }
        let building = notification.getBuilding()
        if let url = building?.imageURL?.url {
            notificationImageView.sd_setImage(with: url, completed: nil)
        } else {
            notificationImageView.image = building?.image
        }
        titleLabel.textColor = notification.type.textColor
        titleLabel.text = notification.title
        messageLabel.text = notification.message
        infoLabel.text = notification.info
        readImageView.isHidden = notification.isRead
    }
    
    @IBAction func viewTapped(_ sender: Any) {
        delegate?.notificationTableViewCellDidTapView(self)
    }
    
    @IBAction func deleteTapped(_ sender: Any) {
        delegate?.notificationTableViewCellDidTapDelete(self)
    }
    
}
