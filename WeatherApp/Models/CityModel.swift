//
//  CityModel.swift
//  WeatherApp
//
//  Created by Егор Шилов on 19.08.2022.
//

struct CityModel: Codable {
    var name: String?
    var localNames: LocalNames?
    var lat: Float?
    var lon: Float?
    var country: String?
    var state: String?
    
    enum CodingKeys: String, CodingKey {
        case name, lat, lon, country, state
        case localNames = "local_names"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(localNames, forKey: .localNames)
        try container.encode(lat, forKey: .lat)
        try container.encode(lon, forKey: .lon)
        try container.encode(country, forKey: .country)
        try container.encode(state, forKey: .state)
    }
}

struct LocalNames: Codable {
    var ru: String?
}
