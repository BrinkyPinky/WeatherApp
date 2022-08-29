//
//  CurrentWeatherView.swift
//  WeatherApp
//
//  Created by Егор Шилов on 19.08.2022.
//

import SwiftUI

struct CurrentWeatherView: View {
    @ObservedObject var viewModel: CurrentWeatherViewModel
    
    var body: some View {
        VStack() {
            CurrentWeatherMainInformation(
                imageName: viewModel.iconName,
                cityName: viewModel.cityNameForCurrentWeather,
                wheatherDesctiption: viewModel.descriptionForCurrentWeather,
                temperature: viewModel.temperatureForCurrentWeather
            )
            
            Spacer()
            
            CurrentWeatherAdditionalInformation(
                feelsLike: viewModel.feelsLikeForCurrentWeather,
                visibility: viewModel.visibilityForCurrentWeather,
                humidity: viewModel.humidityForCurrentWeather
            )
        }
    }
}
