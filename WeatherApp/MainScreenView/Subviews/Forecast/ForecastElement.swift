//
//  ForecastElement.swift
//  WeatherApp
//
//  Created by Егор Шилов on 19.08.2022.
//

import SwiftUI

struct ForecastElement: View {
    @ObservedObject var viewModel: ForecastViewModel
    
    var body: some View {
        HStack {
            Text(viewModel.date)
            Spacer()
            Text(viewModel.temperature)
            Image(systemName: viewModel.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .padding(.leading, 32)
        }
    }
}

struct ForecastElement_Previews: PreviewProvider {
    static var previews: some View {
        ForecastElement(viewModel: ForecastViewModel(forecast: WeatherModel(coord: nil, weather: [Weather(description: "qwe", icon: "01d")], main: Main(temp: 10, feelsLike: 20, humidity: 30), visibility: 0, name: "20", dt: Date(), timezone: 10), timezone: 0))
    }
}
