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

struct WeatherModel: Codable {
    let coord: Coord?
    let weather: [Weather]
    let main: Main
    let visibility: Int
    let name: String?
    let dt: Date
    let timezone: Int?
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(coord, forKey: .coord)
        try container.encode(weather, forKey: .weather)
        try container.encode(main, forKey: .main)
        try container.encode(visibility, forKey: .visibility)
        try container.encode(name, forKey: .name)
        try container.encode(dt, forKey: .dt)
        try container.encode(timezone, forKey: .timezone)
    }
}

extension WeatherModel: Equatable {
    static func == (lhs: WeatherModel, rhs: WeatherModel) -> Bool {
        return lhs.coord?.lon == rhs.coord?.lon && lhs.coord?.lat == rhs.coord?.lat
    }
}

struct Coord: Codable {
    let lon: Float?
    let lat: Float?
}

struct Weather: Codable {
    let description: String?
    let icon: String?
}

struct Main: Codable {
    let temp: Float?
    let feelsLike: Float?
    let humidity: Float?
    
    enum CodingKeys: String, CodingKey {
        case temp = "temp"
        case feelsLike = "feels_like"
        case humidity = "humidity"
    }
}
