//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Егор Шилов on 19.08.2022.
//

import Foundation

struct ForecastModel: Decodable {
    let list: [WeatherModel]
}

struct WeatherModel: Decodable {
    let weather: [Weather]
    let main: Main
    let visibility: Int
    let name: String?
    var dt: Date
}

struct Weather: Decodable {
    let description: String?
    let icon: String?
}

struct Main: Decodable {
    let temp: Float?
    let feelsLike: Float?
    let humidity: Float?
    
    enum CodingKeys: String, CodingKey {
        case temp = "temp"
        case feelsLike = "feels_like"
        case humidity = "humidity"
    }
}
