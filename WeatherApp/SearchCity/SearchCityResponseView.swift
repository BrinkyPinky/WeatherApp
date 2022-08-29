//
//  SearchCityResponseView.swift
//  WeatherApp
//
//  Created by Егор Шилов on 30.08.2022.
//

import SwiftUI

struct SearchCityResponseView: View {
    var viewModel: SearchCityResponseViewModel
    
    var body: some View {
        HStack {
            Text(viewModel.cityName)
            Spacer()
            Text(viewModel.cityCountry)
            Text(viewModel.cityState)
        }
    }
}

