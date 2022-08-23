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
            Rectangle()
                .foregroundColor(.clear)
                .background(.quaternary)
                .cornerRadius(20)
            HStack {
                VStack(alignment: .leading) {
                    Text(viewModel.cityNameForElement)
                        .bold()
                    Spacer()
                    HStack {
                        Text("Солнечно")
                        Image(systemName: "sun.max.fill")
                    }
                }
                Spacer()
                Text(viewModel.temperatureForElement)
                    .font(.system(size: 32))
            }
            .padding()
        }
        .frame(height: 80)
    }
}
