//
//  FavoriteCityElementViewModel.swift
//  WeatherApp
//
//  Created by Егор Шилов on 23.08.2022.
//

import Foundation


class FavoriteCityElementViewModel: ObservableObject {
    let id = UUID()
    
    var temperatureForElement: String {
        "\(lroundf(weatherForElement.main.temp ?? 0))°"
    }
    
    var imageNameForElement: String {
        IconManager.shared.getIconName(from: weatherForElement.weather.first?.icon ?? "")
    }
    
    var weatherDescriptionForElement: String {
        "\(weatherForElement.weather.first?.description?.capitalizingFirstLetter() ?? "")"
    }
    
    var weatherForElement: WeatherModel
    
    var cityNameForElement: String
    
    var lat: Float {
        weatherForElement.coord?.lat ?? 0
    }
    
    var lon: Float {
        weatherForElement.coord?.lon ?? 0
    }
    
    required init(weatherForElement: WeatherModel, cityNameForElement: String) {
        self.weatherForElement = weatherForElement
        self.cityNameForElement = cityNameForElement
    }
}
