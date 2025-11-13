//
//  LoginWithEmail.swift
//  SpendiTracker
//
//  Created by Irfan Dary Sujatmiko on 11/11/25.
//


import SwiftUI

struct LoginWithEmail: View {
    
    @State var loginViewModel:LoginViewModel = LoginViewModel()
    @Bindable var router: Router
    @Bindable var toastManager: ToastManager
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
                    DefaultTextField(value: $loginViewModel.email, label: $firstLabel, hint: $firstHint,accessibilityId: "login_email_field")
                        
                        .padding(.horizontal)
                    Text(loginViewModel.emailPrompt)
                        .accessibilityIdentifier("login_email_prompt")
                        .fixedSize(horizontal: false, vertical: true)
                        .font(.caption).foregroundColor(Color.red).padding(.horizontal)
                    Spacer()
                        .frame(height: 20)
                    PasswordTextField(value: $loginViewModel.password, label: $secondLabel, hint: $secondHint,showPassword: $showPassword, accessibilityId: "login_password_field")
                        .padding(.horizontal)
                    Text(loginViewModel.passwordPrompt)
                        .accessibilityIdentifier("login_password_prompt")
                        .fixedSize(horizontal: false, vertical: true)
                        .font(.caption).foregroundColor(Color.red).padding(.horizontal)
                    HStack() {
                        Spacer()
                        Text("Forgot Password ?")
                            .accessibilityIdentifier("login_forgot_password")
                            .font(.footnote)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.secondaryColor)
                            .onTapGesture {
                            }
                    }.padding(.horizontal)
                }
                
                Spacer()
                    .frame(height: 32)
                if (loginViewModel.email != "" && loginViewModel.password != "") {
                    switch(loginViewModel.loadingState){
                    case .loading :
                        ProgressView().progressViewStyle(.circular)
                    default :
                        Button("Sign In"){
                            var request = LoginRequestModel(email: loginViewModel.email, password: loginViewModel.password);
                            Task{
                               await loginViewModel.login(data: request)
                                getLoginResult();
                            }
                        }
                        .accessibilityIdentifier("login_signin_button")
                        .buttonStyle(PrimaryButton())
                        .padding(.horizontal)
                    }
                }
                else{
                    Button("Sign In"){
                    }
                    .accessibilityIdentifier("login_signin_button")
                    .buttonStyle(DisabledButton())
                    .padding(.horizontal)
                }
                Spacer()
            }
        }.background(Color.backgroundColor).toast(toastView: Toast(message: toastManager.toast.message, show: $toastManager.toast.isShow), show: $toastManager.toast.isShow)
    }
    
    func getLoginResult () {
        switch(loginViewModel.loadingState){
        case .failed(let error) :
            toastManager.toast.isShow = true
            toastManager.toast.message = error
        case .loaded(let data) :
            toastManager.toast.isShow = true
            toastManager.toast.message = "Login success"
        
        default :
            print("login result not failed or success")
        }
    }
}

#Preview {
    LoginWithEmail(loginViewModel: LoginViewModel(),router: Router(), toastManager: ToastManager())
}
