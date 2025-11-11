//
//  LoginResponseModel.swift
//  SpendiTracker
//
//  Created by Irfan Dary Sujatmiko on 28/02/25.
//

import Foundation

// MARK: - LoginResponseModel
struct LoginResponseModel: Codable {
    let user: User
    let accessToken, refreshToken: String
}

// MARK: - User
struct User: Codable {
    let email, id, lastName, firstName: String
}
