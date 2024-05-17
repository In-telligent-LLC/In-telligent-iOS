//
//  Constants.swift
//  Intelligent
//
//  Created by Kurt Jensen on 10/2/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import Foundation

struct Constants {
    
    struct Google {
        static let clientId = "592871569708-4t4r6k8c3av1hc68v4v45mj6fnh9mc3d.apps.googleusercontent.com"
    }
    
    struct Factual {
        static let apiKey = "HUO9PKsmMmydyA1rJ3dxOzwLEad4tYGL8GMDGqYV"
    }
    
    struct Ads {
        struct SMAATO {
            static let publisherId = "1100038695"
            static let adSpaceId = "130368150"
        }
        struct NUI {
            static let adURL: URL = URL(string: "https://intelligent.nui.media/pipeline/530171/0/vh?z=intelligent&dim=515020&kw=&click=")!
        }
    }
    
    struct Support {
        static let email = "support@intelligent.com"
        static let availability = "8:00 AM – 6:00 PM CST Mon-Fri"
        static let phoneNumber = "1-312-526-3286"
    }
    
    static let isReleaseBuild: Bool = {
        return !_isDebugAssertConfiguration()
    }()

}
