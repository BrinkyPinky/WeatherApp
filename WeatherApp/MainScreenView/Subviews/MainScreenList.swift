//
//  MainScreenList.swift
//  WeatherApp
//
//  Created by Егор Шилов on 22.08.2022.
//

import SwiftUI

struct MainScreenList: View {
    
    @ObservedObject var viewModel: MainScreenViewModel
    
    var body: some View {
        List {
            Section {
                ForEach(viewModel.rowsForForecast, id: \.id) { forecastViewModel in
                    ForecastElement(viewModel: forecastViewModel)
                }
            } header: {
                CurrentWeatherView(viewModel: viewModel)
                    .padding(.top, -20)
                    .padding(.bottom, 8)
                    .foregroundColor(.primary)
            }
            .textCase(nil)
        }
    }
}

struct MainScreenList_Previews: PreviewProvider {
    static var previews: some View {
        MainScreenList(viewModel: MainScreenViewModel())
    }
}
