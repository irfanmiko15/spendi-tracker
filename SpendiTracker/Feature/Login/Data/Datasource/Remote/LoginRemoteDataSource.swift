//
//  LoginDataSource.swift
//  SpendiTracker
//
//  Created by Irfan Dary Sujatmiko on 28/02/25.
//

import Foundation
import Alamofire

protocol LoginRemoteDatasource{
    func login(data:LoginRequestModel) async throws->LoginResponseModel?
}

struct LoginRemoteDatasourceImpl : LoginRemoteDatasource{
    func login(data:LoginRequestModel) async throws-> LoginResponseModel? {
        let path="/api/auth/login"
        let res : LoginResponseModel = try await APIManager.shared.request(.post, path: path,parameters: data.toJSON())
        return res
    }
}



