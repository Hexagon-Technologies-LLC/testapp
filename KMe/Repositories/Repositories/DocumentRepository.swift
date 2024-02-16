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
    func addDocument(params: [String: Any]) async throws-> String
    func getDocuments(userId: String) async throws -> (passport: [PassportDocument], license: [LicenseDocument])
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
    
    func addDocument(params: [String : Any]) async throws -> String {
        let result: [String: String] = try await execute(endpoint: API.addDocument(param: params), isFullPath: false, logLevel: .debug)
        return result["document_id"] ?? ""
    }
    
    func getDocuments(userId: String) async throws -> (passport: [PassportDocument], license: [LicenseDocument]) {
        let result = try await execute(endpoint: API.getDocuments(userId), isFullPath: false, logLevel: .debug)
        var passportList = [PassportDocument]()
        var licenseList = [LicenseDocument]()
        
        if let json = try? JSON(data: result.data), let arrData = json.array {
            for data in arrData {
                if let documentType = data["document_type"].string {
                    if documentType.lowercased() == "passport" {
                        let passportData = data.data()
                        let passport = try JSONDecoder().decode(PassportDocument.self, from: passportData)
                        passportList.append(passport)
                    } else if documentType.lowercased() == "license" {
                        let licenseData = data.data()
                        let license = try JSONDecoder().decode(LicenseDocument.self, from: licenseData)
                        licenseList.append(license)
                    }
                }
            }
            return (passport: passportList, license: licenseList)
        } else {
            return (passport: [], license: [])
        }
    }
}


// MARK: - Configuration
extension DocumentRepositoryImpl {
    enum API: ResourceType {
        case processingSubmit(param: Parameters)
        case processingCheck(_ id: String)
        case processingReceive(_ id: String)
        case addDocument(param: Parameters)
        case getDocuments(_ userId: String)
        
        var endPoint: Endpoint {
            switch self {
            case .processingSubmit:
                return .post(path: "processing/submit")
            case .processingCheck(let id):
                return .get(path: "processing/check/\(id)")
            case .processingReceive(let id):
                return .get(path: "processing/receive/\(id)")
            case .addDocument(let params):
                return .post(path: "documents/add")
            case .getDocuments(let userId):
                return .get(path: "documents/users/\(userId)")
            }
        }
        
        var task: HTTPTask {
            switch self {
            case .processingCheck, .processingReceive, .getDocuments:
                return .requestParameters(encoding: .jsonEncoding)
            case .processingSubmit(let param), .addDocument(let param):
                return .requestParameters(bodyParameters: param, encoding: .jsonEncoding)
            }
        }
        
        var headers: HTTPHeaders? {
            authHeader
        }
    }
}
