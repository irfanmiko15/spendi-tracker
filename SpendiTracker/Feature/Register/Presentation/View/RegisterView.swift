//
//  RegisterView.swift
//  mushmate
//
//  Created by Irfan Dary Sujatmiko on 09/10/23.
//

import SwiftUI
struct RegisterView: View {
    @Bindable var router: Router
    @State var firstNameLabel = "First Name"
    @State var firstNameHint = "Input your first namea"
    @State var lastNameLabel = "Last Name"
    @State var lastNameHint = "Input your last name"
    @State var emailLabel = "Email"
    @State var emailHint = "Input your email"
    @State var passwordLabel = "Password"
    @State var passwordHint = "Input your password"
    @State var confirmationPasswordLabel = "Confirmation Password"
    @State var confirmationPasswordHint = "Retype your password"
    @State var showPassword = false
    @State var showConfirmationPassword = false
    @State var registerViewModel:RegisterViewModel = RegisterViewModel()
    @Bindable var toastManager: ToastManager
    var body: some View {
        ScrollView {
            VStack(alignment: .center) {
                VStack(alignment: .leading) {
                    
                    Text("Sign up").font(.title2).fontWeight(.bold)
                    Spacer()
                        .frame(height: 10)
                    
                    HStack{
                        Text("Creaate your account to start your journey").font(.system(.subheadline)).foregroundColor(.gray)
                        Spacer()
                    }
                }.padding(.horizontal)
                
                
                Spacer()
                    .frame(height: 30)
                VStack{
                    
                    VStack(alignment:.leading){
                        DefaultTextField(value: $registerViewModel.firstName, label: $firstNameLabel, hint: $lastNameHint).padding(.horizontal)
                        Text(registerViewModel.firstNamePrompt)
                            .fixedSize(horizontal: false, vertical: true)
                            .font(.caption).foregroundColor(Color.red).padding(.horizontal)
                    }
                    
                    
                    VStack(alignment:.leading){
                        DefaultTextField(value: $registerViewModel.lastName, label: $lastNameLabel, hint: $firstNameHint).padding(.horizontal)
                        Text(registerViewModel.lastNamePrompt)
                            .fixedSize(horizontal: false, vertical: true)
                            .font(.caption).foregroundColor(Color.red).padding(.horizontal)
                    }
                    
                    VStack(alignment:.leading) {
                        DefaultTextField(value: $registerViewModel.email, label: $emailLabel, hint: $emailHint).padding(.horizontal)
                        Text(registerViewModel.emailPrompt)
                            .fixedSize(horizontal: false, vertical: true)
                            .font(.caption).foregroundColor(Color.red).padding(.horizontal)
                    }
                    VStack(alignment:.leading) {
                        PasswordTextField(value: $registerViewModel.password, label: $passwordLabel, hint: $passwordHint,showPassword: $showPassword).padding(.horizontal)
                        Text(registerViewModel.passwordPrompt)
                            .fixedSize(horizontal: false, vertical: true)
                            .font(.caption).foregroundColor(Color.red).padding(.horizontal)
                    }
                    
                    VStack(alignment:.leading) {
                        PasswordTextField(value: $registerViewModel.confirmPw, label: $confirmationPasswordLabel, hint: $confirmationPasswordHint,showPassword: $showConfirmationPassword).padding(.horizontal)
                        Text(registerViewModel.confirmPwPrompt)
                            .fixedSize(horizontal: false, vertical: true)
                            .font(.caption).foregroundColor(Color.red).padding(.horizontal)
                    }
                    
                }
                
                Spacer()
                    .frame(height: 20)
                if(registerViewModel.email != "" && registerViewModel.password != "" && registerViewModel.firstName != "" && registerViewModel.lastName != "" && registerViewModel.confirmPw != ""){
                    switch(registerViewModel.loadingState){
                    case .loading :
                        ProgressView().progressViewStyle(.circular)
                    default :
                        Button("Register"){
                            Task{
                                await registerViewModel.register()
                                getRegistrationResult()
                            }
                        }.buttonStyle(PrimaryButton()).padding(.horizontal)
                    }
                }
                else{
                    Button("Sign Up"){
                        
                    }.buttonStyle(DisabledButton()).padding(.horizontal)
                }
                Spacer()
            }
        }.background(Color.backgroundColor).toast(toastView: Toast(message: toastManager.toast.message, show: $toastManager.toast.isShow), show: $toastManager.toast.isShow)
        
    }
    
    func getRegistrationResult (){
        switch(registerViewModel.loadingState){
        case .failed(let error) :
            toastManager.toast.isShow = true
            toastManager.toast.message = error
        case .loaded(let _) :
            toastManager.toast.isShow = true
            toastManager.toast.message = "Registration success, please check your email and verify before login"
            router.replace(with: .loginWithEmail)
        
        default :
            print("registration result not failed or success")
        }
    }
    
}


struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView(router: Router(), registerViewModel: RegisterViewModel(),toastManager: ToastManager())
    }
}

