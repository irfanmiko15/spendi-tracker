//
//  login_repository_impl.swift
//  SpendiTracker
//
//  Created by Irfan Dary Sujatmiko on 28/02/25.
//

import Foundation

struct LoginRepositoryImpl : LoginRepository {
    var remoteDataSource:LoginRemoteDatasource
    
    init(remoteDataSource: LoginRemoteDatasource) {
        self.remoteDataSource = remoteDataSource
    }
    func doLogin(data: LoginRequestModel) async throws -> LoginResponseModel? {
       
      try await remoteDataSource.login(data:data)

    }
}
