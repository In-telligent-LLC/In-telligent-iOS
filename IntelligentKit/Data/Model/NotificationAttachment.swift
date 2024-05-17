//
//  NotificationAttachment.swift
//  Intelligent
//
//  Created by Kurt Jensen on 10/5/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit
import AVFoundation

public struct NotificationAttachment {
    
    public let url: String
    public let type: NotificationAttachmentType
    
    init?(url: String, type: NotificationAttachmentType) {
        guard type != .unknown else { return nil }
        
        self.url = url
        self.type = type
    }
    
    public func generateVideoThumbnailImage() -> UIImage? {
        guard let url = url.url else { return nil }
        
        let asset = AVURLAsset(url: url)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        do {
            let cgImage = try generator.copyCGImage(at: .zero, actualTime: nil)
            let image = UIImage(cgImage: cgImage)
            return image
        } catch {
            Logging.error(error)
        }
        
        return nil
    }

}
