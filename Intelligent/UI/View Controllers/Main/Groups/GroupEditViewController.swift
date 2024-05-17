//
//  GroupEditViewController.swift
//  Intelligent
//
//  Created by Kurt Jensen on 10/28/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit
import IntelligentKit

class GroupEditViewController: INViewController {
    
    @IBOutlet weak var submitButton: INLoadingButton!
    
    @IBOutlet weak var thumbnailTitleLabel: UILabel!
    @IBOutlet weak var customThumbnailButton: INButton!
    @IBOutlet weak var defaultThumbnailButton: INButton!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    @IBOutlet weak var listenInfoLabel: UILabel!
    @IBOutlet weak var orLabel: UILabel!
    @IBOutlet weak var listenEmergencyAlertButton: INButton!
    @IBOutlet weak var listenUrgentAlertButton: INButton!

    @IBOutlet weak var nameInputView: INInputView!
    @IBOutlet weak var infoInputView: INInputView!
    
    override var loadableViews: [UIView] {
        return [submitButton]
    }
    
    override var inInputViews: [INInputView] {
        return [
            nameInputView,
            infoInputView
        ]
    }
    
    var building: Building?
    var isCreatingNew: Bool {
        return building == nil
    }
    var customImage: CustomImage? {
        didSet {
            if let data = customImage?.imageData {
                thumbnailImageView.image = UIImage(data: data)
                thumbnailImageView.isHidden = false
            } else {
                thumbnailImageView.isHidden = true
            }
        }
    }

    override internal func setupView() {
        super.setupView()
        
        customImage = nil
        
        titleLabel?.text = isCreatingNew ? NSLocalizedString("Create a New Group", comment: "") : NSLocalizedString("Edit Group", comment: "")
        nameInputView.textField?.placeholder = isCreatingNew ? NSLocalizedString("Name Your Group", comment: "") : NSLocalizedString("Group Name", comment: "")
        infoInputView.textView?.placeholder = NSLocalizedString("Enter Description", comment: "")
        orLabel.text = NSLocalizedString("or", comment: "")
        submitButton.title = isCreatingNew ? NSLocalizedString("CREATE", comment: "") : NSLocalizedString("SAVE CHANGES", comment: "")
        
        thumbnailTitleLabel.text = NSLocalizedString("Select Thumbnail:", comment: "")
        defaultThumbnailButton.title = NSLocalizedString("Default Thumbnail", comment: "")
        customThumbnailButton.title = isCreatingNew ? NSLocalizedString("Create Thumbnail", comment: "") : NSLocalizedString("Change Thumbnail", comment: "")
        
        listenInfoLabel.text = NSLocalizedString("*When you send an urgent or emergency alert to the community, members will hear the alert sound.", comment: "")
        listenUrgentAlertButton.title = NSLocalizedString("Listen to the urgent alert sound", comment: "")
        listenEmergencyAlertButton.title = NSLocalizedString("Listen to the emergency alert sound", comment: "")

        if let building = building {
            nameInputView.textField?.text = building.name
            infoInputView.textView?.text = building.info
            if let url = building.imageURL?.url {
                thumbnailImageView.sd_setImage(with: url, completed: nil)
                thumbnailImageView.isHidden = false
            } else {
                thumbnailImageView.isHidden = true
            }
        }
    }
    
    @IBAction func useDefaultImageTapped(_ sender: Any) {
        customImage = nil
    }
    
    @IBAction func useCustomImageTapped(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func playUrgentAudioTapped(_ sender: Any) {
        toggleAudio(.urgent)
    }
    
    @IBAction func playEmergencyAudioTapped(_ sender: Any) {
        toggleAudio(.emergency)
    }
    
    private func toggleAudio(_ audio: Audio) {
        if INAudioManager.isPlaying(audio) {
            INAudioManager.stop()
        } else {
            INAudioManager.play(audio, numberOfLoops: 0, force: true, completion: {_ in })
        }
    }
    
    @IBAction func backTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitTapped(_ sender: Any) {
        if isCreatingNew {
            submitCreateGroup()
        } else {
            submitEditGroup()
        }
    }
    
}

//MARK: create group
extension GroupEditViewController {
    
    private func validateCreateGroup() throws -> CreateBuildingRequest {
        guard let name = nameInputView.stringValue, !name.isEmpty else {
            throw INError(message: NSLocalizedString("Please input a valid name", comment: ""))
        }
        guard let info = infoInputView.stringValue, !info.isEmpty else {
            throw INError(message: NSLocalizedString("Please input a valid description", comment: ""))
        }
        return CreateBuildingRequest(name: name, info: info, customImage: customImage)
    }
    
    private func submitCreateGroup() {
        do {
            let request = try validateCreateGroup()
            showLoading(submitButton)
            API.createBuilding(request, success: { [weak self] in
                self?.hideLoading()
                self?.didCreateGroup()
            }) { [weak self] (error) in
                self?.hideLoading()
                self?.showError(error)
            }
        } catch {
            showError(error)
        }
    }
    
    private func didCreateGroup() {
        showAlert(NSLocalizedString("Group Created", comment: ""), message: nil) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}

//MARK: edit group
extension GroupEditViewController {
    
    private func validateEditGroup() throws -> EditBuildingRequest {
        guard let building = building else {
            throw INError(message: NSLocalizedString("Invalid building", comment: ""))
        }
        guard let name = nameInputView.stringValue, !name.isEmpty else {
            throw INError(message: NSLocalizedString("Please input a valid name", comment: ""))
        }
        guard let info = infoInputView.stringValue, !info.isEmpty else {
            throw INError(message: NSLocalizedString("Please input a valid description", comment: ""))
        }
        return EditBuildingRequest(building: building, name: name, info: info, customImage: customImage)
    }
    
    private func submitEditGroup() {
        do {
            let request = try validateEditGroup()
            showLoading(submitButton)
            API.editBuilding(request, success: { [weak self] in
                self?.hideLoading()
                self?.didEditGroup()
            }) { [weak self] (error) in
                self?.hideLoading()
                self?.showError(error)
            }
        } catch {
            showError(error)
        }
    }
    
    private func didEditGroup() {
        showAlert(NSLocalizedString("Changes Saved", comment: ""), message: nil) {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension GroupEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let image = info[.originalImage] as? UIImage,
            let data = image
                .imageAspectScaled(toFill: CGSize(width: 500, height: 500))
                .jpegData(compressionQuality: 0.9) {
            if let url = info[.imageURL] as? URL {
                let name = url.lastPathComponent
                customImage = CustomImage(imageName: name, imageData: data)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}
