//
//  PDFViewController.swift
//  Intelligent
//
//  Created by Kurt Jensen on 10/5/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit
import IntelligentKit
import PDFKit

class PDFViewController: INViewController {
    
    class func vc(_ url: URL) -> UINavigationController {
        let vc = PDFViewController()
        vc.url = url
        let nc = UINavigationController(rootViewController: vc)
        nc.isNavigationBarHidden = false
        return nc
    }
    
    lazy var closeBarButtonItem: UIBarButtonItem = {
       return UIBarButtonItem(title: NSLocalizedString("Close", comment: ""), style: .plain, target: self, action: #selector(closeTapped(_:)))
    }()

    private let pdfView = PDFView()
    private var url: URL!

    override internal func setupView() {
        super.setupView()
        
        navigationItem.leftBarButtonItem = closeBarButtonItem

        addPDFView()
        loadPDF()
    }
    
    private func loadPDF() {
        if let document = PDFDocument(url: url) {
            pdfView.document = document
        }
    }

    private func addPDFView() {
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pdfView)
        pdfView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        pdfView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        pdfView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        pdfView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    @objc func closeTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
}
