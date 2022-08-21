//
//  ContentView.swift
//  WeatherApp
//
//  Created by Егор Шилов on 19.08.2022.
//

import SwiftUI
import Alamofire

struct MainScreenView: View {
    
    @ObservedObject private var viewModel = MainScreenViewModel()
    
    var body: some View {
        VStack {
            Searchbar(cityNameForRequest: .constant("Search"))
                .disabled(true)
                .onTapGesture {
                    viewModel.cleanCityNameSearch()
                    viewModel.toggleIsSearchCityPresented()
                }
            
            MainScreenList(viewModel: viewModel)
                .listStyle(.insetGrouped)
        }
        .background(Color(.systemGray6))
        .fullScreenCover(isPresented: $viewModel.isSearchCityViewPresented) {
            SearchCityView(viewModel: viewModel)
        }
        .onAppear {
            UIView.setAnimationsEnabled(false)
            viewModel.doRequestForCurrentWeather()
            viewModel.doRequestForForecast()
        }
    }
}

struct MainScreenView_Previews: PreviewProvider {
    static var previews: some View {
        MainScreenView()
    }
}
