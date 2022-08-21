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
        HStack() {
            CurrentWeatherAdditionalElement(
                systemNameOfImage: "thermometer",
                labelText: "Ощущается",
                additionalText: feelsLike
            )
            Spacer()
            CurrentWeatherAdditionalElement(
                systemNameOfImage: "eye",
                labelText: "Видимость",
                additionalText: visibility
            )
                      Spacer()
            CurrentWeatherAdditionalElement(
                systemNameOfImage: "drop",
                labelText: "Влажность",
                additionalText: humidity
            )
        }
    }
}

struct CurrentWeatherAdditionalInformation_Previews: PreviewProvider {
    static var previews: some View {
        CurrentWeatherAdditionalInformation(feelsLike: "12", visibility: "50", humidity: "100%")
    }
}
