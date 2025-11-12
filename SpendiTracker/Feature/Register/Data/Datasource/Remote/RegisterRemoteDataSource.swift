//
//  RegisterRemoteDataSource.swift
//  mushmate
//
//  Created by Irfan Dary Sujatmiko on 09/10/23.
//

import Foundation
import Alamofire

protocol RegisterRemoteDatasource{
    func register(data:RegisterRequestModel)async throws -> Empty
}

struct RegisterRemoteDatasourceImpl:RegisterRemoteDatasource{
    func register(data: RegisterRequestModel) async throws -> Empty{
        let path = "/api/auth/register"
        let res:Empty = try await APIManager.shared.request(.post, path: path, parameters: data.toJSON())
        return res
    }
}
