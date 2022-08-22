//
//  CurrentWeatherAdditionalElement.swift
//  WeatherApp
//
//  Created by Егор Шилов on 19.08.2022.
//

import SwiftUI

struct CurrentWeatherAdditionalElement: View {
    let systemNameOfImage: String
    let labelText: String
    let additionalText: String
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: systemNameOfImage)
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
            Text(labelText)
                .bold()
            Text(additionalText)
        }
    }
}
