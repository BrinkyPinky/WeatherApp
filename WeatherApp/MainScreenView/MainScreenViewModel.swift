//
//  MainScreenViewModel.swift
//  WeatherApp
//
//  Created by Егор Шилов on 19.08.2022.
//

import Foundation
import CoreLocation
import Alamofire

class MainScreenViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    // MARK: Get User Location
    
    private let manager = CLLocationManager()
    
    @Published var locationFavoriteCityElementViewModel = FavoriteCityElementViewModel(weatherForElement: WeatherModel(coord: nil, weather: [Weather(description: nil, icon: nil)], main: Main(temp: nil, feelsLike: nil, humidity: nil), visibility: 0, name: nil, dt: Date(), timezone: nil), cityNameForElement: "Не удалось определить геопозицию")
    
    private var userLocation: CLLocationCoordinate2D? {
        didSet {
            changeWeatherByUserGeoposition()
        }
    }
    
    override init() {
        super.init()
        self.manager.delegate = self
        self.manager.requestAlwaysAuthorization()
    }
    
    func getUserLocation() {
        manager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last?.coordinate
        userLocation = location
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    var locationWeather = [WeatherModel]() {
        didSet {
            locationFavoriteCityElementViewModel = FavoriteCityElementViewModel(weatherForElement: locationWeather.first ?? WeatherModel(coord: nil, weather: [Weather(description: nil, icon: nil)], main: Main(temp: nil, feelsLike: nil, humidity: nil), visibility: 0, name: nil, dt: Date(), timezone: nil), cityNameForElement: "\(locationWeather.first?.name ?? "Нет данных") (Ваша геопозиция)")
        }
    }
    
    private func changeWeatherByUserGeoposition() {
        NetworkManager.shared.requestCurrentWeather(lat: Float(userLocation?.latitude ?? 0), lon: Float(userLocation?.longitude ?? 0)) { [unowned self] weatherModel in
            locationWeather.append(weatherModel)
        } errorCompletion: { [unowned self] _ in
            alertIsPresented.toggle()
        }
    }
    // MARK: AlertPresentation:
    
    @Published var alertIsPresented = false
    
    // MARK: FavoriteCitiesView Stored and Published Properties:
    
    @Published var rowsForFavoriteCityElement = [FavoriteCityElementViewModel]()
    
    
    @Published var isFavoriteCitiesViewPresented = false
    
    private var cities: [CityEntity] = []
    
    var favoriteCitiesWeather: [WeatherModel] = [] {
        didSet {
            if favoriteCitiesWeather.count == cities.count {
                rowsForFavoriteCityElement = []
                var sortedFavoriteCitiesWeather = [WeatherModel]()
                
                
                for city in cities {
                    for favoriteCity in favoriteCitiesWeather {
                        let cityLat = String(format: "%.2f", city.lat)
                        let cityLon = String(format: "%.2f", city.lon)
                        let favoriteCityLat = String(format: "%.2f", Double((favoriteCity.coord?.lat)!))
                        let favoriteCityLon = String(format: "%.2f", Double((favoriteCity.coord?.lon)!))

                        if cityLat == favoriteCityLat && cityLon == favoriteCityLon {
                            sortedFavoriteCitiesWeather.append(favoriteCity)
                        }
                    }
                }
                sortedFavoriteCitiesWeather.forEach { weatherModel in
                    let index = sortedFavoriteCitiesWeather.firstIndex(where: {$0 == weatherModel})
                    let cityName = cities[index ?? 0].cityName
                    
                    let favoriteCityElementViewModel = FavoriteCityElementViewModel(weatherForElement: weatherModel, cityNameForElement: cityName ?? "Нет данных")
                    rowsForFavoriteCityElement.append(favoriteCityElementViewModel)
                }
            }
        }
    }
    
    // MARK: IsFavoriteCity Published Properties:
    
    @Published var isFavoriteCity: Bool = false
    
    // MARK: SearchCityView Published Properties:
    
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
        localNames: LocalNames(ru: "Нет данных"),
        lat: nil,
        lon: nil
    ) {
        didSet {
            loadCitiesFromDataManager()
            doRequestForForecast()
            doRequestForCurrentWeather()
        }
    }
    
    // MARK: Forecast Published Properties:
    
    @Published var rowsForForecast = [ForecastViewModel]()
    
    // MARK: CurrentWeather Published Properties:
    
    @Published var currentWeather = WeatherModel(
        coord: nil,
        weather: [Weather(description: "Нет данных", icon: "Нет данных")],
        main: Main(temp: 0, feelsLike: 0, humidity: 0),
        visibility: 0,
        name: "Нет данных",
        dt: Date(),
        timezone: 0
    )
}

