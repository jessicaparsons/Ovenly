//
//  FavoritePillLabelView.swift
//  Ovenly
//
//  Created by Jessica Parsons on 2/10/25.
//

import SwiftUI

struct FavoritePillLabelView: View {
    
    let recipe: RecipeModel
    @EnvironmentObject var viewModel: FavoritesViewModel
    @State private var isAnimating: Bool = false
    
    var body: some View {
        
        Button(action: {
            withAnimation(.snappy(duration: 0.2)) {
                isFavorite() ? viewModel.removeFavorite(recipe) : viewModel.addFavorite(recipe)
                
                isAnimating = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    isAnimating = false
                }
                HapticsManager.shared.triggerLightImpact()
            }
        }) {
            Image(systemName: isFavorite() ? "heart.fill" : "heart")
                .foregroundColor(isFavorite() ? Color("Flame") : .black)
                .scaleEffect(isAnimating ? 1.2 : 1)
                .padding(.horizontal, Constants.horizontalPill)
                .padding(.vertical, Constants.verticalPill)
                .background(Capsule().fill(.white))
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func isFavorite() -> Bool {
        viewModel.savedRecipes.contains(recipe.id)
    }
}



#Preview {
    struct Preview: View {
        
        @State var isFavorite: Bool = false
        
        var body: some View {
            FavoritePillLabelView(recipe: RecipeModel.mockRecipes[0])
                .environmentObject(FavoritesViewModel())
        }
    }
    return Preview()
}
