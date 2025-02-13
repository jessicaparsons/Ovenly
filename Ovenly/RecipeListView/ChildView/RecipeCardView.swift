//
//  RecipeCardView.swift
//  Ovenly
//
//  Created by Jessica Parsons on 2/9/25.
//

import SwiftUI

struct RecipeCardView: View {
    //MARK: - PROPERTIES
    
    var recipe: RecipeModel
    
    //MARK: - BODY
    var body: some View {
        
        VStack(alignment: .leading, spacing: Constants.verticalSpacing) {
            ZStack {
        //MARK: - IMAGE
                AsyncImage(url: recipe.imageDataURL) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
                            .cornerRadius(Constants.cornerRadius)
                            .accessibilityLabel("Photo of \(recipe.name)")
        //MARK: - ERROR PLACEHOLDER IMAGE
                    } else if phase.error != nil {
                        
                        ZStack {
                            Color.myWhite
                            Image("loadingScreenIcon")
                                .resizable()
                                .frame(width: 100, height: 100)
                        }
                        .aspectRatio(1/1, contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
        //MARK: - LOADING VIEW
                    } else {
                        ImageLoadingView()
                    }
                }//:IMAGE
            }//:ZSTACK
        //MARK: - OVERLAY LABELS
            .overlay {
                VStack {
                    HStack {
                        RecipePillLabelView(label: recipe.cuisine, isSelected: true)
                        Spacer()
                        FavoritePillLabelView(recipe: recipe)
                    }
                    .padding(5)
                    Spacer()
                }
            }
        //MARK: - RECIPE NAME
            Text(recipe.name)
                .font(.title3)
                .multilineTextAlignment(.leading)
                .lineLimit(2)
                .layoutPriority(1)
            Spacer()
        }//:VSTACK
        .frame(maxHeight: .infinity)
    }
}

//MARK: - PREVIEW


#Preview("List View") {
    NavigationStack {
        RecipeListView().environmentObject(FavoritesViewModel())
    }
}

#Preview {
 
    RecipeCardView(recipe: RecipeModel.mockRecipes[0])
        .environmentObject(FavoritesViewModel())

}
