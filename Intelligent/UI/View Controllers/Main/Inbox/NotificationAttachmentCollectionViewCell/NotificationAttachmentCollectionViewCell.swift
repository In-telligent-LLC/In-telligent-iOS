//
//  NotificationAttachmentCollectionViewCell.swift
//  Intelligent
//
//  Created by Kurt Jensen on 10/5/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit
import IntelligentKit

class NotificationAttachmentCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageOverlayView: UIView!
    @IBOutlet weak var imageOverlayImageView: UIImageView!
    @IBOutlet weak var videoOverlayImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()

        prepareForReuse()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.sd_cancelCurrentAnimationImagesLoad()
        imageView.image = nil
        imageView.contentMode = .scaleAspectFill
        imageOverlayView.isHidden = true
        imageOverlayImageView.isHidden = true
        videoOverlayImageView.isHidden = true
    }
    
    func configure(with attachment: NotificationAttachment) {
        switch attachment.type {
        case .image:
            imageOverlayView.isHidden = false
            imageOverlayImageView.isHidden = false
            if let url = attachment.url.url {
                imageView.sd_setImage(with: url, completed: nil)
            }
        case .video:
            imageOverlayView.isHidden = false
            videoOverlayImageView.isHidden = false
        case .pdf:
            imageView.contentMode = .scaleAspectFit
            imageView.image = UIImage(named: "icon_attachment_pdf")
        case .unknown:
            break
        }
    }
    
    func willDisplay(with attachment: NotificationAttachment) {
        switch attachment.type {
        case .video:
            imageView.image = attachment.generateVideoThumbnailImage()
        default:
            break
        }
    }

}
