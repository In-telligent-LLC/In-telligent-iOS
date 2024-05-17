//
//  BuildingTableViewCell.swift
//  Intelligent
//
//  Created by Kurt on 10/24/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit
import IntelligentKit

protocol BuildingTableViewCellDelegate: class {
    func buildingTableViewCellCallTapped(_ cell: BuildingTableViewCell)
    func buildingTableViewCellMessageTapped(_ cell: BuildingTableViewCell)
}

class BuildingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var messageButton: UIButton!

    @IBOutlet weak var buildingImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    weak var delegate: BuildingTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none

        prepareForReuse()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        buildingImageView.sd_cancelCurrentAnimationImagesLoad()
        buildingImageView.image = nil
    }
    
    func configure(with building: INBuilding) {
        if let url = building.imageURL?.url {
            buildingImageView.sd_setImage(with: url, completed: nil)
        } else {
            buildingImageView.image = building.image
        }
        nameLabel.text = building.name
        
        let availableContactActions = building.availableContactActions
        callButton.isHidden = !availableContactActions.contains(.call)
        messageButton.isHidden = !(availableContactActions.contains(.message) || availableContactActions.contains(.suggest))
    }
    
    @IBAction func callTapped(_ sender: Any) {
        delegate?.buildingTableViewCellCallTapped(self)
    }
    
    @IBAction func messageTapped(_ sender: Any) {
        delegate?.buildingTableViewCellMessageTapped(self)
    }
    
}
