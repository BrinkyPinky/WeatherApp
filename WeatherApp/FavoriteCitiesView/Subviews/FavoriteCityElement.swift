//
//  FavoriteCityElement.swift
//  WeatherApp
//
//  Created by Егор Шилов on 23.08.2022.
//

import SwiftUI

struct FavoriteCityElement: View {
    
    @ObservedObject var viewModel: FavoriteCityElementViewModel
    
    var body: some View {
        ZStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(viewModel.cityNameForElement)
                        .bold()
                        .padding(.top)
                    Spacer()
                    HStack {
                        Text(viewModel.weatherDescriptionForElement)
                        Image(systemName: viewModel.imageNameForElement)
                    }
                    .padding(.bottom)
                }
                Spacer()
                Text(viewModel.temperatureForElement)
                    .font(.system(size: 32))
            }
        }
        .frame(height: 60)
    }
}
