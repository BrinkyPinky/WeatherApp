//
//  FavoriteCitiesView.swift
//  WeatherApp
//
//  Created by Егор Шилов on 22.08.2022.
//

import SwiftUI

struct FavoriteCitiesView: View {
    
    @ObservedObject var rootViewModel: WeatherAppViewModel
    @ObservedObject private var viewModel = FavoriteCitiesViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.rowsForFavoriteCityElement, id: \.id) { elementViewModel in
                FavoriteCityElement(viewModel: elementViewModel)
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
        FavoriteCitiesView(rootViewModel: WeatherAppViewModel())
    }
}
