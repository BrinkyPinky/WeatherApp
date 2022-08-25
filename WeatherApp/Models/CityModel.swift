//
//  CityModel.swift
//  WeatherApp
//
//  Created by Егор Шилов on 19.08.2022.
//

struct CityModel: Decodable {
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
}

struct LocalNames: Decodable {
    var ru: String?
}
