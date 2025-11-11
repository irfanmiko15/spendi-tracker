//
//  Router.swift
//  mushmate
//
//  Created by Irfan Dary Sujatmiko on 06/10/23.
//
import SwiftUI

@Observable
class Router {
    var paramString: String = ""
    var paramInt: Int?
    
    enum Destination: Codable, Hashable, Equatable {
        case login
        case loginWithEmail
        case forgotPassword
        case registration
    }
    
    var navPath = NavigationPath()
    
    func navigate(to destination: Destination) {
        navPath.append(destination)
    }
    
    func navigateBack() {
        navPath.removeLast()
    }
    
    func navigateToRoot() {
        navPath.removeLast(navPath.count)
    }
    func replace(with destination: Destination) {
            if !navPath.isEmpty {
                navPath.removeLast()
            }
            navPath.append(destination)
        }
}


