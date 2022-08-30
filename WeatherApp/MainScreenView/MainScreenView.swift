//
//  ContentView.swift
//  WeatherApp
//
//  Created by Егор Шилов on 19.08.2022.
//

import SwiftUI

struct MainScreenView: View {
    
    @ObservedObject private var viewModel = MainScreenViewModel()
    
    init() {
        viewModel.onInitMainScreen()

    }
    
    var body: some View {
        VStack {
            AlertView(isPresented: $viewModel.alertIsPresented, message: viewModel.messageForAlert)
            HStack {
                Button {
                    viewModel.toggleIsFavoriteCitiesViewPresented()
                } label: {
                    Image(systemName: "star.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .padding(.leading, 16)
                }
                
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
        .fullScreenCover(isPresented: $viewModel.isFavoriteCitiesViewPresented) {
            FavoriteCitiesView(viewModel: viewModel)
        }
        .onAppear {
            UITableView.appearance().showsVerticalScrollIndicator = false
//            let path = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true)
//            print(path)
        }
    }
}

struct MainScreenView_Previews: PreviewProvider {
    static var previews: some View {
        MainScreenView()
    }
}
