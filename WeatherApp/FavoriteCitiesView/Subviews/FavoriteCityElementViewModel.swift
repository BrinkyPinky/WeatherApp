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
    
    private var weatherForElement: WeatherModel
    
    required init(weatherForElement: WeatherModel) {
        self.weatherForElement = weatherForElement
    }
}
