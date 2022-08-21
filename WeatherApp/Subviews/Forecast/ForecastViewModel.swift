//
//  ForecastViewModel.swift
//  WeatherApp
//
//  Created by Егор Шилов on 20.08.2022.
//

import Foundation

protocol ForecastViewModelProtocol {
    var id: UUID { get }
    var temperature: String { get }
    var date: String { get }
    var imageName: String { get }
    var additionalDate: String { get }
    init(forecast: WeatherModel, timezone: Int)
}

class ForecastViewModel: ForecastViewModelProtocol, ObservableObject {
    var id = UUID()
    
    var temperature: String {
        "\(lroundf(forecast.main.temp ?? 0))°"
    }
    
    var date: String {
        let date = Date(timeIntervalSince1970: forecast.dt.timeIntervalSinceReferenceDate)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH a"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: timezone)
        
        
        return "\(dateFormatter.string(from: date))"
    }
    
    var additionalDate: String {
        let date = Date(timeIntervalSince1970: forecast.dt.timeIntervalSinceReferenceDate)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, d MMM"
        
        //            let dateFormatter = DateFormatter()
        //            dateFormatter.dateFormat = "E, d MMM"
        //            dateFormatter.timeZone = TimeZone(secondsFromGMT: timezone)
        //            dateFormatter.locale = Locale(identifier: "ru_RU")
        
        
        return "\(dateFormatter.string(from: date))"
    }
    
    var imageName: String {
        switch forecast.weather.first?.icon {
        case "01d": return "sun.max.fill"
        case "02d": return "cloud.sun.fill"
        case "03d": return "cloud.fill"
        case "04d": return "cloud.fill"
        case "09d": return "cloud.rain.fill"
        case "10d": return "cloud.sun.rain.fill"
        case "11d": return "cloud.bolt.fill"
        case "13d": return "cloud.snow.fill"
        case "50d": return "cloud.fog.fill"
        case "01n": return "moon.fill"
        case "02n": return "cloud.moon.fill"
        case "03n": return "cloud.fill"
        case "04n": return "cloud.fill"
        case "09n": return "cloud.rain.fill"
        case "10n": return "cloud.moon.rain.fill"
        case "11n": return "cloud.bolt.fill"
        case "13n": return "cloud.snow.fill"
        case "50n": return "cloud.fog.fill"
        default: return ""
        }
    }
    
    private var forecast: WeatherModel
    private var timezone: Int
    
    required init(forecast: WeatherModel, timezone: Int) {
        self.forecast = forecast
        self.timezone = timezone
    }
}
