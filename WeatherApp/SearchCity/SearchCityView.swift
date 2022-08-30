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
            AlertView(isPresented: $viewModel.alertIsPresented, message: viewModel.messageForAlert)
            HStack {
                Searchbar(cityNameForRequest: $viewModel.cityNameSearch)
                Button("Cancel") {
                    viewModel.toggleIsSearchCityPresented()
                }
                .padding(.trailing, 16)
            }
            
            Spacer()
            
            List(viewModel.searchCityResponseViewModel, id: \.id) { SearchCityResponseViewModel in
                
                Button {
                    viewModel.currentCity = SearchCityResponseViewModel.cityModel
                    viewModel.cleanCityNameSearch()
                    viewModel.toggleIsSearchCityPresented()
                } label: {
                    SearchCityResponseView(viewModel: SearchCityResponseViewModel)
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
