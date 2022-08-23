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
        dateFormatter.dateFormat = "E, d MMM hh a"
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: timezone)
        
        
        return "\(dateFormatter.string(from: date))"
    }
    
    var imageName: String {
        IconManager.shared.getIconName(from: forecast.weather.first?.icon ?? "")
    }
    
    private var forecast: WeatherModel
    private var timezone: Int
    
    required init(forecast: WeatherModel, timezone: Int) {
        self.forecast = forecast
        self.timezone = timezone
    }
}
