//
//  RegisterRepository.swift
//  mushmate
//
//  Created by Irfan Dary Sujatmiko on 09/10/23.
//

import Foundation
import Alamofire

protocol RegisterRepository{
    func doRegister(data:RegisterRequestModel)async throws -> Empty
}
