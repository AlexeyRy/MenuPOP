//
//  LLRDandDAppApp.swift
//  LLRDandDApp
//
//  Created by Alexey Chermnykh on 7.12.2024.
//

import SwiftUI

@main
struct LLRDandDAppApp: App {
    @StateObject private var router = Router()
    @StateObject private var themeManger = ThemeManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(router)
                .environmentObject(themeManger)
            
        }
    }
}
