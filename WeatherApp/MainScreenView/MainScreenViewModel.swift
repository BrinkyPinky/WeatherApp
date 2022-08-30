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
        cityNameForElement: "Нет данных (Ваша геопозиция)"
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
                codeForAlert = .internetConnection
                alertIsPresented.toggle()
            }
        }
    }
    // MARK: AlertPresentation:
    
    var messageForAlert: String {
        switch codeForAlert {
        case .internetConnection: return "Похоже с вашим подключением что-то не так!"
        case .limitOfFavoriteCities: return "Вы не можете добавить более 10 городов в избранные!"
        case .geolocationCity: return "Ваша геопозиция уже находится в списке избранных!"
        case .general: return "Похоже что-то пошло не так, попробуйте позже еще раз!"
        }
    }
    
    var codeForAlert: AlertCodes = .internetConnection
    
    enum AlertCodes {
        case internetConnection, limitOfFavoriteCities, geolocationCity, general
    }
    
    @Published var alertIsPresented = false
    
    // MARK: FavoriteCitiesView Stored and Published Properties:
    
    @Published var rowsForFavoriteCityElement = [FavoriteCityElementViewModel]() {
        didSet {
            if rowsForFavoriteCityElement.count == cities.count {
                LastUsedFavoriteCitiesElements.shared.saveData(
                    favoriteCityElementViewModels: rowsForFavoriteCityElement
                )
            }
        }
    }
    
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
            codeForAlert = .internetConnection
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
    ) {
        didSet {
            loadFavoriteButton()
        }
    }
    
    func doRequestForCurrentWeather() {
        if currentCity.lat == 0 && currentCity.lon == 0 {
            currentWeatherViewModel = CurrentWeatherViewModel(currentWeather: plugWeatherModel, currentCity: plugCityModel)
            return
        }
            
        NetworkManager.shared.requestCurrentWeather(lat: currentCity.lat ?? 0, lon: currentCity.lon ?? 0) { [unowned self] weather in
            
            currentWeatherViewModel = CurrentWeatherViewModel(currentWeather: weather, currentCity: currentCity)
        } errorCompletion: { [unowned self] _ in
            codeForAlert = .internetConnection
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
                codeForAlert = .internetConnection
                alertIsPresented.toggle()
            }
        }
    }
    
    func deleteFavoriteCity(at indexSet: IndexSet) {
        DataManager.shared.deleteCityByIndexSet(indexSet: indexSet)
        rowsForFavoriteCityElement.remove(at: indexSet.first ?? 0)
        loadFavoriteButton()
        LastUsedFavoriteCitiesElements.shared.saveData(
            favoriteCityElementViewModels: rowsForFavoriteCityElement
        )
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
        DataManager.shared.fetchCities()
        
        let savedCities = DataManager.shared.savedCities
        
        if isFavoriteCity == true {
            
            guard savedCities.count < 10 else {
                isFavoriteCity = false
                codeForAlert = .limitOfFavoriteCities
                alertIsPresented.toggle()
                return
            }
            
            guard !currentWeatherViewModel.cityNameForCurrentWeather.contains("(Ваша геопозиция)") else {
                isFavoriteCity = false
                codeForAlert = .geolocationCity
                alertIsPresented.toggle()
                return
            }
            
            guard !currentWeatherViewModel.cityNameForCurrentWeather.contains("Нет данных") else {
                isFavoriteCity = false
                codeForAlert = .general
                alertIsPresented.toggle()
                return
            }
            
            DataManager.shared.addCity(
                cityName: currentWeatherViewModel.cityNameForCurrentWeather,
                lat: currentWeatherViewModel.currentWeather.coord?.lat ?? 0,
                lon: currentWeatherViewModel.currentWeather.coord?.lon ?? 0
            )
        } else {
            DataManager.shared.deleteCity(
                cityName: currentWeatherViewModel.cityNameForCurrentWeather
            )
            doRequestForWeather()
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
        if currentCity.lat == 0 && currentCity.lon == 0 {
            rowsForForecast = []
            return
        }

        NetworkManager.shared.requestForecast(lat: currentCity.lat ?? 0, lon: currentCity.lon ?? 0) { [unowned self] forecast in
            rowsForForecast = []

            forecast.forEach { [unowned self] weatherModel in
                let forecastViewModel = ForecastViewModel(forecast: weatherModel, timezone: currentWeatherViewModel.currentWeather.timezone ?? 0)
                rowsForForecast.append(forecastViewModel)
            }
        } errorCompletion: { [unowned self] _ in
            codeForAlert = .internetConnection
            alertIsPresented.toggle()
        }
    }
}


// MARK: onAppearMainScreen
extension MainScreenViewModel {
    func onInitMainScreen() {
        getUserLocation()
        
        LastUsedWeatherDataManager.shared.getData { [unowned self] cityModel, weatherModel, forecastViewModels in
            if cityModel != nil && weatherModel != nil && forecastViewModels != nil {
                currentCity = cityModel!
                currentWeatherViewModel = CurrentWeatherViewModel(
                    currentWeather: weatherModel!,
                    currentCity: cityModel!
                )
                rowsForForecast = forecastViewModels!
            }
        }
        
        LastUsedFavoriteCitiesElements.shared.getData { [unowned self] favoriteCityElementViewModel in
            guard favoriteCityElementViewModel != nil else { return }
            rowsForFavoriteCityElement = favoriteCityElementViewModel!
        }
    }
}
