//
//  GroupTableViewCell.swift
//  Intelligent
//
//  Created by Kurt on 10/16/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit
import IntelligentKit

protocol GroupTableViewCellDelegate: class {
    func groupTableViewCellDidSelectAction(_ cell: GroupTableViewCell)
    func groupTableViewCellDidSelectAbout(_ cell: GroupTableViewCell)
}

class GroupTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var buildingImageView: UIImageView!
    @IBOutlet weak var actionButton: INButton!
    @IBOutlet weak var aboutButton: INButton!

    weak var delegate: GroupTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        aboutButton.title = NSLocalizedString("ABOUT", comment: "")
        
        prepareForReuse()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        buildingImageView.sd_cancelCurrentAnimationImagesLoad()
        buildingImageView.image = nil
    }
    
    func configure(with building: Building) {
        if let url = building.imageURL?.url {
            buildingImageView.sd_setImage(with: url, completed: nil)
        } else {
            buildingImageView.image = building.image
        }
        nameLabel.text = building.name
        if let action = building.action {
            actionButton.isHidden = false
            actionButton.title = action.localizedString
        } else {
            actionButton.isHidden = true
        }
    }
    
    @IBAction func actionTapped(_ sender: Any) {
        delegate?.groupTableViewCellDidSelectAction(self)
    }
    
    @IBAction func aboutTapped(_ sender: Any) {
        delegate?.groupTableViewCellDidSelectAbout(self)
    }
    
}
