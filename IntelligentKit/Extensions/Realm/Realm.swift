//
//  Realm.swift
//  Intelligent
//
//  Created by Kurt on 10/4/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import RealmSwift

extension Realm {
    
    static func write(_ block: ((_ realm: Realm) throws -> Void)) {
        guard let realm = try? Realm() else { return }
        try? realm.write {
            try? block(realm)
        }
    }
    
}

extension Object {
    static func createOrUpdate(value: Any, writeCompletion: ((Object) -> ())? = nil) {
        guard let realm = try? Realm() else { return }
        
        do {
            try realm.write {
                let object = realm.create(self, value: value, update: .all)
                writeCompletion?(object)
            }
        } catch {
            debugPrint(error)
        }
    }
    
    static func createOrUpdate(values: [Any], writeCompletion: (([Object]) -> ())? = nil) {
        guard let realm = try? Realm() else { return }
        var objects: [Object] = []
        do {
            try realm.write {
                values.forEach({ (value) in
                    let object = realm.create(self, value: value, update: .all)
                    objects.append(object)
                })
            }
            writeCompletion?(objects)
        } catch {
            debugPrint(error)
        }
        
    }
    
    static func object<T: Object>(forPrimaryKey key: Any) -> T? {
        guard let realm = try? Realm() else { return nil }
        return realm.object(ofType: T.self, forPrimaryKey: key)
    }
}
