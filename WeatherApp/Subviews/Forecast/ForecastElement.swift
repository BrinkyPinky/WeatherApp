//
//  ForecastElement.swift
//  WeatherApp
//
//  Created by Егор Шилов on 19.08.2022.
//

import SwiftUI

struct ForecastElement: View {
    @ObservedObject var viewModel: ForecastViewModel
    
    var body: some View {
        VStack {
            Text(viewModel.additionalDate)
            VStack(spacing: 8) {
                Text(viewModel.temperature)
                Image(systemName: viewModel.imageName)
                    .renderingMode(.original)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                Text(viewModel.date)
            }
            .padding()
            .background(.quaternary)
        .cornerRadius(20)
        }
    }
}
