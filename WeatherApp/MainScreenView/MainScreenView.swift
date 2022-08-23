//
//  ContentView.swift
//  WeatherApp
//
//  Created by Егор Шилов on 19.08.2022.
//

import SwiftUI

struct MainScreenView: View {
    
    @StateObject private var viewModel = MainScreenViewModel()
    
    var body: some View {
        VStack {
            HStack {

                Searchbar(cityNameForRequest: .constant(""))
                    .disabled(true)
                    .onTapGesture {
                        viewModel.cleanCityNameSearch()
                        viewModel.toggleIsSearchCityPresented()
                    }
                
                Button {
                    viewModel.toggleIsFavoriteButton()
                } label: {
                    Image(systemName: "heart.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .padding(.trailing, 16)
                        .foregroundColor(viewModel.isFavoriteCity ? .red : .gray)
                }
            }
            
            MainScreenList(viewModel: viewModel)
                .listStyle(.insetGrouped)
        }
        .background(Color(.systemGray6))
        .fullScreenCover(isPresented: $viewModel.isSearchCityViewPresented) {
            SearchCityView(viewModel: viewModel)
        }
        .onAppear {
            UITableView.appearance().showsVerticalScrollIndicator = false
        }
    }
}

struct MainScreenView_Previews: PreviewProvider {
    static var previews: some View {
        MainScreenView()
    }
}
