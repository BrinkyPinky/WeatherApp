//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by Егор Шилов on 19.08.2022.
//

import Alamofire

class NetworkManager {
    
    static let shared = NetworkManager()
    
    // MARK: Request api for forecast
    
    func requestForecast(lat: Double, lon: Double, completion: @escaping ([WeatherModel]) -> Void) {
        let url = "https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)&appid=a4438b663ba159961dbcaed12f9993f7&lang=ru&units=metric"
        
        AF.request(url).responseDecodable(of: ForecastModel.self) { response in
            switch response.result {
            case .success(let data):
                completion(data.list)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: Request api for current weather
    
    func requestCurrentWeather(lat: Double, lon: Double, completion: @escaping (WeatherModel) -> Void) {
        
        let url = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=a4438b663ba159961dbcaed12f9993f7&lang=ru&units=metric"
        
        AF.request(url).responseDecodable(of: WeatherModel.self) { response in
            switch response.result {
            case .success(let data):
                completion(data)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: Request api for city name and coordinates
    
    func requestCities(cityName: String, completion: @escaping ([CityModel]) -> Void) {
        let url = "https://api.openweathermap.org/geo/1.0/direct?q=\(cityName)&limit=10&appid=a4438b663ba159961dbcaed12f9993f7"
        AF.request(url).responseDecodable(of: [CityModel].self) { response in
            switch response.result {
            case .success(let data):
                completion(data)
            case .failure(let error):
                print(error)
            }
        }
    }
}
