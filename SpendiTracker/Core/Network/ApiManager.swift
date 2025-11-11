//
//  api_manager.swift
//  mushlabs
//
//  Created by Irfan Dary Sujatmiko on 03/10/23.
//

import Foundation
import Alamofire
public class APIManager {
    public static let shared = APIManager()
    
    private let maxWaitTime = 15.0
    
    func callAPI<T: Decodable>(type:String?=nil, path: String, method: HTTPMethod = .get, parameters: Parameters? = nil) async throws -> T {
        let keychain = KeychainHelper.standard.read(service: Config().sharedKeychain ,account: "auth", type: LoginResponseModel.self)
        var header:HTTPHeaders? = nil
        
        if type == "auth" {
            if let x = keychain{
                header = [
                    "Authorization": "Bearer \(x.accessToken)",
                    "Accept": "application/json"
                ]
            }
            // Optional: Add an else block to handle if keychain is nil but type is "auth"
            // else { throw YourCustomError.sessionExpired }
        }
        else {
            header = [
                .accept("application/json")
            ]
        }
        
        print("\(BaseApi().baseUrl)\(path)")
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(
                URLComponents(string: "\(BaseApi().baseUrl)\(path)")!,
                method: method,
                parameters: parameters,
                headers: header,
                requestModifier: { $0.timeoutInterval = self.maxWaitTime }
            )
            .validate(statusCode: 200..<300)
            .responseDecodable(of: T.self, emptyResponseCodes: [201]) { response in
                
                switch(response.result) {
                case let .success(decodedObject):
                    continuation.resume(returning: decodedObject)
                    
                // Failure: Handle API errors or decoding errors
                case let .failure(error):
                    do {
                        // Try to parse our custom server error message
                        if let ress = response.data {
                            let result = try JSONDecoder().decode(ErrorResponse.self, from: ress)
                            continuation.resume(throwing: ErrorMessageEnum.errorMessage(message: result.reason))
                        } else {
                            // If no data, use the networking error
                            continuation.resume(throwing: self.handleError(error))
                        }
                    }
                    catch {
                        // If custom parsing fails, use the original networking error
                        continuation.resume(throwing: self.handleError(error))
                    }
                }
            }
        }
    }
    
    
    private func handleError(_ error: Error) -> Error {
        // If it's already an AFError, try to use its underlying error info
        if let afError = error as? AFError {
            if let underlyingError = afError.underlyingError {
                let nserror = underlyingError as NSError
                let code = nserror.code
                if code == NSURLErrorNotConnectedToInternet ||
                    code == NSURLErrorTimedOut ||
                    code == NSURLErrorInternationalRoamingOff ||
                    code == NSURLErrorDataNotAllowed ||
                    code == NSURLErrorCannotFindHost ||
                    code == NSURLErrorCannotConnectToHost ||
                    code == NSURLErrorNetworkConnectionLost {
                    var userInfo = nserror.userInfo
                    userInfo[NSLocalizedDescriptionKey] = "Unable to connect to the server"
                    let currentError = NSError(
                        domain: nserror.domain,
                        code: code,
                        userInfo: userInfo
                    )
                    return currentError
                }
            }
            return afError
        }

        // Not an AFError: fall back to inspecting the NSError directly
        let nserror = error as NSError
        let code = nserror.code
        if code == NSURLErrorNotConnectedToInternet ||
            code == NSURLErrorTimedOut ||
            code == NSURLErrorInternationalRoamingOff ||
            code == NSURLErrorDataNotAllowed ||
            code == NSURLErrorCannotFindHost ||
            code == NSURLErrorCannotConnectToHost ||
            code == NSURLErrorNetworkConnectionLost {
            var userInfo = nserror.userInfo
            userInfo[NSLocalizedDescriptionKey] = "Unable to connect to the server"
            let currentError = NSError(
                domain: nserror.domain,
                code: code,
                userInfo: userInfo
            )
            return currentError
        }

        return error
    }
}

// MARK: - APIManager Extension (Helper Methods)
extension APIManager {
    
    func postAuthApi<T: Decodable>(path: String, parameters: Parameters? = nil) async throws -> T {
        do {
            // No JSONDecoder needed. 'callAPI' returns the decoded object 'T'.
            let result: T = try await APIManager.shared.callAPI(type: "auth", path: path, method: .post, parameters: parameters)
            print("success :", result)
            return result
        } catch {
            print("error :", error)
            throw error
        }
    }
    
    func postNonAuthApi<T: Decodable>(path: String, parameters: Parameters? = nil) async throws -> T {
        do {
            let result: T = try await APIManager.shared.callAPI(path: path, method: .post, parameters: parameters)
            print("success :", result)
            return result
        } catch {
            print("error :", error)
            throw error
        }
    }
    
    func getAuthApi<T: Decodable>(path: String, parameters: Parameters? = nil) async throws -> T {
        do {
            let result: T = try await APIManager.shared.callAPI(type: "auth", path: path, method: .get, parameters: parameters)
            print("success :", result)
            return result
        } catch {
            print("error :", error)
            throw error
        }
    }
    
    
    func getNonAuthApi<T: Decodable>(path: String, parameters: Parameters? = nil) async throws -> T {
        do {
            let result: T = try await APIManager.shared.callAPI(path: path, method: .get, parameters: parameters)
            print("success :", result)
            return result
        } catch {
            print("error :", error)
            throw error
        }
    }
    
    func deleteAuthApi<T: Decodable>(path: String, parameters: Parameters? = nil) async throws -> T {
        do {
            let result: T = try await APIManager.shared.callAPI(type: "auth", path: path, method: .delete, parameters: parameters)
            print("success :", result)
            return result
        } catch {
            print("error :", error)
            throw error
        }
    }
    
    func deleteNonAuthApi<T: Decodable>(path: String, parameters: Parameters? = nil) async throws -> T {
        do {
            let result: T = try await APIManager.shared.callAPI(path: path, method: .delete, parameters: parameters)
            print("success :", result)
            return result
        } catch {
            print("error :", error)
            throw error
        }
    }
    
    func putAuthApi<T: Decodable>(path: String, parameters: Parameters? = nil) async throws -> T {
        do {
            let result: T = try await APIManager.shared.callAPI(type: "auth", path: path, method: .put, parameters: parameters)
            print("success :", result)
            return result
        } catch {
            print("error :", error)
            throw error
        }
    }
    
    func putNonAuthApi<T: Decodable>(path: String, parameters: Parameters? = nil) async throws -> T {
        do {
            let result: T = try await APIManager.shared.callAPI(path: path, method: .put, parameters: parameters)
            print("success :", result)
            return result
        } catch {
            print("error :", error)
            throw error
        }
    }
    
}
