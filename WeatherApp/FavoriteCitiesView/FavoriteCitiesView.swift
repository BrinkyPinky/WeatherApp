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
        List {
            ForEach(viewModel.rowsForFavoriteCityElement, id: \.id) { elementViewModel in
                Button {
                    viewModel.toggleIsFavoriteCitiesViewPresented()
                } label: {
                    FavoriteCityElement(viewModel: elementViewModel)
                }
            }
            .onDelete() { indexSet in
                viewModel.deleteFavoriteCity(at: indexSet)
            }
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .onAppear {
            viewModel.onApper()
        }
    }
}

struct FavoriteCitiesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteCitiesView(viewModel: MainScreenViewModel())
    }
}
