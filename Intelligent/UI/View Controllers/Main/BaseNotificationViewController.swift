//
//  BaseNotificationViewController.swift
//  Intelligent
//
//  Created by Kurt Jensen on 10/30/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import IntelligentKit

class BaseNotificationViewController: INViewController {


    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var attachmentLabel: UILabel!
    @IBOutlet weak var attachmentCollectionView: UICollectionView!
    @IBOutlet weak var textView: UITextView!

    var notification: INNotification!
    
    override func setupView() {
        super.setupView()
                
        setupCollectionView()
        setupNotification()
    }
    
    func setupNotification() {
        titleTextView.text = notification.title
        infoLabel.text = notification.info
        let format = NSLocalizedString("Attachments: %d total", comment: "")
        attachmentLabel.text = String.localizedStringWithFormat(format, notification.attachments.count)
        textView.text = notification.message
        
        attachmentCollectionView.isHidden = notification.attachments.count == 0
        view.layoutIfNeeded()
        attachmentCollectionView.reloadData()
    }
    
    private func setupCollectionView() {
        attachmentCollectionView.registerNib(cell: NotificationAttachmentCollectionViewCell.self)
        attachmentCollectionView.dataSource = self
        attachmentCollectionView.delegate = self
    }
    
    @IBAction func backTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension BaseNotificationViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return notification.attachments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(cell: NotificationAttachmentCollectionViewCell.self, for: indexPath)
        let attachment = notification.attachments[indexPath.item]
        cell.configure(with: attachment)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let attachment = notification.attachments[indexPath.item]
        (cell as? NotificationAttachmentCollectionViewCell)?.willDisplay(with: attachment)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let attachment = notification.attachments[indexPath.item]
        guard let url = attachment.url.url else { return }
        
        switch attachment.type {
        case .image:
            showImage(url)
        case .video:
            showVideo(url)
        case .pdf:
            showPDF(url)
        case .unknown:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.bounds.height
        let width = height*3/2
        return CGSize(width: width, height: height)
    }
    
}

//MARK: Media
extension BaseNotificationViewController {
    
    private func showPDF(_ url: URL) {
        let nc = PDFViewController.vc(url)
        present(nc, animated: true, completion: nil)
    }
    
    private func showImage(_ url: URL) {
        let nc = ImageViewController.vc(url)
        present(nc, animated: true, completion: nil)
    }
    
    private func showVideo(_ url: URL) {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            Logging.error(error)
        }
        
        let player = AVPlayer(url: url)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        present(playerViewController, animated: true) {
            playerViewController.player?.play()
        }
    }
    
}
