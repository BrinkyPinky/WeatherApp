//
//  FavoriteCitiesView.swift
//  WeatherApp
//
//  Created by Егор Шилов on 22.08.2022.
//

import SwiftUI

struct FavoriteCitiesView: View {
    
    @ObservedObject var viewModel: MainScreenViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                AlertView(isPresented: $viewModel.alertIsPresented)
                List {
                    ForEach(viewModel.rowsForFavoriteCityElement, id: \.id) { elementViewModel in
                        Button {
                            viewModel.toggleIsFavoriteCitiesViewPresented()
                            viewModel.favoriteCityButtonPressed(elementViewModel: elementViewModel)
                        } label: {
                            FavoriteCityElement(viewModel: elementViewModel)
                        }
                        .foregroundColor(.primary)
                    }
                    .onDelete() { indexSet in
                        viewModel.deleteFavoriteCity(at: indexSet)
                    }
                }
                .listRowSeparator(.hidden)
                .listStyle(.insetGrouped)
                
                .onAppear {
                    viewModel.onApper()
                }
                .navigationTitle("Города")
                .toolbar {
                    EditButton()
                }
            }
        }
    }
}

struct FavoriteCitiesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteCitiesView(viewModel: MainScreenViewModel())
    }
}
