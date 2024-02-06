//
//  AuthWebRepository.swift
//  iOSRepositories
//
//  Created by Cuong Le on 06/02/24.
//  Copyright © All rights reserved.
//
// swiftlint:disable line_length
#if canImport(Combine) && os(iOS)
import Combine
import Foundation

public protocol AuthRepository: WebRepository {
    func signIn(email: String, password: String) async throws -> TokenInfo
}

struct AuthRepositoryImpl {
    let session: URLSession
    let baseURL: String
    let bgQueue = DispatchQueue(label: "bg_auth_queue") // , attributes: .concurrent
    var interceptor: RequestInterceptor?
    
    @Injected var appState: AppStore<AppState>
    
    init(configuration: ServiceConfiguration) {
        self.session = configuration.urlSession
        self.baseURL = configuration.environment.url
    }
}

public enum AuthError: Error, LocalizedError {
    case tokenFindError
    case authNeeded
    public var errorDescription: String? {
        "Unable to find the token, please check the request header."
    }
}

// MARK: - Async impl
extension AuthRepositoryImpl {
    func signIn(email: String, password: String) async throws -> TokenInfo {
        
        let param: Parameters = ["username": email, "password": password]
        
        let tokenInfo:TokenInfo = try await execute(endpoint: API.signIn(param: param), isFullPath: true, logLevel: .debug)
        return tokenInfo
    }
}

// MARK: - Protocol impl
extension AuthRepositoryImpl: AuthRepository {

}
// MARK: - Configuration
extension AuthRepositoryImpl {
    enum API: ResourceType {
        case signIn(param: Parameters)
        
        var endPoint: Endpoint {
            switch self {
            case .signIn:
                return .post(path: "login")
            }
        }
        
        var task: HTTPTask {
            switch self {
            case .signIn(let param):
                return .requestParameters(encoding: .urlEncoding, urlParameters: param)
            }
        }
        
        var headers: HTTPHeaders? {
            authHeader
        }
    }
}

#endif
