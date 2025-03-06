//
//  RecipeListViewModel.swift
//  Ovenly
//
//  Created by Jessica Parsons on 2/9/25.
//

import SwiftUI

protocol RecipeFetching {
    func getRecipes() async throws -> [RecipeModel]
}

protocol CachedImagesFetching {
    func fetchCachedImage(for recipe: RecipeModel) async -> URL?
}

enum NetworkError: Error {
    case invalidURL
    case requestFailed
    case decodingFailed
}

final class RecipeListViewModel: ObservableObject {
    
    @Published var recipes: [RecipeModel] = []
    @Published var isShowingError: Bool = false
    let fileManager = LocalFileManager.instance
    private let recipeFetcher: RecipeFetching
    private let cachedImageFetcher: CachedImagesFetching
    
    init(recipeFetcher: RecipeFetching, cachedImageFetcher: CachedImagesFetching) {
        self.recipeFetcher = recipeFetcher
        self.cachedImageFetcher = cachedImageFetcher
    }

    @MainActor
    func loadRecipes() async {
        Task {
            do {
                
                var fetchedRecipes = try await recipeFetcher.getRecipes()
                
                for index in fetchedRecipes.indices {
                    if let localURL = await cachedImageFetcher.fetchCachedImage(for: fetchedRecipes[index]) {
                        fetchedRecipes[index].imageDataURL = localURL
                    }
                }
                await MainActor.run {
                    self.recipes = fetchedRecipes
                }
            }
            catch {
                await MainActor.run {
                    isShowingError = true
                    print("Failed to fetch recipes: \(error)")
                }
            }
        }
    }
}


struct CachedImageDataStore: CachedImagesFetching {
    
    func fetchCachedImage(for recipe: RecipeModel) async -> URL? {
        if let cachedURL = await LocalFileManager.instance.getCachedImageURL(for: recipe.id) {
            print("Using cached image: \(recipe.id)")
            return cachedURL
        }
                
        if let urlString = recipe.photoUrlLarge ?? recipe.photoUrlSmall {
            return try? await LocalFileManager.instance.downloadAndSaveImageToCache(from: urlString, image: recipe.id)
        }
        return nil
    }
    
}

struct RecipeFetcher: RecipeFetching {
    
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
