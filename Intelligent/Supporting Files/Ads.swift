//
//  Ads.swift
//  Intelligent
//
//  Created by Kurt Jensen on 12/17/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import AdSupport
import iSoma

class Ads {
    class public func configure(gpsEnabled: Bool) {
        iSoma.setDefaultPublisherId(Constants.Ads.SMAATO.publisherId, adSpaceId: Constants.Ads.SMAATO.adSpaceId)
        iSoma.setGPSEnabled(gpsEnabled)
        iSoma.setAutoReloadEnabled(false)
    }
}
