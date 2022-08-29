//
//  SearchbarView.swift
//  WeatherApp
//
//  Created by Егор Шилов on 19.08.2022.
//

import SwiftUI

struct Searchbar: View {
    
    @Binding var cityNameForRequest: String
    
    var body: some View {
        HStack {
            TextField("Search", text: $cityNameForRequest)
                .padding(7)
                .padding(.horizontal, 26)
                .background(.quaternary)
                .cornerRadius(8)
                .overlay(
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 8)
                )
        }
        .padding(.horizontal, 10)
    }
}

struct SearchbarView_Previews: PreviewProvider {
    static var previews: some View {
        Searchbar(cityNameForRequest: .constant("312"))
    }
}
