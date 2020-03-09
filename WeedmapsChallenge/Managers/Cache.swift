//
//  Cache.swift
//  WeedmapsChallenge
//
//  Created by Perez Willie-Nwobu on 3/7/20.
//  Copyright © 2020 Weedmaps, LLC. All rights reserved.
//

import Foundation

class Cache<Key, Value> where Key : Hashable {
    
    //Custom Queue's
    private var queue = DispatchQueue(label: "CSG.WeedMapsApp.CacheSerialQueue")

    //Array of dictionaries
    private var cachedItems: [Key: Value] = [:]

    subscript(_ key: Key) -> Value? {
        get {
            return queue.sync { cachedItems[key] ?? nil }
            //returns the value for the key entered.
            
            // queue.sync waits for synchronous task to complete before going on to other tasks
        }
        
        set(newValue) {
            cache(value: newValue, for: key)
        }
    }

    func cache(value: Value?, for key: Key) {
        queue.sync { self.cachedItems[key] = value }
    }
}
