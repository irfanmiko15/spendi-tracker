//
//  login_request_model.swift
//  SpendiTracker
//
//  Created by Irfan Dary Sujatmiko on 28/02/25.
//

import Foundation

struct LoginRequestModel: Decodable, Hashable {
    var email: String
    var password: String
    func toJSON() -> [String: Any] {
        return [
            "email": email as Any,
            "password": password as Any,
        ]
    }
}

