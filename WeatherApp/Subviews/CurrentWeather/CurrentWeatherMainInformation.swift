//
//  CurrentWeather.swift
//  WeatherApp
//
//  Created by Егор Шилов on 19.08.2022.
//

import SwiftUI

struct CurrentWeatherMainInformation: View {
        
    let imageName: String
    let cityName: String
    let wheatherDesctiption: String
    let temperature: String
    
    var body: some View {
        VStack {
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
            .frame(width: 50, height: 50)
            
            Text(cityName)
                .bold()
                .multilineTextAlignment(.center)
                .font(.system(size: 32))
                .padding(.horizontal, 16)
            
            Text(wheatherDesctiption)
            
            Text(temperature)
                .font(.system(size: 150))
                .fontWeight(.thin)
                .padding(.top, 16)
        }
    }
}

struct CurrentWeatherMainInformation_Previews: PreviewProvider {
    static var previews: some View {
        CurrentWeatherMainInformation(imageName: "sun.max", cityName: "Москва", wheatherDesctiption: "Облачно", temperature: "32")
    }
}
