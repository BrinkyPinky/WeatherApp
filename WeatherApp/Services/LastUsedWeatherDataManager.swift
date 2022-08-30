//
//  LastUsedWeatherDataManager.swift
//  WeatherApp
//
//  Created by Егор Шилов on 30.08.2022.
//

import Foundation



class LastUsedWeatherDataManager {
    
    static let shared = LastUsedWeatherDataManager()
    
    let standard = UserDefaults.standard
    
    func fetchData() -> (CityModel?, WeatherModel?, [ForecastViewModel]?) {
        var cityModel: CityModel?
        var weatherModel: WeatherModel?
        var forecastViewModel: [ForecastViewModel]?
        
        
        if let data = UserDefaults.standard.value(forKey: "LastUsedCityModel") as? Data {
            let cityData = try? PropertyListDecoder().decode(CityModel.self, from: data)
            cityModel = cityData
        }
        
        if let data = UserDefaults.standard.value(forKey: "LastUsedWeatherModel") as? Data {
            let weatherData = try? PropertyListDecoder().decode(WeatherModel.self, from: data)
            weatherModel = weatherData
        }
        
        if let data = UserDefaults.standard.value(forKey: "LastUsedForecastModel") as? Data {
            let forecastData = try? PropertyListDecoder().decode([ForecastViewModel].self, from: data)
            forecastViewModel = forecastData
        }
        
        return (cityModel, weatherModel, forecastViewModel)
    }
    
    func saveData(cityModel: CityModel, weatherModel: WeatherModel, forecastModel: [ForecastViewModel]) {
        
        
        //        print("citymodel: \(cityModel)")
        //        print("weathermodel: \(weatherModel)")
        //        print("forecastModel: \(forecastModel.first?.imageName)")
        
        UserDefaults.standard.set(try? PropertyListEncoder().encode(cityModel), forKey: "LastUsedCityModel")
        UserDefaults.standard.set(try? PropertyListEncoder().encode(weatherModel), forKey: "LastUsedWeatherModel")
        UserDefaults.standard.set(try? PropertyListEncoder().encode(forecastModel), forKey: "LastUsedForecastModel")
        
        print("eqw")
        
        
    }
}
