//
//  Logging.swift
//  Intelligent
//
//  Created by Kurt Jensen on 10/4/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import Foundation
import SwiftyBeaver

class Logging {
    
    static let isEnabled: Bool = {
        return !Constants.isReleaseBuild
    }()
    
    static let shared = Logging()
    private let log = SwiftyBeaver.self

    init() {
        let console = ConsoleDestination()  // log to Xcode Console
        console.format = "$DHH:mm:ss$d $L $M"
        log.addDestination(console)
    }

    class func info(_ items: Any?...) {
        guard isEnabled else { return }

        shared.log.info(items)
    }

    class func error(_ error: Error?) {
        guard isEnabled else { return }
        
        if let error = error {
            shared.log.error(error)
        } else {
            shared.log.error("no error")
        }
    }
    
}
