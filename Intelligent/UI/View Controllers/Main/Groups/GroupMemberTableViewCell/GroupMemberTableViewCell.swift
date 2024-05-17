//
//  GroupMemberTableViewCell.swift
//  Intelligent
//
//  Created by Kurt on 10/17/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit
import IntelligentKit

protocol GroupMemberTableViewCellDelegate: class {
    func groupMemberTableViewCellDidTapDelete(_ cell: GroupMemberTableViewCell)
    func groupMemberTableViewCellDidTapEdit(_ cell: GroupMemberTableViewCell)
    func groupMemberTableViewCellDidTapLocate(_ cell: GroupMemberTableViewCell)
}

class GroupMemberTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var locateButton: UIButton!

    weak var delegate: GroupMemberTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with buildingSubscriber: BuildingSubscriber) {
        nameLabel.text = buildingSubscriber.name
    }
    
    @IBAction func deleteTapped(_ sender: Any) {
        delegate?.groupMemberTableViewCellDidTapDelete(self)
    }
    
    @IBAction func editTapped(_ sender: Any) {
        delegate?.groupMemberTableViewCellDidTapEdit(self)
    }
    
    @IBAction func locateTapped(_ sender: Any) {
        delegate?.groupMemberTableViewCellDidTapLocate(self)
    }
    
}
