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
                    Button {
                        viewModel.favoriteCityButtonPressed(
                            elementViewModel: viewModel.locationFavoriteCityElementViewModel,
                            lat: viewModel.locationFavoriteCityElementViewModel.lat,
                            lon: viewModel.locationFavoriteCityElementViewModel.lon
                        )
                        viewModel.toggleIsFavoriteCitiesViewPresented()
                    } label: {
                        FavoriteCityElement(viewModel: viewModel.locationFavoriteCityElementViewModel)
                    }
                    ForEach(viewModel.rowsForFavoriteCityElement, id: \.id) { elementViewModel in
                        Button {
                            viewModel.favoriteCityButtonPressed(elementViewModel: elementViewModel, lat: elementViewModel.lat, lon: elementViewModel.lon)
                            viewModel.toggleIsFavoriteCitiesViewPresented()
                        } label: {
                            FavoriteCityElement(viewModel: elementViewModel)
                        }
                    }
                    .onDelete() { indexSet in
                        viewModel.deleteFavoriteCity(at: indexSet)
                    }
                }
                .foregroundColor(.primary)
                .listRowSeparator(.hidden)
                .listStyle(.insetGrouped)
                .onAppear {
                    viewModel.onAppearFavoriteCitiesView()
                }
                .navigationTitle("Города")
            }
        }
    }
}

struct FavoriteCitiesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteCitiesView(viewModel: MainScreenViewModel())
    }
}
