//
//  WeatherAppApp.swift
//  WeatherApp
//
//  Created by Егор Шилов on 19.08.2022.
//

import SwiftUI

@main
struct WeatherAppApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                MainScreenView()
                    .tabItem {
                        Text("Weather")
                        Image(systemName: "cloud.fill")
                    }
                Text("Hello World")
                    .tabItem {
                        Text("My cities")
                        Image(systemName: "heart.fill")
                    }
            }
        }
    }
}
