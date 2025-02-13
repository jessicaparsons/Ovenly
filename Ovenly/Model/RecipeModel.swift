//
//  RecipeModel.swift
//  Ovenly
//
//  Created by Jessica Parsons on 2/9/25.
//

import SwiftUI

struct RecipeModel: Identifiable, Equatable {
    
    let cuisine: String
    let name: String
    let photoUrlLarge: String?
    let photoUrlSmall: String?
    let sourceUrl: String?
    let id: String
    let youtubeUrl: String?
    
    var imageDataURL: URL?
}
