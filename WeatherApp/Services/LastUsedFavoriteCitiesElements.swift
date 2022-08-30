//
//  LastUsedFavoriteCitiesElements.swift
//  WeatherApp
//
//  Created by Егор Шилов on 30.08.2022.
//

import Foundation

class LastUsedFavoriteCitiesElements {
    static let shared = LastUsedFavoriteCitiesElements()
    
    private let standard = UserDefaults.standard
    
    func getData(completion: @escaping ([FavoriteCityElementViewModel]?) -> Void) {
        var favoriteCities: [FavoriteCityElementViewModel]?
        
        if let data = UserDefaults.standard.value(forKey: "LastUsedFavoriteCities") as? Data {
            let favoriteCitiesData = try? PropertyListDecoder().decode([FavoriteCityElementViewModel].self, from: data)
            favoriteCities = favoriteCitiesData
        }
        
        completion(favoriteCities)
    }
    
    func saveData(favoriteCityElementViewModels: [FavoriteCityElementViewModel]) {
        UserDefaults.standard.set(try? PropertyListEncoder().encode(favoriteCityElementViewModels), forKey: "LastUsedFavoriteCities")
    }
}
