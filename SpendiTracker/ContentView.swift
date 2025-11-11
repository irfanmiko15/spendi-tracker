//
//  ContentView.swift
//  SpendiTracker
//
//  Created by Irfan Dary Sujatmiko on 28/02/25.
//

import SwiftUI
import LeapChucker
struct ContentView: View {
    @State private var showLogger = false
    @Bindable var router: Router
    @State var loginViewModel: LoginViewModel = LoginViewModel()
    @State private var dragAmount: CGPoint?
    var body: some View {
        ZStack{
            NavigationStack(path: $router.navPath) {
                SplashView(router: router)
                    .navigationDestination(for: Router.Destination.self) { destination in
                        switch destination {
                        case .login:
                            LoginView(router: router)
                        case .loginWithEmail:
                            LoginWithEmail()
                        case .registration:
                            RegisterView(router: router)
                        case .forgotPassword:
                            LoginView(router: router)
                        }
                    }
            }
            
            GeometryReader { gp in
                ZStack {
                    Button(action: self.performAction) {
                        Image(systemName: "network")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 65, height: 65)
                            .background(Color.blue)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }
                    .animation(.default, value: dragAmount)
                    .position(self.dragAmount ?? CGPoint(
                        x: gp.size.width - 65 / 2 - 16,
                        y: gp.size.height - 65 / 2 - 16
                    ))
                    .highPriorityGesture(
                        DragGesture()
                            .onChanged { self.dragAmount = $0.location})
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity) 
            }
            
            
        }.leapChuckerLogger(isPresented: $showLogger)
        
        
    }
    func performAction() {
        showLogger = !showLogger
    }
}

