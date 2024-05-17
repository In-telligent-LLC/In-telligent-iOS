//
//  INNavigationController.swift
//  Intelligent
//
//  Created by Kurt Jensen on 10/8/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit
import SideMenu
import SwiftyJSON
import IntelligentKit

class INNavigationController: UINavigationController {
    
    lazy var _navigationBar: INNavigationBar = {
        let navigationBar = INNavigationBar()
        navigationBar.delegate = self
        navigationBar.shadowColor = Color.darkGray
        navigationBar.shadowOffset = CGSize(width: 0, height: 1)
        navigationBar.shadowRadius = 4.0
        navigationBar.shadowOpacity = 0.5
        return navigationBar
    }()
    
    var actualNavigationBarFrame: CGRect {
        var frame = navigationBar.frame
        frame.size.height += frame.origin.y
        frame.size.height += 1 // hide the border
        frame.origin.y = 0
        return frame
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.bringSubviewToFront(_navigationBar)
    }
    
    private func setupView() {
        addTabBar()
    }
    
    private func addTabBar() {
        _navigationBar.frame = actualNavigationBarFrame
        view.insertSubview(_navigationBar, aboveSubview: navigationBar)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        _navigationBar.frame = actualNavigationBarFrame
        view.bringSubviewToFront(_navigationBar)
    }
    
}

extension INNavigationController: INNavigationBarDelegate {
    func inNavigationBarDidTapSOSButton(_ navigationBar: INNavigationBar) {
        INLocationManager.getCurrentCountryCode({ [weak self] (countryCode) in
            self?.showSOS(for: countryCode)
        }) { [weak self] (error) in
            Logging.error(error)
            if let countryCode = (NSLocale.current as NSLocale).countryCode {
                self?.showSOS(for: countryCode)
            }
        }
    }
    
    private func showSOS(for countryCode: String) {
        guard let url = Bundle.main.url(forResource: "iso_sos", withExtension: "json") else {
            return
        }
        do {
            let data = try Data(contentsOf: url)
            let json = JSON(data)
            Logging.info("showing emergency for", json[countryCode])
            if let number = json[countryCode]["emergencyPhoneNumber"].string,
                let phoneURL = URL(string: "tel://\(number)") {
                showURL(phoneURL)
            }
        } catch {
            Logging.error(error)
        }
    }
    
    func inNavigationBarDidTapMenuButton(_ navigationBar: INNavigationBar) {
        guard let vc = SideMenuManager.default.menuLeftNavigationController else { return }
        present(vc, animated: true, completion: nil)
    }
}
