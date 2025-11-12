//
//  RegisterViewModel.swift
//  mushmate
//
//  Created by Irfan Dary Sujatmiko on 09/10/23.
//

import Foundation
import Alamofire
@Observable
class RegisterViewModel{
    var email = ""
    var password = ""
    var confirmPw = ""
    var firstName = ""
    var lastName = ""
    var showPromp:Bool=false
    var showAlert = false
    var errorMessage: String?
    var loadingState: LoadingState<Void> = .idle
    
    @MainActor
    func register()async {
        showPromp=true
        if isSignUpComplete{
            do {
                loadingState = .loading
                let registerUseCase: Empty = try await RegisterUseCase(repository: RegisterRepositoryImpl(remoteDataSource:RegisterRemoteDatasourceImpl())).execute(data: RegisterRequestModel( password: password, firstName:firstName, lastName: lastName, confirmPassword: confirmPw, email: email))
                loadingState = .loaded(())
            } catch let error as ErrorResponse{
                loadingState = .failed(error.reason ?? "Registration failed")
            }
            catch let error {
                loadingState = .failed(error.localizedDescription)
            }
        }
        
    }
    
    func passwordsMatch() -> Bool {
        password == confirmPw
    }
    
    func isPasswordValid() -> Bool {
        // criteria in regex.  See http://regexlib.com
        let passwordTest = NSPredicate(format: "SELF MATCHES %@",
                                       "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z]).{8,15}$")
        return passwordTest.evaluate(with: password)
    }
    
    func isEmailValid() -> Bool {
        // criteria in regex.  See http://regexlib.com
        let emailTest = NSPredicate(format: "SELF MATCHES %@",
                                    "^([a-zA-Z0-9_\\-\\.]+)@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\\]?)$")
        return emailTest.evaluate(with: email)
    }
    
    func isFirstNameValid()->Bool{
        if firstName.isEmpty{
            return false
        }
        else{
            return true
        }
    }
    
    func isLastNameValid()->Bool{
        if lastName.isEmpty{
            return false
        }
        else{
            return true
        }
    }
    
    
    var isSignUpComplete: Bool {
        if !passwordsMatch() ||
            !isPasswordValid() ||
            !isEmailValid() ||
            !isFirstNameValid() || !isLastNameValid() {
            return false
        }
        return true
    }
    
    // MARK: - Validation Prompt Strings
    
    var confirmPwPrompt: String {
        if passwordsMatch()||showPromp==false {
            return ""
        } else {
            
            return "Password doesnt match"
        }
    }
    
    var emailPrompt: String {
        if isEmailValid()||showPromp==false {
            return ""
        } else {
            return "Please input a valid email"
        }
    }
    
    var passwordPrompt: String {
        if isPasswordValid()||showPromp==false {
            return ""
        } else {
            return "Password must be 5-15 character and include 1 number and 1 capitalize"
        }
    }
    var firstNamePrompt: String {
        if isFirstNameValid() || showPromp==false {
            return ""
        } else {
            return "First name is required"
        }
    }
    
    var lastNamePrompt: String {
        if isLastNameValid() || showPromp==false {
            return ""
        } else {
            return "Last Nama is required"
        }
    }
    
}

