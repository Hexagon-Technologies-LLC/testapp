//
//  DocumentRepository.swift
//  KMe
//
//  Created by Le Quang Tuan Cuong(CuongLQT) on 14/02/2024.
//

import Foundation
import Combine
import Foundation

public protocol DocumentRepository: WebRepository {
    func processingSubmit(params: [String: Any]) async throws -> String
    func processingCheck(id: String) async throws -> Bool
    func processingReceive(id: String) async throws -> DocumentJob
}

struct DocumentRepositoryImpl {
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


// MARK: - Async impl
extension DocumentRepositoryImpl: DocumentRepository {
    func processingSubmit(params: [String : Any]) async throws -> String {
        let userInfo: [String: String] = try await execute(endpoint: API.processingSubmit(param: params), isFullPath: false, logLevel: .debug)
        return userInfo["job_id"] ?? ""
    }
    
    func processingCheck(id: String) async throws -> Bool {
        let userInfo: [String: Bool] = try await execute(endpoint: API.processingCheck(id), isFullPath: false, logLevel: .debug)
        return userInfo["completion_status"] ?? false
    }
    
    func processingReceive(id: String) async throws -> DocumentJob {
        let documentJob: DocumentJob = try await execute(endpoint: API.processingReceive(id), isFullPath: false, logLevel: .debug)
        return documentJob
    }
}


// MARK: - Configuration
extension DocumentRepositoryImpl {
    enum API: ResourceType {
        case processingSubmit(param: Parameters)
        case processingCheck(_ id: String)
        case processingReceive(_ id: String)
        
        var endPoint: Endpoint {
            switch self {
            case .processingSubmit:
                return .post(path: "processing/submit")
            case .processingCheck(let id):
                return .get(path: "processing/check/\(id)")
            case .processingReceive(let id):
                return .get(path: "processing/receive/\(id)")
            }
        }
        
        var task: HTTPTask {
            switch self {
            case .processingCheck, .processingReceive:
                return .requestParameters(encoding: .jsonEncoding)
            case .processingSubmit(let param):
                return .requestParameters(bodyParameters: param, encoding: .jsonEncoding)
            }
        }
        
        var headers: HTTPHeaders? {
            authHeader
        }
    }
}
