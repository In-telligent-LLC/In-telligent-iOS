//
//  Audio.swift
//  Intelligent
//
//  Created by Kurt Jensen on 10/30/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import Foundation

public enum Audio: String, CaseIterable {
    case alarm = "alarm",
    critical = "critical",
    voip = "voip",
    ping = "ping",
    weather = "weather",
    lightning = "lightning",
    urgent = "urgent",
    emergency = "emergency"
}
