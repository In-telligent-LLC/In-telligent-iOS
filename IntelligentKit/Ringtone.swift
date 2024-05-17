//
//  Ringtone.swift
//  Open API
//
//  Created by Zachary Zeno on 3/12/18.
//  Copyright © 2018 In-telligent LLC. All rights reserved.
//

import Foundation

public enum Ringtone: String, CaseIterable {
    case lifeSafety = "lifeSafety",
    critical = "critical",
    voip = "voip",
    ping = "ping",
    weather = "weather",
    lightning = "lightning",
    
    urgent = "urgent",
    emergency = "emergency"
    
    var fileURL: URL? {
        return Bundle.main.url(forResource: rawValue, withExtension: "mp3")
    }
}
