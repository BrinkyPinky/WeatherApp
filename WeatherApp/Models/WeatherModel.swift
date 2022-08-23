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
    let coord: Coord?
    let weather: [Weather]
    let main: Main
    let visibility: Int
    let name: String?
    let dt: Date
    let timezone: Int?
}

extension WeatherModel: Equatable {
    static func == (lhs: WeatherModel, rhs: WeatherModel) -> Bool {
        return lhs.coord?.lon == rhs.coord?.lon && lhs.coord?.lat == rhs.coord?.lat
    }
}

struct Coord: Decodable {
    let lon: Double?
    let lat: Double?
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
