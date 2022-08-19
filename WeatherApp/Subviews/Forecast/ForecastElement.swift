//
//  ForecastElement.swift
//  WeatherApp
//
//  Created by Егор Шилов on 19.08.2022.
//

import SwiftUI

struct ForecastElement: View {
    let temperature: String
    let imageName: String
    let time: Text
    
    var body: some View {
        VStack(spacing: 8) {
            Text("\(temperature)°")
            Image(systemName: imageName)
                .renderingMode(.original)
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
            time
        }
        .padding()
        .background(.quaternary)
        .cornerRadius(20)
    }
}

struct ForecastElement_Previews: PreviewProvider {
    static var previews: some View {
        ForecastElement(temperature: "2", imageName: "sun.max.fill", time: Text("2 AM"))
    }
}
