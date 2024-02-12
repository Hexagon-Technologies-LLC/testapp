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
    func credentialToken(code: String) async throws -> TokenInfo
    func signIn(username: String, password: String) async throws -> Bool
    func getProfile(id: String) async throws -> UserInfo
    func getProfile(email: String) async throws -> UserInfo
    func createProfile(params: [String: Any]) async throws -> String
    func updateProfile(id: String, params: [String: Any]) async throws -> String
    func deleteProfile(id: String) async throws -> String
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
extension AuthRepositoryImpl: AuthRepository {
    func signIn(username: String, password: String) async throws -> Bool {
        
        let param: Parameters = ["username": username, "password": password]
        
        let result: Bool = try await execute(endpoint: API.signIn(param: param), isFullPath: false, logLevel: .debug)
        return result
    }
    
    func credentialToken(code: String) async throws -> TokenInfo {
        let param: Parameters = ["grant_type": "authorization_code",
                                 "client_id": "45vr75joq0hgjv6k8ath6ifimm",
                                 "redirect_uri": "https%3A%2F%2Fkmeapp.app",
                                 "code": code]
        
        let tokenInfo:TokenInfo = try await execute(endpoint: API.credentialToken(param: param), isFullPath: true, logLevel: .debug)
        return tokenInfo
    }
   
    func getProfile(id: String) async throws -> UserInfo {
        let userInfo: UserInfo = try await execute(endpoint: API.getProfileByID(id), isFullPath: false, logLevel: .debug)
        UserDefaultHandler.userInfo = userInfo
        return userInfo
    }
    
    func getProfile(email: String) async throws -> UserInfo {
        let userInfo: UserInfo = try await execute(endpoint: API.getProfileByEmail(email), isFullPath: false, logLevel: .debug)
        UserDefaultHandler.userInfo = userInfo
        return userInfo
    }
    
    func createProfile(params: [String : Any]) async throws -> String {
        let userInfo: [String: String] = try await execute(endpoint: API.createProfile(param: params), isFullPath: false, logLevel: .debug)
        return userInfo["user_id"] ?? ""
    }
    
    func updateProfile(id: String, params: [String: Any]) async throws -> String {
        let result: [String: String] = try await execute(endpoint: API.updateProfile(id: id, params: params), isFullPath: false, logLevel: .debug)
        return result["user_id"] ?? ""
    }
    
    func deleteProfile(id: String) async throws -> String {
        let result: [String: String] = try await execute(endpoint: API.deleteProfile(id: id), isFullPath: false, logLevel: .debug)
        return result["user_id"] ?? ""
    }
}

// MARK: - Configuration
extension AuthRepositoryImpl {
    enum API: ResourceType {
        case signIn(param: Parameters)
        case credentialToken(param: Parameters)
        case getProfileByID(_ id: String)
        case getProfileByEmail(_ email: String)
        case createProfile(param: Parameters)
        case updateProfile(id: String, params: Parameters)
        case deleteProfile(id: String)
        
        var endPoint: Endpoint {
            switch self {
            case .credentialToken:
                return .post(path: "https://kme.auth.us-east-1.amazoncognito.com/oauth2/token")
            case .signIn:
                return .post(path: "login")
            case .getProfileByID(let id):
                return .get(path: "profile/\(id)")
            case .getProfileByEmail(let email):
                return .get(path: "profile/email/\(email)")
            case .createProfile:
                return .post(path: "profile")
            case .updateProfile(let id, _):
                return .put(path: "profile/\(id)")
            case .deleteProfile(let id):
                return .delete(path: "profile/\(id)")
            }
        }
        
        var task: HTTPTask {
            switch self {
            case .credentialToken(let param):
                return .requestParameters(encoding: .urlEncodingPOST, urlParameters: param)
            case .getProfileByID, .getProfileByEmail, .deleteProfile:
                return .requestParameters(encoding: .jsonEncoding)
            case .signIn(let param), .createProfile(let param), .updateProfile(_, let param):
                return .requestParameters(bodyParameters: param, encoding: .jsonEncoding)
            }
        }
        
        var headers: HTTPHeaders? {
            authHeader
        }
    }
}

#endif
