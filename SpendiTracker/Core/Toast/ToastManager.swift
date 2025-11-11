//
//  Toast.swift
//  SpendiTracker
//
//  Created by Irfan Dary Sujatmiko on 28/02/25.
//
import SwiftUI
import Foundation
struct ToastModel{
    var isShow:Bool
    var message:String
}

@Observable
class ToastManager{
    var toast:ToastModel=ToastModel(isShow: false, message: "")
}
