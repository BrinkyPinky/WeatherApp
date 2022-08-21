//
//  ForecastView.swift
//  WeatherApp
//
//  Created by Егор Шилов on 19.08.2022.
//

import SwiftUI

struct ForecastView: View {
    
    @ObservedObject var viewModel: MainScreenViewModel
    
    private let rows = [
        GridItem(.fixed(1))
    ]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: rows, spacing: 8) {
                ForEach(viewModel.columnsForForecast, id: \.id) { forecastViewModel in
                    ForecastElement(viewModel: forecastViewModel)
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

struct ForecastView_Previews: PreviewProvider {
    static var previews: some View {
        ForecastView(viewModel: MainScreenViewModel())
    }
}
