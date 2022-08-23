//
//  WeatherAppApp.swift
//  WeatherApp
//
//  Created by Егор Шилов on 19.08.2022.
//

import SwiftUI

@main
struct WeatherAppApp: App {
    
    @ObservedObject private var viewModel = WeatherAppViewModel()
    
    var body: some Scene {
        WindowGroup {
            TabView {
                MainScreenView()
                    .tabItem {
                        Text("Weather")
                        Image(systemName: "cloud.fill")
                    }
                FavoriteCitiesView(rootViewModel: viewModel)
                    .tabItem {
                        Text("My cities")
                        Image(systemName: "heart.fill")
                    }
            }
        }
    }
}
