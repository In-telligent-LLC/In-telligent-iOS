//
//  LanguageManager.swift
//  Intelligent
//
//  Created by Kurt Jensen on 11/20/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import Foundation
import RealmSwift
import IntelligentKit

class LanguageManager {
    
    static let shared = LanguageManager()

    class func getLanguages(_ success: @escaping ([Language]) -> Void, failure: @escaping API.APIResponseFailureHandler) {
        guard let realm = try? Realm() else { return }
        
        let languages = realm.objects(Language.self).sorted(byKeyPath: "name")
        guard languages.count > 0 else {
            fetchLanguages(success, failure: failure)
            return
        }
        
        success(Array(languages))
    }
    
    private class func fetchLanguages(_ success: @escaping ([Language]) -> Void, failure: @escaping API.APIResponseFailureHandler) {
        API.getAllLanguages({ (languages) in
            self.didFetchLanguages(languages, success: success, failure: failure)
        }, failure: failure)
    }
    
    private class func didFetchLanguages(_ languages: [Language], success: @escaping ([Language]) -> Void, failure: @escaping API.APIResponseFailureHandler) {
        guard let realm = try? Realm() else { return }

        try? realm.write {
            realm.add(languages, update: .all)
        }
        
        success(languages)
    }
}
