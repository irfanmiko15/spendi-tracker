//
//  LoginViewModel.swift
//  SpendiTracker
//
//  Created by Irfan Dary Sujatmiko on 28/02/25.
//


import Foundation
import SwiftUI

@Observable
class LoginViewModel {
     var token: String?
     var loginResponse: LoginResponseModel?
     var message: String = ""
    var email: String = ""
     var password: String = ""
     var firstName: String = ""
     var lastName: String = ""
     var secret: String = ""
    var showPromp: Bool=false
    var loadingState: LoadingState<LoginResponseModel> = .idle
    @MainActor
    func login(data: LoginRequestModel) async {
            showPromp = false
            do {
                resetValue()
                loadingState = .loading
                let loginUseCase = try await LoginUseCase(repository: LoginRepositoryImpl(remoteDataSource:LoginRemoteDatasourceImpl())).execute(data: LoginRequestModel(email: data.email, password: data.password))
                if let res = loginUseCase{
                    token = res.accessToken
                    message = "Berhasil Login"
                    KeychainHelper.standard.save(res, service: Config().sharedKeychain, account: "auth")
                    loadingState = .loaded(res)
                }
            } catch let error as ErrorResponse{
                loadingState = .failed(error.reason ?? "Failed to login")
            }
            catch let error {
                loadingState = .failed(error.localizedDescription)
            }
        }
    
    
    
    func resetValue() {
        token = nil
        
        message = ""
    }
    
    func clearField() {
        email = ""
        password = ""
    }
    
    func isPasswordValid() -> Bool {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@",
                                       "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z]).{8,15}$")
        return passwordTest.evaluate(with: password)
    }
    
    func isEmailValid() -> Bool {
        let emailTest = NSPredicate(format: "SELF MATCHES %@",
                                    "^([a-zA-Z0-9_\\-\\.]+)@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\\]?)$")
        return emailTest.evaluate(with: email)
    }
    
    var emailPrompt: String {
        if isEmailValid()||showPromp==false {
            return ""
        } else {
            return "Masukkan alamat email yang valid"
        }
    }
    
    var passwordPrompt: String {
        if isPasswordValid()||showPromp==false {
            return ""
        } else {
            return "Password harus terdiri dari 8 - 15 karakter dan terdapat minimal 1 angka dan 1 huruf kapital"
        }
    }
    
    var isSignUpComplete: Bool {
        if
            !isPasswordValid() ||
            !isEmailValid()  {
            showPromp = true
            return false
        }
        return true
    }
}
