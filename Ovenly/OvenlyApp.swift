//
//  OvenlyApp.swift
//  Ovenly
//
//  Created by Jessica Parsons on 2/9/25.
//

import SwiftUI

@main
struct OvenlyApp: App {
    
    @StateObject private var favoritesViewModel = FavoritesViewModel()
    
    var body: some Scene {
        WindowGroup {
            RecipeListView()
                .environmentObject(favoritesViewModel)
        }
    }
}
