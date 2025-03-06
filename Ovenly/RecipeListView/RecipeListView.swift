//
//  RecipeListsView.swift
//  Ovenly
//
//  Created by Jessica Parsons on 2/9/25.
//

import SwiftUI

struct RecipeListView: View {
    
    //MARK: - PROPERTIES
    
    @EnvironmentObject var favViewModel: FavoritesViewModel
    @StateObject private var viewModel = RecipeListViewModel(recipeFetcher: RecipeFetcher(), cachedImageFetcher: CachedImageDataStore())
    private let gridItem: [GridItem] = Array(repeating: .init(.flexible(), spacing: Constants.gridSpacing), count: 2)
    
    //PICKER
    enum ListSelection: String, CaseIterable, Identifiable {
        case all = "All"
        case favorites = "Favorites"
        var id: Self { self }
    }
    @State private var selectedView: ListSelection = .all
    
    //SEARCH BAR
    @State private var searchText = ""
    
    //CATEGORY CHIPS
    @State private var isAnimating = false
    @State private var selectedCuisine: String? = nil
    
    
    //MARK: - BODY
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    
            //MARK: - CATEGORY CHIPS
                    if !viewModel.recipes.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack(spacing: Constants.gridSpacing) {
                                ForEach(allCuisines, id: \.self) { cuisine in
                                    RecipePillLabelView(label: cuisine, isSelected: selectedCuisine == cuisine)
                                        .onTapGesture {
                                            searchText = cuisine
                                            selectedCuisine = cuisine
                                            HapticsManager.shared.triggerLightImpact()
                                        }
                                    
                                }
                            }//:LAZYHSTACK
                            .frame(height: 50)
                        }//:SCROLLVIEW
                    }
                    
            //MARK: - PICKER
                    
                    Picker("All Recipes", selection: $selectedView) {
                        ForEach(ListSelection.allCases) { option in
                            Text(option.rawValue).tag(option)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.bottom)
                    
                    
                    if !viewModel.recipes.isEmpty {
                        
            //MARK: - EMPTY FAVORITES LIST
                        if selectedView == .favorites && favViewModel.savedRecipes.isEmpty {
                            EmptyListView(icon: "heart.slash", text: "No favorites found!")
                            
                            
            //MARK: - ALL RECIPES
                        } else {
                            LazyVGrid(columns: gridItem, alignment: .center) {
                                ForEach(selectedView == .favorites ? favoriteSearchResults : searchResults) { recipe in
                                    RecipeCardView(recipe: recipe)
                                        .task {
                                            await viewModel.loadRecipes()
                                        }
                                }
                            }
                        }
            //MARK: - LOADING ERROR
                    } else {
                        EmptyListView(icon: "slash.circle", text: "Sorry, no recipes found! Try pulling down to refresh.")
                    }
                    
                }//:VSTACK
            }//:SCROLLVIEW
            .scrollIndicators(.hidden)
            .padding(.horizontal)
            .refreshable {
                await viewModel.loadRecipes()
            }
            .background(Color.background)
            .searchable(text: $searchText, prompt: "Search recipes")
            //clears selected cuisine if the seach is empty
            .onChange(of: searchText) { newValue in
                if newValue.isEmpty {
                    selectedCuisine = nil
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack(alignment: .center, spacing: 5) {
                        Image("loadingScreenIcon")
                            .resizable()
                            .frame(width: 30, height: 30)
                        Text("Ovenly")
                            .font(.title)
                            .fontWeight(.bold)
                        Spacer()
                    }//:HSTACK
                    .padding(.bottom, 5)
                }
            }
        }//:NAVIGATIONSTACK
        .task {
            await viewModel.loadRecipes()
        }
        
    }//:BODY
    
    //MARK: - COMPUTED VARIABLES
    
    var searchResults: [RecipeModel] {
        if searchText.isEmpty {
            return viewModel.recipes
        } else {
            return viewModel.recipes.filter { $0.name.localizedCaseInsensitiveContains(searchText) || $0.cuisine.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var favoriteSearchResults: [RecipeModel] {
        if searchText.isEmpty {
            return favViewModel.favoriteRecipes(viewModel.recipes)
        } else {
            return favViewModel.favoriteRecipes(viewModel.recipes).filter { $0.name.localizedCaseInsensitiveContains(searchText) || $0.cuisine.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var allCuisines: [String] {
        Set(viewModel.recipes.map { $0.cuisine }).sorted()
    }
}

//MARK: - PREVIEW

#Preview {
    NavigationStack {
        RecipeListView().environmentObject(FavoritesViewModel())
    }
}



/*
 
 I need a way to filter favorite recipes

 
 func filterFavoriteRecipes(recipes: [RecipeModel]) -> [RecipeModel] {
    recipes.filter { favoriteRecipes.contains($0.id) }
 }
 
 give each recipe var isFavorite
 
 create a way to viewModel.recipe.isFavorite.toggle()
 
 Persistence?
 
 I need a way to identify the favorites
 store the identifier in an array
 
 favoriteRecipes = []
 
 func toggleFavorite(recipe: RecipeModel) {
    if !favoriteRecipes.contains(recipe.id) {
        favoriteRecipes.append(recipe.id)
    } else {
    favoriteRecipes.remove(recipe.id)
 }
 
 
 .onTap {
 viewModel.toggleFavorite
 hapticfeedbackmanager.shared.mediumimpact
 
 
 }
 
 LazyVGrid {
     forEach(selector == .isFavorite ? favoriteRecipes: recipes) {
        //view with recipe
 }
 
 
 */
