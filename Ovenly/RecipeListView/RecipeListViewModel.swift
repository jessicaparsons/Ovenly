//
//  RecipeListViewModel.swift
//  Ovenly
//
//  Created by Jessica Parsons on 2/9/25.
//

import SwiftUI

protocol RecipeFetcher {
    func getRecipes() async throws -> [RecipeModel]
}

enum NetworkError: Error {
    case invalidURL
    case requestFailed
    case decodingFailed
}

final class RecipeListViewModel: ObservableObject {
    
    @Published var recipes: [RecipeModel] = []
    @Published var showErrorMessage: Bool = false
    internal let manager = LocalFileManager.instance
    private let recipeFetcher: RecipeFetcher
    
    init(recipeFetcher: RecipeFetcher) {
        self.recipeFetcher = recipeFetcher
    }

    @MainActor
    func loadRecipes() async {
        do {
            var fetchedRecipes = try await recipeFetcher.getRecipes()
            
            for index in fetchedRecipes.indices {
                if let localURL = await fetchCachedImage(for: fetchedRecipes[index]) {
                    fetchedRecipes[index].imageDataURL = localURL
                }
            }
            
            self.recipes = fetchedRecipes
            
        } catch {
            showErrorMessage = true
            print("Failed to fetch recipes: \(error)")
        }
    }
    
    private func fetchCachedImage(for recipe: RecipeModel) async -> URL? {
        if let cachedURL = LocalFileManager.instance.getCachedImageURL(for: recipe.id) {
            print("Using cached image: \(recipe.id)")
            return cachedURL
        }
                
        if let urlString = recipe.photoUrlLarge ?? recipe.photoUrlSmall {
            return try? await LocalFileManager.instance.downloadAndSaveImageToCache(from: urlString, image: recipe.id)
        }
        return nil
    }
}

class GetRecipes: RecipeFetcher {
    
    func getRecipes() async throws -> [RecipeModel] {
        guard let url = URL(string: Constants.recipeAPI) else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.requestFailed
            
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        do {
            let recipeData = try decoder.decode(RecipeData.self, from: data)
            
            let recipes = recipeData.recipes.map { recipe in
                
                RecipeModel(
                    cuisine: recipe.cuisine,
                    name: recipe.name,
                    photoUrlLarge: recipe.photoUrlLarge,
                    photoUrlSmall: recipe.photoUrlSmall,
                    sourceUrl: recipe.sourceUrl,
                    id: recipe.uuid,
                    youtubeUrl: recipe.youtubeUrl
                )
            }
            return recipes
            
        } catch {
            print("JSON Decoding Failed: \(error)")
            throw NetworkError.decodingFailed
        }
    }
}
