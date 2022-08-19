//
//  CurrentWeatherAdditionalInformation.swift
//  WeatherApp
//
//  Created by Егор Шилов on 19.08.2022.
//

import SwiftUI

struct CurrentWeatherAdditionalInformation: View {
    
    let feelsLike: String
    let visibility: String
    let humidity: String
    
    var body: some View {
        HStack(spacing: 32) {
            CurrentWeatherAdditionalElement(
                systemNameOfImage: "thermometer",
                labelText: "Ощущается",
                additionalText: feelsLike
            )
            
            CurrentWeatherAdditionalElement(
                systemNameOfImage: "eye",
                labelText: "Видимость",
                additionalText: visibility
            )
                        
            CurrentWeatherAdditionalElement(
                systemNameOfImage: "drop",
                labelText: "Влажность",
                additionalText: humidity
            )
        }
        .padding()
    }
}
