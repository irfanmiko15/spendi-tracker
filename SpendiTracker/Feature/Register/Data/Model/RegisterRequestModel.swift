//
//  RegisterRequestModel.swift
//  mushmate
//
//  Created by Irfan Dary Sujatmiko on 09/10/23.
//

import Foundation

struct RegisterRequestModel:Decodable,Encodable{
    
    let password: String
    let firstName: String
    let lastName: String
    let confirmPassword: String
    let email: String
    
    func toJSON() -> [String: Any] {
        return [
            "email": email as Any,
            "password": password as Any,
            "firstName": firstName as Any,
            "lastName": firstName as Any,
            "confirmPassword": confirmPassword as Any,
        ]
    }
}
