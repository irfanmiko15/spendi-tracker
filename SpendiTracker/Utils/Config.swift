//
//  Config.swift
//  mushmate
//
//  Created by Irfan Dary Sujatmiko on 06/10/23.
//

import Foundation
public class Config{
    var appName: String = "Spendi Tracker"
    var sharedContainer =  Env().getCurrentEnv(type: "APP_CONTAINER")
    var sharedKeychain = Env().getCurrentEnv(type: "APP_KEYCHAIN")
}
