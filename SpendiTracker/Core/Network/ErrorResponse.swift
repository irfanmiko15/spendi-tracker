//
//  ErrorResponse.swift
//  SpendiTracker
//
//  Created by Irfan Dary Sujatmiko on 28/02/25.
//

import Foundation
struct ErrorResponse: Codable,Error {
    let error: Bool?
    let reason: String?
    let errorCode: String?
}
