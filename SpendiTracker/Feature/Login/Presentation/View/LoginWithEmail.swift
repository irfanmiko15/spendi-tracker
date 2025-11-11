//
//  LoginWithEmail.swift
//  SpendiTracker
//
//  Created by Irfan Dary Sujatmiko on 11/11/25.
//


import SwiftUI

struct LoginWithEmail: View {
    
    @State var loginViewModel:LoginViewModel = LoginViewModel()
    @State var showPassword = false
    @State var firstLabel = "Email"
    @State var firstHint = "Input your email"
    @State var secondLabel = "Password"
    @State var secondHint = "Input your password"
    var body: some View {
        ScrollView{
            VStack(alignment: .center) {
                
                VStack(alignment: .leading) {
                    Spacer()
                        .frame(height: 40)
                    Text("Sign in to your account").font(.title2).fontWeight(.bold)
                    Spacer()
                        .frame(height: 10)
                    HStack{
                        Text("You need sign in to start track your money") .font(.system(.subheadline)).foregroundColor(.gray)
                        Spacer()
                    }
                }.padding(.horizontal)
                Spacer().frame(height: 30)
                VStack(alignment: .leading) {
                    DefaultTextField(value: $loginViewModel.email, label: $firstLabel, hint: $firstHint).padding(.horizontal)
                    Text(loginViewModel.emailPrompt)
                        .fixedSize(horizontal: false, vertical: true)
                        .font(.caption).foregroundColor(Color.red).padding(.horizontal)
                    Spacer()
                        .frame(height: 20)
                    PasswordTextField(value: $loginViewModel.password, label: $secondLabel, hint: $secondHint,showPassword: $showPassword).padding(.horizontal)
                    Text(loginViewModel.passwordPrompt)
                        .fixedSize(horizontal: false, vertical: true)
                        .font(.caption).foregroundColor(Color.red).padding(.horizontal)
                    HStack() {
                        Spacer()
                        Text("Forgot Password ?").font(.footnote).fontWeight(.semibold).foregroundStyle(Color.secondaryColor).onTapGesture {
                        }
                    }.padding(.horizontal)
                }
                
                Spacer()
                    .frame(height: 32)
                if(loginViewModel.email != "" && loginViewModel.password != ""){
                    
                    if(loginViewModel.states == .loading){
                        ProgressView().progressViewStyle(.circular)
                        
                    }
                    else{
                        Button("Sign In"){
                            var request = LoginRequestModel(email: loginViewModel.email, password: loginViewModel.password);
                            Task{
                               await loginViewModel.login(data: request)
                            }
                        }.buttonStyle(PrimaryButton()).padding(.horizontal)
                        
                    }
                }
                else{
                    Button("Sign In"){
                    }.buttonStyle(DisabledButton()).padding(.horizontal)
                }
                Spacer()
            }
        }.background(Color.backgroundColor)
    }
}

#Preview {
    LoginWithEmail(loginViewModel: LoginViewModel())
}
