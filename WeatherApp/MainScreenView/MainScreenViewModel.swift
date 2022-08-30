//
//  MainScreenViewModel.swift
//  WeatherApp
//
//  Created by Егор Шилов on 19.08.2022.
//

import Foundation

let plugWeatherModel = WeatherModel(
    coord: Coord(lon: 0, lat: 0),
    weather: [Weather(description: "Нет данных", icon: nil)],
    main: Main(temp: 0, feelsLike: 0, humidity: 0),
    visibility: 0,
    name: "Нет данных",
    dt: Date(),
    timezone: 0
)

let plugCityModel = CityModel(
    name: nil,
    localNames: LocalNames(ru: "Нет данных"),
    lat: 0,
    lon: 0,
    country: "Нет данных",
    state: "Нет данных"
)

class MainScreenViewModel: ObservableObject {
    
    // MARK: Get User Location
    
    var locationFavoriteCityElementViewModel = FavoriteCityElementViewModel(
        weatherForElement: plugWeatherModel,
        cityNameForElement: "Не удалось определить геопозицию"
    )
    
    private var userLocation: LocationModel? {
        didSet {
            changeWeatherByUserGeoposition()
        }
    }
    
    private var locationWeather = [WeatherModel]() {
        didSet {
            locationFavoriteCityElementViewModel = FavoriteCityElementViewModel(
                weatherForElement: locationWeather.first ?? plugWeatherModel,
                cityNameForElement: "\(locationWeather.first?.name ?? "Нет данных") (Ваша геопозиция)"
            )
        }
    }
    
    func getUserLocation() {
        LocationManager.shared.getUserLocation { [unowned self] location in
            userLocation = location
        }
    }
    
    private func changeWeatherByUserGeoposition() {
        if (userLocation?.latitude ?? 0) != 0 && (userLocation?.longitude ?? 0) != 0 {
            
            NetworkManager.shared.requestCurrentWeather(lat: Float(userLocation?.latitude ?? 0), lon: Float(userLocation?.longitude ?? 0)) { [unowned self] weatherModel in
                locationWeather.append(weatherModel)
            } errorCompletion: { [unowned self] _ in
                alertIsPresented.toggle()
            }
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
    
    @Published var isSearchCityViewPresented = false
    
    // User Interaction With Search TextField
    @Published var cityNameSearch = "" {
        didSet {
            doRequestForCities()
        }
    }
    
    // City that was picked by User
    @Published var currentCity = plugCityModel {
        didSet {
            doRequestForForecast()
            doRequestForCurrentWeather()
        }
    }
    
    func toggleIsSearchCityPresented() {
        isSearchCityViewPresented.toggle()
    }
    
    func cleanCityNameSearch() {
        cityNameSearch = ""
    }
    
    @Published var searchCityResponseViewModel: [SearchCityResponseViewModel] = []
    
    func doRequestForCities() {
        let cityName = NSMutableString(string: cityNameSearch) as CFMutableString
        CFStringTransform(cityName, nil, "Any-Latin; Latin-ASCII; Any-Lower;" as CFString, false)
        
        NetworkManager.shared.requestCities(cityName: cityName as String) { [unowned self] cities in
            searchCityResponseViewModel = []
            
            cities.forEach { cityModel in
                searchCityResponseViewModel.append(SearchCityResponseViewModel(cityModel: cityModel))
            }
        } errorCompletion: { [unowned self] _ in
            alertIsPresented.toggle()
        }
    }
    
    // MARK: Forecast Published Properties:
    
    @Published var rowsForForecast = [ForecastViewModel]() {
        didSet {
            if rowsForForecast.count == 40 {
                LastUsedWeatherDataManager.shared.saveData(
                    cityModel: currentCity,
                    weatherModel: currentWeatherViewModel.currentWeather,
                    forecastModel: rowsForForecast
                )
            }
        }
    }
    
    // MARK: CurrentWeather Published Properties:
    
    @Published var currentWeatherViewModel = CurrentWeatherViewModel(
        currentWeather: plugWeatherModel,
        currentCity: plugCityModel
    )
    
    func doRequestForCurrentWeather() {
        if currentCity.lat == 0 && currentCity.lon == 0 {
            currentWeatherViewModel = CurrentWeatherViewModel(currentWeather: plugWeatherModel, currentCity: plugCityModel)
            return
        }
            
        NetworkManager.shared.requestCurrentWeather(lat: currentCity.lat ?? 0, lon: currentCity.lon ?? 0) { [unowned self] weather in
            
            currentWeatherViewModel = CurrentWeatherViewModel(currentWeather: weather, currentCity: currentCity)
        } errorCompletion: { [unowned self] _ in
            alertIsPresented.toggle()
        }
    }
}

// MARK: FavoriteCitiesView methods:

extension MainScreenViewModel {
    
    func toggleIsFavoriteCitiesViewPresented() {
        isFavoriteCitiesViewPresented.toggle()
    }
    
    func onAppearFavoriteCitiesView() {
        getUserLocation()
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
        loadFavoriteButton()
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
                cityName: currentWeatherViewModel.cityNameForCurrentWeather,
                lat: currentWeatherViewModel.currentWeather.coord?.lat ?? 0,
                lon: currentWeatherViewModel.currentWeather.coord?.lon ?? 0
            )
        } else {
            DataManager.shared.deleteCity(
                cityName: currentWeatherViewModel.cityNameForCurrentWeather
            )
        }
    }
    
    func loadFavoriteButton() {
        DataManager.shared.fetchCities()
        
        let savedCities = DataManager.shared.savedCities
        
        if savedCities.contains(where: {$0.cityName == currentWeatherViewModel.cityNameForCurrentWeather}) {
            isFavoriteCity = true
        } else {
            isFavoriteCity = false
        }
    }
}

// MARK: Forecast Properties and Methods:

extension MainScreenViewModel {
    
    func doRequestForForecast() {
        
        rowsForForecast = []
        if currentCity.lat == 0 && currentCity.lon == 0 { return }

        NetworkManager.shared.requestForecast(lat: currentCity.lat ?? 0, lon: currentCity.lon ?? 0) { [unowned self] forecast in
            forecast.forEach { [unowned self] weatherModel in
                let forecastViewModel = ForecastViewModel(forecast: weatherModel, timezone: currentWeatherViewModel.currentWeather.timezone ?? 0)
                rowsForForecast.append(forecastViewModel)
            }
        } errorCompletion: { [unowned self] _ in
            alertIsPresented.toggle()
        }
    }
}
