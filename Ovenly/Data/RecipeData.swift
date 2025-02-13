//
//  RecipeData.swift
//  Ovenly
//
//  Created by Jessica Parsons on 2/9/25.
//

import SwiftUI

struct RecipeData: Codable {
    let recipes: [Recipe]
}

struct Recipe: Codable {
    let cuisine: String
    let name: String
    let photoUrlLarge: String?
    let photoUrlSmall: String?
    let sourceUrl: String?
    let uuid: String
    let youtubeUrl: String?
}
