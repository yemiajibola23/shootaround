//
//  ShootaroundApp.swift
//  Shootaround
//
//  Created by Yemi Ajibola on 10/5/26.
//

import SwiftUI
import SwiftData

@main
struct ShootaroundApp: App {
    let container: ModelContainer
    init() {
        container = try! makeContainer(storeURL: nil)
        
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(container)
    }
}
