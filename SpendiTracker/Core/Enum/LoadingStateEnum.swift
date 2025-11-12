//
//  LoadingStateEnum.swift
//  SpendiTracker
//
//  Created by Irfan Dary Sujatmiko on 12/11/25.
//
import Foundation
enum LoadingState<Value> {
    case idle
    case loading
    case loaded(Value)
    case failed(String)
}
