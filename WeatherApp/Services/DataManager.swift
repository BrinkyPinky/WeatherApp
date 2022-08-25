//
//  DataManager.swift
//  WeatherApp
//
//  Created by Егор Шилов on 22.08.2022.
//

import CoreData

class DataManager {
    
    static let shared = DataManager()
    
    let container = NSPersistentContainer(name: "CitiesContainer")
    
    var savedCities: [CityEntity] = []
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core data error initialization: \(error)")
            }
        }

        fetchCities()
        print(savedCities)
    }
    
    func addCity(cityName: String, lat: Float, lon: Float) {
        let newCity = CityEntity(context: container.viewContext)
        newCity.cityName = cityName
        newCity.lat = lat
        newCity.lon = lon
        saveDate()
    }
    
    func deleteCityByIndexSet(indexSet: IndexSet) {
        let index = indexSet.first
        let cityToDelete = savedCities[index ?? 0]
        container.viewContext.delete(cityToDelete)
        saveDate()
    }
    
    func deleteCity(cityName: String) {
        guard let deleteCity = savedCities.first(where: { $0.cityName == cityName }) else { return }
        
        container.viewContext.delete(deleteCity)
        saveDate()
    }
    
    func fetchCities() {
        let request = NSFetchRequest<CityEntity>(entityName: "CityEntity")
        
        do {
            savedCities = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching entity: \(error)")
        }
    }
    
    func saveDate() {
        do {
            try container.viewContext.save()
            fetchCities()
        } catch let error {
            print("Error saving entity: \(error)")
        }
    }
}
