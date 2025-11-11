//
//  login_usecas.swift
//  SpendiTracker
//
//  Created by Irfan Dary Sujatmiko on 28/02/25.
//

import Foundation

struct LoginUseCase {
    var repository: LoginRepository
    init(repository: LoginRepository) {
        self.repository = repository
    }
    func execute(data: LoginRequestModel) async throws -> LoginResponseModel? {
        try await repository.doLogin(data:data)
        
    }
    
}