// MARK: FavoriteCitiesView methods:

extension MainScreenViewModel {
    
    func toggleIsFavoriteCitiesViewPresented() {
        isFavoriteCitiesViewPresented.toggle()
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
            } errorCompletion: { [unowned self] _ in
                alertIsPresented.toggle()
            }
        }
    }
    
    func deleteFavoriteCity(at indexSet: IndexSet) {
        DataManager.shared.deleteCityByIndexSet(indexSet: indexSet)
        rowsForFavoriteCityElement.remove(at: indexSet.first ?? 0)
        loadCitiesFromDataManager()
    }
}

// MARK: IsFavoriteCity Properties and Methods:

extension MainScreenViewModel {
    
    func favoriteCityButtonPressed(elementViewModel: FavoriteCityElementViewModel, lat: Float, lon: Float) {
        currentCity = CityModel(
            name: elementViewModel.cityNameForElement,
            localNames: nil,
            lat: lat,
            lon: lon,
            country: nil,
            state: nil
        )
    }
    
    func toggleIsFavoriteButton() {
        isFavoriteCity.toggle()
        addCityToDataManager()
    }
    
    func addCityToDataManager() {
        if isFavoriteCity == true {
            DataManager.shared.addCity(
                cityName: cityNameForCurrentWeather,
                lat: currentWeather.coord?.lat ?? 0,
                lon: currentWeather.coord?.lon ?? 0
            )
        } else {
            DataManager.shared.deleteCity(
                cityName: cityNameForCurrentWeather
            )
        }
    }
    
    func loadCitiesFromDataManager() {
        DataManager.shared.fetchCities()
        
        let savedCities = DataManager.shared.savedCities
        
        if savedCities.contains(where: {$0.cityName == cityNameForCurrentWeather}) {
            isFavoriteCity = true
        } else {
            isFavoriteCity = false
        }
    }
}

// MARK: SearchCityView Properties and Methods:

extension MainScreenViewModel {
    
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
        } errorCompletion: { [unowned self] _ in
            alertIsPresented.toggle()
        }
    }
}

// MARK: Forecast Properties and Methods:

extension MainScreenViewModel {
    
    func doRequestForForecast() {
        NetworkManager.shared.requestForecast(lat: currentCity.lat ?? 55.7522, lon: currentCity.lon ?? 37.6156) { [unowned self] forecast in
            rowsForForecast = []
            
            forecast.forEach { [unowned self] weatherModel in
                let forecastViewModel = ForecastViewModel(forecast: weatherModel, timezone: currentWeather.timezone ?? 0)
                rowsForForecast.append(forecastViewModel)
            }
        } errorCompletion: { [unowned self] _ in
            alertIsPresented.toggle()
        }
    }
}

// MARK: CurrentWeather Properties and Methods:

extension MainScreenViewModel {
    
    var iconName: String {
        IconManager.shared.getIconName(from: currentWeather.weather.first?.icon ?? "")
    }
    
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
    
    func doRequestForCurrentWeather() {
        NetworkManager.shared.requestCurrentWeather(lat: currentCity.lat ?? 55.7522, lon: currentCity.lon ?? 37.6156) { [unowned self] weather in
            currentWeather = weather
        } errorCompletion: { [unowned self] _ in
            alertIsPresented.toggle()
        }
    }
}
