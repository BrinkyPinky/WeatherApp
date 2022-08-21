//
//  ContentView.swift
//  WeatherApp
//
//  Created by Егор Шилов on 19.08.2022.
//

import SwiftUI

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
            CurrentWeatherView(viewModel: viewModel)
                .padding(.top, 8)
            ForecastView(viewModel: viewModel)
//                .frame(height: 160)
        }
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
