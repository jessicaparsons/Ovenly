//
//  FavoritesViewModelTests.swift
//  OvenlyTests
//
//  Created by Jessica Parsons on 2/11/25.
//

import XCTest
@testable import Ovenly

final class FavoritesViewModelTests: XCTestCase {
    
    var viewModel: FavoritesViewModel!
    var database: MockDatabase!

    override func setUpWithError() throws {
        super.setUp()
        database = MockDatabase()
        viewModel = FavoritesViewModel(database: database)

    }

    override func tearDownWithError() throws {
        super.tearDown()
        viewModel = nil
        database = nil
    }
    
    func testFilterFavoriteRecipes() {
        let recipes: [RecipeModel] = RecipeModel.mockRecipes
        viewModel.addFavorite(recipes[0])
                
        let filteredFavoriteRecipes = viewModel.favoriteRecipes(recipes)
        
        XCTAssertEqual(filteredFavoriteRecipes.count, 1)
        XCTAssertTrue(filteredFavoriteRecipes.contains(where: { $0.id == recipes[0].id }))
    }

    func testAddFavoriteRecipe() {
        let recipe = RecipeModel.mockRecipes[0]

        viewModel.addFavorite(recipe)
        
        XCTAssertFalse(viewModel.savedRecipes.isEmpty)
        XCTAssertTrue(viewModel.savedRecipes.contains(recipe.id), "Recipe should be in savedRecipes")
    }
    
    func testRemoveFavoriteRecipe() {
        let recipe = RecipeModel.mockRecipes[0]
        viewModel.savedRecipes = [recipe.id]
        
        viewModel.removeFavorite(recipe)
        
        XCTAssertFalse(viewModel.savedRecipes.contains(recipe.id))
        XCTAssertTrue(viewModel.savedRecipes.isEmpty)
        
    }
}

class MockDatabase: DatabaseProtocol {
    
    private let FAV_KEY = "favKey"

    func save(recipes: Set<String>) {
        let array = Array(recipes)
        MockUserDefaults.standard.set(array, forKey: FAV_KEY)
    }
    
    func load() -> Set<String> {
        let array = MockUserDefaults.standard.array(forKey: FAV_KEY) as? [String] ?? []
        return Set(array)
    }
}

class MockUserDefaults: UserDefaults {
    var savedData: [String: Any] = [:]

    override func set(_ value: Any?, forKey: String) {
        savedData[forKey] = value
    }

    override func array(forKey: String) -> [Any]? {
        return savedData[forKey] as? [Any]
    }
}
