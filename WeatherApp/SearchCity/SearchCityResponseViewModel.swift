//
//  SearchCityResponseViewModel.swift
//  WeatherApp
//
//  Created by Егор Шилов on 30.08.2022.
//

import Foundation

class SearchCityResponseViewModel {
    
    var id = UUID()
    
    var cityModel: CityModel
    
    init(cityModel: CityModel) {
        self.cityModel = cityModel
    }
    
    var cityName: String {
        "\((cityModel.localNames?.ru ?? cityModel.name) ?? "")"
    }
    
    var cityCountry: String {
        "\(cityModel.country ?? "")"
    }
    
    var cityState: String {
        "\(cityModel.state ?? "")"
    }
}
