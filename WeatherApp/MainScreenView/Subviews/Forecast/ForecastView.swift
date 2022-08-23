//
//  ForecastView.swift
//  WeatherApp
//
//  Created by Егор Шилов on 19.08.2022.
//

import SwiftUI

struct ForecastView: View {
    
    @ObservedObject var viewModel: MainScreenViewModel
    
    var body: some View {
        List(viewModel.rowsForForecast, id: \.id) { forecastViewModel in
            ForecastElement(viewModel: forecastViewModel)
        }
    }
}

struct ForecastView_Previews: PreviewProvider {
    static var previews: some View {
        ForecastView(viewModel: MainScreenViewModel())
    }
}
