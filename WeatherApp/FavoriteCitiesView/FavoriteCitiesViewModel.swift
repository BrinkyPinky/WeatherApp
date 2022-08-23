//
//  FavoriteCitiesViewModel.swift
//  WeatherApp
//
//  Created by Егор Шилов on 23.08.2022.
//

import Foundation
import SwiftUI



class FavoriteCitiesViewModel: ObservableObject {
    
    @Published var rowsForFavoriteCityElement = [FavoriteCityElementViewModel]()
    
    private var cities: [CityEntity] = []
    
    var favoriteCitiesWeather: [WeatherModel] = [] {
        didSet {
            if favoriteCitiesWeather.count == cities.count {
                rowsForFavoriteCityElement = []
                
                favoriteCitiesWeather.forEach { weatherModel in
                    let favoriteCityElementViewModel = FavoriteCityElementViewModel(weatherForElement: weatherModel)
                    rowsForFavoriteCityElement.append(favoriteCityElementViewModel)
                }
            }
        }
    }

    
    func onApper() {
        DataManager.shared.fetchCities()
        cities = DataManager.shared.savedCities
        doRequestForWeather()
    }
    
    func doRequestForWeather() {
        favoriteCitiesWeather = []
        
        cities.forEach { CityEntity in
            NetworkManager.shared.requestCurrentWeather(lat: CityEntity.lat, lon: CityEntity.lon) { [unowned self] weatherModel in
                favoriteCitiesWeather.append(weatherModel)
            }
        }
    }
    
    func deleteFavoriteCity(at indexSet: IndexSet) {
        DataManager.shared.deleteCityByIndexSet(indexSet: indexSet)
        rowsForFavoriteCityElement.remove(at: indexSet.first ?? 0)
    }
}
