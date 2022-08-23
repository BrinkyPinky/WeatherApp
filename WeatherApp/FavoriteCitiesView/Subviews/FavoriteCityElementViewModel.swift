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
    
    var cityNameForElement: String {
        "\(weatherForElement.name ?? "Нет данных")"
    }
    
    var imageNameForElement: String {
        IconManager.shared.getIconName(from: weatherForElement.weather.first?.icon ?? "")
    }
    
    var weatherDescriptionForElement: String {
        "\(weatherForElement.weather.first?.description?.capitalizingFirstLetter() ?? "")"
    }
    
    var weatherForElement: WeatherModel
    
    required init(weatherForElement: WeatherModel) {
        self.weatherForElement = weatherForElement
    }
}
