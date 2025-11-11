//
//  LoginView.swift
//  SpendiTracker
//
//  Created by Irfan Dary Sujatmiko on 28/02/25.
//
import SwiftUI

struct LoginView: View {
    @Bindable var router: Router
    var body: some View {
        ZStack{
            VStack{
                
            }.frame(maxWidth: .infinity).frame(maxHeight: .infinity).background(Color.primaryGreenColor).opacity(0.9)
            Circle().fill(
                Color(.white)
            ).offset(x:100).offset(y:-300).opacity(0.2).frame(height:200)
            Circle().fill(
                Color(.white)
            ).offset(x:100).offset(y:-300).opacity(0.19).frame(height:300)
            
            Circle().fill(
                Color(.white)
            ).offset(x:100).offset(y:-300).opacity(0.18).frame(height:500)
            VStack(alignment: .leading){
                Spacer()
                HStack{
                    Spacer()
                    LottieView(isPlay: false, frame: 4, animation: "money_wallet" ).frame(width: 300, height: 300)
                    Spacer()
                }
                Text("Manage Your Monthly Income Wisely").font(.system(size: 35).bold()).padding(.leading).foregroundColor(.white)
                Text("A new way that makes it easier for you to allocate monthly income").foregroundColor(.white).font(.system(size:20)).padding(.horizontal).padding(.top)
                Spacer().frame(height: 40)
                Button("Sign In"){
                    router.navigate(to: .loginWithEmail)
                }.buttonStyle(SecondaryButton()).padding(.horizontal)
                HStack{
                    Spacer()
                    Text("Dont have account?").font(.system(.subheadline)).foregroundStyle(Color.white)
                    Text("Sign up now").font(.system(.subheadline).bold()).foregroundStyle(Color.yellow).onTapGesture {
                        router.navigate(to: .registration)
                    }
                    Spacer()
                }.padding(.vertical,10)
            }.frame(maxHeight: .infinity).padding()
        }.frame(maxWidth: .infinity).frame(maxHeight: .infinity).navigationBarBackButtonHidden(true)
    }
    
}
#Preview {
    LoginView(router: Router())
}
