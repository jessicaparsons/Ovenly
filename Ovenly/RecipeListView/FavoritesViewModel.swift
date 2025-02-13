//
//  FavoritesViewModel.swift
//  Ovenly
//
//  Created by Jessica Parsons on 2/10/25.
//

import SwiftUI

final class FavoritesViewModel: ObservableObject {
    
    @Published var savedRecipes: Set<String>
    private var database: DatabaseProtocol
    
    init(database: DatabaseProtocol = Database()) {
        self.database = database
        self.savedRecipes = database.load()
    }
    
    func favoriteRecipes(_ recipes: [RecipeModel]) -> [RecipeModel] {
        recipes.filter { savedRecipes.contains($0.id) }
    }
    
    func addFavorite(_ recipe: RecipeModel) {
        guard !savedRecipes.contains(recipe.id) else { return }
        savedRecipes.insert(recipe.id)
        database.save(recipes: savedRecipes)
    }
    
    func removeFavorite(_ recipe: RecipeModel) {
        guard savedRecipes.contains(recipe.id) else { return }
        savedRecipes.remove(recipe.id)
        database.save(recipes: savedRecipes)
    }
}
