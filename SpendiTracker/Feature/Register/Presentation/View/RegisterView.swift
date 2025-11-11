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
                    
                    if(registerViewModel.states == .loading){
                        ProgressView().progressViewStyle(.circular)
                        
                    }
                    else{
                        Button("Sign Up"){
                            Task{
                                
                                await registerViewModel.register()
                                if registerViewModel.states == .error{
                                    registerViewModel.showAlert = true
                                }
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
        }.alert("Error", isPresented: $registerViewModel.showAlert) {
            Button("Close",role: .cancel, action: {registerViewModel.showAlert = false})
        } message: {
            Text(registerViewModel.errorMessage ?? "")
        }.background(Color.backgroundColor)
           
    }
    
}


struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView(router: Router(), registerViewModel: RegisterViewModel())
    }
}

