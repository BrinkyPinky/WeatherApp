//
//  IconManager.swift
//  WeatherApp
//
//  Created by Егор Шилов on 23.08.2022.
//

import Foundation

class IconManager {
    static let shared = IconManager()
    
    func getIconName(from text: String) -> String {
        switch text {
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
        default: return "questionmark.circle"
        }
    }
}
