//
//  SpendiTrackerApp.swift
//  SpendiTracker
//
//  Created by Irfan Dary Sujatmiko on 28/02/25.
//

import SwiftUI
import Combine
import LeapChucker
@main
struct SpendiTrackerApp: App {
    init() {
            // Enable LeapChucker logging
            LeapChuckerApp.setup()
    }
    @State var router = Router()
    @State var toastManager = ToastManager()
    var body: some Scene {
        WindowGroup {
            ContentView(router: router,toastManager: toastManager)
                            
        }
    }
}
