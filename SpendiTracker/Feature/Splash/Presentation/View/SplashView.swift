//
//  SplashView.swift
//  SpendiTracker
//
//  Created by Irfan Dary Sujatmiko on 11/11/25.
//

import SwiftUI

struct SplashView : View{
    @Bindable var router:Router
    var body: some View {
        VStack{
            LottieView(animation: "money_wallet").frame(width: 250, height: 250)
        }.task{
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation {
                    router.replace(with: .login)
                }
        }
    }
    }
}

#Preview {
    SplashView(router: Router())
}

