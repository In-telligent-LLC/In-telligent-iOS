
//
//  InputManager.swift
//
//  Created by Kurt Jensen on 10/26/18.
//

import UIKit

@objc
protocol INInputManagerDelegate: class {
    @objc func inputs() -> [INInputView]
    @objc optional func inputDoneEditing(_ input: INInputView)
    @objc optional func inputDidBeginEditing(_ input: INInputView)
    @objc optional func inputDidEndEditing(_ input: INInputView)
    @objc optional func inputValueChanged(_ input: INInputView, value: Any)
}

class INInputViewManager: NSObject {
    
    var nextInput: INInputView? {
        guard let inputs = delegate?.inputs(),
            let view = view,
            let index = inputs.index(of: view) else { return nil }
        return inputs[safe: index+1]
    }
    
    var previousInput: INInputView? {
        guard let inputs = delegate?.inputs(),
            let view = view,
            let index = inputs.index(of: view) else { return nil }
        return inputs[safe: index-1]
    }
    
    weak var delegate: INInputManagerDelegate? { didSet { updateEnability() } }
    weak var view: INInputView?
    
    lazy var nextButton: UIBarButtonItem = {
        return UIBarButtonItem(image: UIImage(named: "icon_forward_small"), style: .plain, target: self, action:#selector(nextTapped))
    }()
    
    lazy var previousButton: UIBarButtonItem = {
        return UIBarButtonItem(image: UIImage(named: "icon_back_small"), style: .plain, target: self, action:#selector(previousTapped))
    }()
    
    lazy var inputPlaceholderLabel: UILabel = {
        let placeholderLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
        placeholderLabel.adjustsFontSizeToFitWidth = true
        placeholderLabel.textAlignment = .center
        return placeholderLabel
    }()
    
    private var items: [UIBarButtonItem] {
        let infoLabel = UIBarButtonItem(customView: inputPlaceholderLabel)
        let doneButton = UIBarButtonItem(title: NSLocalizedString("Done", comment: ""), style: .done, target: self, action: #selector(doneTapped))
        let items: [UIBarButtonItem]
        if let inputs = delegate?.inputs(), inputs.count > 1 {
            items = [
                previousButton,
                nextButton,
                UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
                infoLabel,
                UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
                doneButton
            ]
        } else {
            items = [
                UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
                infoLabel,
                UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
                doneButton
            ]
        }
        return items
    }
    
    lazy var toolbar: UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.isTranslucent = true
        toolbar.sizeToFit()
        toolbar.isUserInteractionEnabled = true
        toolbar.setItems(items, animated: false)
        return toolbar
    }()
    
    public func updateEnability() {
        let items = self.items
        if toolbar.items?.count ?? 0 != items.count {
            toolbar.setItems(items, animated: false)
        }
        self.previousButton.isEnabled = self.previousInput != nil
        self.nextButton.isEnabled = self.nextInput != nil
    }
    
    init(view: INInputView, configurePlaceholderLabel: (UILabel) -> Void) {
        super.init()
        
        self.view = view
        configurePlaceholderLabel(inputPlaceholderLabel)
        updateEnability()
    }
    
    @objc func doneTapped() {
        let _ = view?.resignFirstResponder()
    }
    
    @objc func nextTapped() {
        guard let became = nextInput?.becomeFirstResponder() else { return }
        
        if !became {
            let _ = view?.resignFirstResponder()
        }
    }
    
    @objc func previousTapped() {
        guard let became = previousInput?.becomeFirstResponder() else { return }
        
        if !became {
            let _ = view?.resignFirstResponder()
        }
    }
    
}

extension INInputViewManager: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let view = view else { return }
        
        delegate?.inputDidBeginEditing?(view)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let view = view else { return }
        
        delegate?.inputDidEndEditing?(view)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let view = view else { return false }

        let oldText = textField.text ?? ""
        let newText = NSString(string: oldText).replacingCharacters(in: range, with: string)
        delegate?.inputValueChanged?(view, value: newText)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension INInputViewManager: UITextViewDelegate {
}
