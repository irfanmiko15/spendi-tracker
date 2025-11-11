//
//  Env.swift
//  SpendiTracker
//
//  Created by Irfan Dary Sujatmiko on 28/02/25.
//

import Foundation
class Env{
    func getCurrentEnv(type: String) -> String {
        var dictionary: NSDictionary?
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist") {
            dictionary = NSDictionary(contentsOfFile: path)
        }
        return dictionary![type] as? String ?? "default"
    }
}
