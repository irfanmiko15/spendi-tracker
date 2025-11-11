//
//  extension.swift
//  SpendiTracker
//
//  Created by Irfan Dary Sujatmiko on 28/02/25.
//


import Foundation
import Combine
import SwiftUI

extension Set where Element: Cancellable {
    func cancel() {
        forEach { $0.cancel() }
    }
}

protocol ObjectSavable {
    func setObject<Object>(_ object: Object, forKey: String) throws where Object: Encodable
    func getObject<Object>(forKey: String, castTo type: Object.Type) throws -> Object where Object: Decodable
}

extension UserDefaults: ObjectSavable {
    func setObject<T:Encodable>(_ object: T, forKey: String) throws where T: Encodable {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)
            set(data, forKey: forKey)
        } catch {
            throw ObjectSavableErrorEnum.unableToEncode
        }
    }
    
    func getObject<T:Decodable>(forKey: String, castTo type: T.Type) throws -> T where T: Decodable {
        guard let data = data(forKey: forKey) else { throw ObjectSavableErrorEnum.noValue }
        let decoder = JSONDecoder()
        do {
            let object = try decoder.decode(type, from: data)
            
            return object
        } catch {
            throw ObjectSavableErrorEnum.unableToDecode
        }
    }
}

extension Data {
    init<T>(from value: T) {
        var value = value
        self.init(buffer: UnsafeBufferPointer(start: &value, count: 1))
    }
    func to<T>(type: T.Type) -> T {
        return self.withUnsafeBytes { $0.load(as: T.self) }
    }
}
