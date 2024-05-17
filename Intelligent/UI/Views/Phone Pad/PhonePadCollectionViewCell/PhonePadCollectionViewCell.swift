//
//  PhonePadCollectionViewCell.swift
//  Intelligent
//
//  Created by Kurt Jensen on 11/14/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit

class PhonePadCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var lettersLabel: UILabel!

    var value: Int = -1

    override func awakeFromNib() {
        super.awakeFromNib()

        prepareForReuse()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        numberLabel.text = nil
        lettersLabel.text = nil
    }
    
    func configure(with value: Int) {
        self.value = value
        setupValue()
    }
    
    private func setupValue() {
        guard let digitValue = value.digitValue else { return }
        numberLabel.text = "\(digitValue)"
        lettersLabel.text = digitValue.phonePadLetters
    }
}

extension Int {
    
    var digitValue: Int? {
        guard self >= 0 && self <= 9 else { return nil }
        return self
    }
    
    var phonePadLetters: String? {
        switch self {
        case 2:
            return NSLocalizedString("ABC", comment: "")
        case 3:
            return NSLocalizedString("DEF", comment: "")
        case 4:
            return NSLocalizedString("GHI", comment: "")
        case 5:
            return NSLocalizedString("JKL", comment: "")
        case 6:
            return NSLocalizedString("MNO", comment: "")
        case 7:
            return NSLocalizedString("PQRS", comment: "")
        case 8:
            return NSLocalizedString("TUV", comment: "")
        case 9:
            return NSLocalizedString("WXYZ", comment: "")
        default:
            return nil
        }
    }
}
