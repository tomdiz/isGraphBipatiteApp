//
//  isGraphBipatiteApp.swift
//  isGraphBipatite
//
//  Created by Thomas DiZoglio on 12/27/22.
//

import SwiftUI

@main
struct isGraphBipatiteApp: App {

    @StateObject private var modelData = ModelData()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(ModelData())
        }
    }
}
