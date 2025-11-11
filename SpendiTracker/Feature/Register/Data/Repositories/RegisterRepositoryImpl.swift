//
//  LogoutRepositoryImpl.swift
//  mushmate
//
//  Created by Irfan Dary Sujatmiko on 09/10/23.
//

import Foundation
import Alamofire

struct RegisterRepositoryImpl : RegisterRepository {
    
    var remoteDataSource:RegisterRemoteDatasource
    
    init(remoteDataSource: RegisterRemoteDatasource) {
        self.remoteDataSource = remoteDataSource
    }
    func doRegister(data: RegisterRequestModel) async throws -> Empty{
       try await remoteDataSource.register(data:data)
    }

}
