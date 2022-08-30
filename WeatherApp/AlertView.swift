//
//  AlertView.swift
//  WeatherApp
//
//  Created by Егор Шилов on 24.08.2022.
//

import SwiftUI

struct AlertView: View {
    
    @Binding var isPresented: Bool
    var message: String
    
    var body: some View {
        VStack {
            
        }.alert("Error", isPresented: $isPresented, actions: {}) {
            Text(message)
        }

    }
}

struct AlertView_Previews: PreviewProvider {
    static var previews: some View {
        AlertView(isPresented: .constant(true), message: "eqw")
    }
}
