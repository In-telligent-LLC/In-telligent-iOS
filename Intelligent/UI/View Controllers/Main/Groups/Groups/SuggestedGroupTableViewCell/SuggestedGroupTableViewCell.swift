//
//  SuggestedSuggestedGroupTableViewCell.swift
//  Intelligent
//
//  Created by Kurt on 10/17/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit
import IntelligentKit

protocol SuggestedGroupTableViewCellDelegate: class {
    func suggestedGroupTableViewCellDidSelectSubscribe(_ cell: SuggestedGroupTableViewCell)
    func suggestedGroupTableViewCellDidSelectIgnore(_ cell: SuggestedGroupTableViewCell)
}
class SuggestedGroupTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var buildingImageView: UIImageView!
    @IBOutlet weak var subscribeButton: INButton!
    @IBOutlet weak var ignoreButton: INButton!

    weak var delegate: SuggestedGroupTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        subscribeButton.title = NSLocalizedString("SUBSCRIBE", comment: "")
        ignoreButton.title = NSLocalizedString("IGNORE", comment: "")

        selectionStyle = .none
        nameLabel.textAlignment = .natural
        
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
    }
    
    @IBAction func subscribeTapped(_ sender: Any) {
        delegate?.suggestedGroupTableViewCellDidSelectSubscribe(self)
    }
    
    @IBAction func ignoreTapped(_ sender: Any) {
        delegate?.suggestedGroupTableViewCellDidSelectIgnore(self)
    }
    
}
