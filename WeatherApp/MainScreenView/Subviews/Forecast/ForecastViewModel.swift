//
//  ForecastViewModel.swift
//  WeatherApp
//
//  Created by Егор Шилов on 20.08.2022.
//

import Foundation

class ForecastViewModel: ObservableObject, Codable {
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
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(forecast, forKey: .forecast)
        try container.encode(timezone, forKey: .timezone)
        try container.encode(id, forKey: .id)
    }
}
