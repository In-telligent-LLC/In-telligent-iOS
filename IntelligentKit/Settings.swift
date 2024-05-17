//
//  Settings.swift
//  IntelligentKit
//
//  Created by Kurt Jensen on 12/6/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import Foundation

class Settings {
    class var silenceExpirationDate: Date? {
        get {
            guard let date = UserDefaults.standard.object(forKey: #function) as? Date,
                date.timeIntervalSinceNow > 0 else { return nil }
            return date
        }
        set { UserDefaults.standard.set(newValue, forKey: #function) }
    }
}
