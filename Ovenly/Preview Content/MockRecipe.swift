//
//  MockRecipe.swift
//  Ovenly
//
//  Created by Jessica Parsons on 2/9/25.
//

import Foundation

extension RecipeModel {
    static let mockRecipes = [
        RecipeModel(
            cuisine: "Malaysian",
            name: "Apam Balik",
            photoUrlLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg",
            photoUrlSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg",
            sourceUrl: "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ",
            id: "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
            youtubeUrl: "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
            imageDataURL: nil

    ),
        RecipeModel(
            cuisine: "British",
            name: "Chocolate Avocado Mousse",
            photoUrlLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/27c50c00-148e-4d2a-abb7-942182bb6d94/large.jpg",
            photoUrlSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/27c50c00-148e-4d2a-abb7-942182bb6d94/small.jpg",
            sourceUrl: "http://www.hemsleyandhemsley.com/recipe/chocolate-avocado-mousse/",
            id: "b07b8b92-64c9-4322-ab15-e628a1b8fcbc",
            youtubeUrl: "https://www.youtube.com/watch?v=wuZffe60q4M",
            imageDataURL: nil
        )
    ]
}
