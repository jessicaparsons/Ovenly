//
//  Database.swift
//  Ovenly
//
//  Created by Jessica Parsons on 2/10/25.
//

import Foundation


protocol DatabaseProtocol {
    func save(recipes: Set<String>)
    func load() -> Set<String>
    
}

final class Database: DatabaseProtocol {
    private let FAV_KEY = "favKey"
    
    func save(recipes: Set<String>) {
        let array = Array(recipes)
        UserDefaults.standard.set(array, forKey: FAV_KEY)
    }
    
    func load() -> Set<String> {
        let array = UserDefaults.standard.array(forKey: FAV_KEY) as? [String] ?? []
        return Set(array)
    }
}
