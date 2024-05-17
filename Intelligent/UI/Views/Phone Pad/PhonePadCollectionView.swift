//
//  PhonePadCollectionView.swift
//  Intelligent
//
//  Created by Kurt Jensen on 11/14/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit

protocol PhonePadCollectionViewDelegate: class {
    func phonePadCollectionViewDidInputDigit(_ digit: Int)
}

class PhonePadCollectionView: UICollectionView {

    private var phonePadValues: [[Int]] {
        return [
            [1,2,3],
            [4,5,6],
            [7,8,9],
            [-1,0,-1]
        ]
    }
    
    weak var inputDelegate: PhonePadCollectionViewDelegate?
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    private func commonInit() {
        registerNib(cell: PhonePadCollectionViewCell.self)
        dataSource = self
        delegate = self
    }

}

extension PhonePadCollectionView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
 
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return phonePadValues.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let values = phonePadValues[section]
        return values.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(cell: PhonePadCollectionViewCell.self, for: indexPath)
        let value = phonePadValues[indexPath.section][indexPath.item]
        cell.configure(with: value)
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let value = phonePadValues[indexPath.section][indexPath.item]
        guard let digitValue = value.digitValue else { return }
        
        inputDelegate?.phonePadCollectionViewDidInputDigit(digitValue)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let columnCount = CGFloat(collectionView.numberOfItems(inSection: indexPath.section))
        var spacing: CGFloat = 0
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            spacing = layout.minimumInteritemSpacing*(columnCount-1)
        }
        let width = (collectionView.bounds.width - spacing)/columnCount
        return CGSize(width: width, height: width)
    }
    
}
