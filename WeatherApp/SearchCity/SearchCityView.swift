//
//  SearchCityView.swift
//  WeatherApp
//
//  Created by Егор Шилов on 19.08.2022.
//

import SwiftUI

struct SearchCityView: View {
    @ObservedObject var viewModel: MainScreenViewModel
    
    var body: some View {
        VStack {
            AlertView(isPresented: $viewModel.alertIsPresented)
            HStack {
                Searchbar(cityNameForRequest: $viewModel.cityNameSearch)
                Button("Cancel") {
                    viewModel.toggleIsSearchCityPresented()
                }
                .padding(.trailing, 16)
            }
            
            Spacer()
            
            List(viewModel.citiesNamesForSearchList, id: \.lat) { city in
                
                Button {
                    viewModel.currentCity = city
                    viewModel.cleanCityNameSearch()
                    viewModel.toggleIsSearchCityPresented()
                } label: {
                    HStack {
                        Text("\((city.localNames?.ru ?? city.name) ?? "")")
                        Spacer()
                        Text("\(city.country ?? "")")
                        Text("\(city.state ?? "")")
                    }
                }
                .listSectionSeparator(.hidden)
            }
            .listStyle(.plain)
        }
    }
}

struct SearchCityView_Previews: PreviewProvider {
    static var previews: some View {
        SearchCityView(viewModel: MainScreenViewModel())
    }
}
