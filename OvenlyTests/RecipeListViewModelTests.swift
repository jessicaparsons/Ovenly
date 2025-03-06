//
//  RecipeListViewModelTests.swift
//  OvenlyTests
//
//  Created by Jessica Parsons on 2/11/25.
//

import XCTest
@testable import Ovenly

final class RecipeListViewModelTests: XCTestCase {
    
    var viewModel: RecipeListViewModel?

    override func setUpWithError() throws {
        super.setUp()
        let mockFetcher = MockGetRecipes()
        viewModel = RecipeListViewModel(recipeFetcher: mockFetcher)
    }

    override func tearDownWithError() throws {
        viewModel = nil
        super.tearDown()
    }
    
    func testLoadRecipesAPISuccess() async {
        
        await viewModel?.loadRecipes()
                
        XCTAssertFalse(viewModel?.recipes.isEmpty ?? true, "Recipes array should not be empty")
        XCTAssertEqual(viewModel?.recipes.first?.cuisine, "Malaysian")
        XCTAssertEqual(viewModel?.recipes.first?.name, "Apam Balik")
        XCTAssertEqual(viewModel?.recipes.first?.id, "0c6ca6e7-e32a-4053-b824-1dbf749910d8")
    }
    
    func testGetRecipesInvalidError() async throws {
        let fetcher = MockGetRecipesMalformedAPI()
        
        do {
            _ = try await fetcher.getRecipes()
            XCTFail("Expected decodingFailed error, but got success")
            
        } catch let error as NetworkError {
            XCTAssertEqual(error, .decodingFailed)
        }
    }
    
    func testGetRecipesSuccess() async throws {
        
        let fetcher = MockGetRecipes()
        let recipes = try await fetcher.getRecipes()
        
        XCTAssertNotNil(recipes)
        XCTAssertEqual(recipes.first?.cuisine, "Malaysian")
        XCTAssertEqual(recipes.first?.name, "Apam Balik")
        XCTAssertEqual(recipes.first?.id, "0c6ca6e7-e32a-4053-b824-1dbf749910d8")
    }
    
    func testLoadRecipes_CallsFetchCachedImage() async {
        await viewModel?.loadRecipes()
        
        XCTAssertFalse(viewModel?.recipes.isEmpty ?? true, "Recipes should be loaded and not empty")
        XCTAssertNotNil(viewModel?.recipes.first?.imageDataURL, "The first recipe should have an image created by the fetcher and caching methods")
    }

}

// Mock verson of Recipe API call
class MockGetRecipes: RecipeFetching {
    
    func getRecipes() async throws -> [RecipeModel] {
                
        let jsonString = """
        {
          "recipes": [
            {
              "cuisine": "Malaysian",
              "name": "Apam Balik",
              "photoUrlLarge": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg",
              "photoUrlSmall": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg",
              "sourceUrl": "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ",
              "uuid": "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
              "youtubeUrl": "https://www.youtube.com/watch?v=6R8ffRRJcrg"
            }
          ]
        }
        """
        
        guard let data = jsonString.data(using: .utf8) else {
            print("JSON Conversion Failed")
            throw NetworkError.requestFailed
        }
        
        let decoder = JSONDecoder()
        
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

class MockGetRecipesMalformedAPI: RecipeFetching {
    
    private let malformedAPIURL = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json"
    
    func getRecipes() async throws -> [RecipeModel] {
        guard let url = URL(string: malformedAPIURL) else {
            throw NetworkError.invalidURL
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw NetworkError.requestFailed
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
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
            throw NetworkError.decodingFailed
        }
    }
}
