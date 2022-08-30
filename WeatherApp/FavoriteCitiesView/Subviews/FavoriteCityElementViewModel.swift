//
//  FavoriteCityElementViewModel.swift
//  WeatherApp
//
//  Created by Егор Шилов on 23.08.2022.
//

import Foundation


class FavoriteCityElementViewModel: ObservableObject, Codable {
    var id = UUID()
    
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
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(weatherForElement, forKey: .weatherForElement)
        try container.encode(id, forKey: .id)
        try container.encode(cityNameForElement, forKey: .cityNameForElement)
    }
}
