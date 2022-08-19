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
                ForEach(viewModel.forecastWeather, id: \.dt) { forecast in
                    ForecastElement(
                        temperature: "123",
                        imageName: "sun.max.fill",
                        time: Text("eqwx")
                    )
                }
            }
        }
    }
}

struct ForecastView_Previews: PreviewProvider {
    static var previews: some View {
        ForecastView(viewModel: MainScreenViewModel())
    }
}
