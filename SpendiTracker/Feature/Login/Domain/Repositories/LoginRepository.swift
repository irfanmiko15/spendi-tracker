//
//  login_repository.swift
//  SpendiTracker
//
//  Created by Irfan Dary Sujatmiko on 28/02/25.
//

import Foundation

protocol LoginRepository {
    func doLogin(data: LoginRequestModel) async throws ->LoginResponseModel?
}
