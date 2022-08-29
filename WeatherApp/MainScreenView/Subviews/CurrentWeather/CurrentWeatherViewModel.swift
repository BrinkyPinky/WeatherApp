//
//  CurrentWeatherViewModel.swift
//  WeatherApp
//
//  Created by Егор Шилов on 29.08.2022.
//

import Foundation

class CurrentWeatherViewModel: ObservableObject {
    
    var currentWeather: WeatherModel
    var currentCity: CityModel
    
    init(currentWeather: WeatherModel, currentCity: CityModel) {
        self.currentWeather = currentWeather
        self.currentCity = currentCity
    }
    
    var iconName: String {
        IconManager.shared.getIconName(from: currentWeather.weather.first?.icon ?? "")
    }
    
    var cityNameForCurrentWeather: String {
        "\(currentCity.localNames?.ru ?? currentCity.name ?? "")"
    }
    
    var descriptionForCurrentWeather: String {
        "\(currentWeather.weather.first?.description?.capitalizingFirstLetter() ?? "")"
    }
    
    var temperatureForCurrentWeather: String {
        "\(lroundf(currentWeather.main.temp ?? 0))°"
    }
    
    var feelsLikeForCurrentWeather: String {
        "\(lroundf(currentWeather.main.feelsLike ?? 0))°"
    }
    
    var visibilityForCurrentWeather: String {
        "\(currentWeather.visibility/1000) км"
    }
    
    var humidityForCurrentWeather: String {
        "\(lroundf(currentWeather.main.humidity ?? 0))%"
    }
}
