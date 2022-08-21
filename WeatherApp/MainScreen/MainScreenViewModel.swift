//
//  MainScreenViewModel.swift
//  WeatherApp
//
//  Created by Егор Шилов on 19.08.2022.
//

import Foundation

class MainScreenViewModel: ObservableObject {
    
    // MARK: SearchCityView Properties:
    
    @Published var citiesNamesForSearchList: [CityModel] = []
    @Published var isSearchCityViewPresented = false
    
    // User Interaction With Search TextField
    @Published var cityNameSearch = "" {
        didSet {
            doRequestForCities()
        }
    }
    
    // City that was picked by User
    @Published var currentCity = CityModel(
        localNames: LocalNames(ru: "Москва"),
        lat: nil,
        lon: nil
    ) {
        didSet {
            doRequestForForecast()
            doRequestForCurrentWeather()
        }
    }
    
    // MARK: CurrentWeather Properties:
    
    @Published var currentWeather = WeatherModel(
        weather: [Weather(description: "Нет данных", icon: "Нет данных")],
        main: Main(temp: 0, feelsLike: 0, humidity: 0),
        visibility: 0,
        name: "Нет данных",
        dt: Date(),
        timezone: 0
    )
    
    var cityNameForCurrentWeather: String {
        "\(currentCity.localNames?.ru ?? currentCity.name ?? "")"
    }
    
    var descriptionForCurrentWeather: String {
        "\(currentWeather.weather.first?.description?.capitalizingFirstLetter() ?? "")"
    }
    
    var temperatureForCurrentWeather: String {
        "\(lroundf(currentWeather.main.temp ?? 0))°"
    }
    
    var feelsLikeForCurrentWeather: String {
        "\(lroundf(currentWeather.main.feelsLike ?? 0))°"
    }
    
    var visibilityForCurrentWeather: String {
        "\(currentWeather.visibility/1000) км"
    }
    
    var humidityForCurrentWeather: String {
        "\(lroundf(currentWeather.main.humidity ?? 0))%"
    }
    
    // MARK: Forecast Properties:
    
    @Published var columnsForForecast = [ForecastViewModel]()

    
    // MARK: SearchCityView Methods:
    
    func toggleIsSearchCityPresented() {
        isSearchCityViewPresented.toggle()
    }
    
    func cleanCityNameSearch() {
        cityNameSearch = ""
    }
    
    func doRequestForCities() {
        let cityName = NSMutableString(string: cityNameSearch) as CFMutableString
        CFStringTransform(cityName, nil, "Any-Latin; Latin-ASCII; Any-Lower;" as CFString, false)
        
        NetworkManager.shared.requestCities(cityName: cityName as String) { [unowned self] cities in
            citiesNamesForSearchList = cities
        }
    }
    
    // MARK: CurrentWeather Methods:
    
    func doRequestForCurrentWeather() {
        NetworkManager.shared.requestCurrentWeather(lat: currentCity.lat ?? 55.7522, lon: currentCity.lon ?? 37.6156) { [unowned self] weather in
            currentWeather = weather
        }
    }
    
    // MARK: Forecast Methods:
    
    func doRequestForForecast() {
        NetworkManager.shared.requestForecast(lat: currentCity.lat ?? 55.7522, lon: currentCity.lon ?? 37.6156) { [unowned self] forecast in
            
            columnsForForecast = []
            forecast.forEach { [unowned self] weatherModel in
                let forecastViewModel = ForecastViewModel(forecast: weatherModel, timezone: currentWeather.timezone ?? 0)
                columnsForForecast.append(forecastViewModel)
            }
        }
    }
    
    // MARK: General Methods:
    
    func getIconName() -> String {
        switch currentWeather.weather.first?.icon {
        case "01d": return "sun.max.fill"
        case "02d": return "cloud.sun.fill"
        case "03d": return "cloud.fill"
        case "04d": return "cloud.fill"
        case "09d": return "cloud.rain.fill"
        case "10d": return "cloud.sun.rain.fill"
        case "11d": return "cloud.bolt.fill"
        case "13d": return "cloud.snow.fill"
        case "50d": return "cloud.fog.fill"
        case "01n": return "moon.fill"
        case "02n": return "cloud.moon.fill"
        case "03n": return "cloud.fill"
        case "04n": return "cloud.fill"
        case "09n": return "cloud.rain.fill"
        case "10n": return "cloud.moon.rain.fill"
        case "11n": return "cloud.bolt.fill"
        case "13n": return "cloud.snow.fill"
        case "50n": return "cloud.fog.fill"
        default: return ""
        }
    }
}
