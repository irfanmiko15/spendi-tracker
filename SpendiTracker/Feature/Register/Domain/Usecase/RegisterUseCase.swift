//
//  RegisterUseCase.swift
//  mushmate
//
//  Created by Irfan Dary Sujatmiko on 09/10/23.
//

import Foundation
import Alamofire

struct RegisterUseCase{
    var repository: RegisterRepository
    init(repository: RegisterRepository) {
        self.repository = repository
    }
    func execute(data: RegisterRequestModel) async throws -> Empty{
       try await repository.doRegister(data:data)
    }
    
}
