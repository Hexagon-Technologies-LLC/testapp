//
//  DocumentNetwork.swift
//  KMe
//
//

import Foundation
import Combine
import Foundation

protocol DocumentNetwork: WebNetwork {
    func processingSubmit(params: [String: Any]) async throws -> String
    func processingCheck(id: String) async throws -> Bool
    func processingReceive(id: String) async throws -> DocumentJob
    func addDocument(params: [String: Any]) async throws-> String
    func getDocuments(userId: String) async throws -> (passport: [PassportDocument], license: [LicenseDocument])
    func deleteDocumentByType(userID: String, documentType: String) async throws -> String
    func deleteDocumentByID(id: String) async throws -> String
}

struct DocumentNetworkImpl {
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
extension DocumentNetworkImpl: DocumentNetwork {
    func processingSubmit(params: [String : Any]) async throws -> String {
        let userInfo: [String: String] = try await execute(endpoint: API.processingSubmit(param: params), isFullPath: false, logLevel: .debug)
        return userInfo["job_id"] ?? ""
    }
    
    func processingCheck(id: String) async throws -> Bool {
        let userInfo: [String: Bool] = try await execute(endpoint: API.processingCheck(id), isFullPath: false, logLevel: .debug)
        return userInfo["completion_status"] ?? false
    }
    
    func processingReceive(id: String) async throws -> DocumentJob {
        var documentJob = DocumentJob()
        let result = try await execute(endpoint: API.processingReceive(id), isFullPath: false, logLevel: .debug)
        if let json = try? JSON(data: result.data), let dict = json.dictionary {
            if let docType = dict["docType"]?.string {
                if docType.elementsEqual(DocumentType.passport.rawValue) {
                    let passport = try JSONDecoder().decode(PassportJob.self, from: result.data)
                    documentJob.passportJob = passport
                } else if docType.elementsEqual(DocumentType.driverLicense.rawValue) {
                    let license = try JSONDecoder().decode(LicenseJob.self, from: result.data)
                    documentJob.licenseJob = license
                }
            }
        }
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
                    if documentType.lowercased() == DocumentType.passport.rawValue {
                        let passportData = data.data()
                        let passport = try JSONDecoder().decode(PassportDocument.self, from: passportData)
                        passportList.append(passport)
                    } else if documentType.lowercased() == DocumentType.driverLicense.rawValue {
                        let licenseData = data.data()
                        let license = try JSONDecoder().decode(LicenseDocument.self, from: licenseData)
                        licenseList.append(license)
                    }
                }
            }
            let licenseSorted = licenseList.sorted(by: { $0.createAtDate.compare($1.createAtDate) == .orderedAscending} )
            let passportSorted = passportList.sorted(by: { $0.createAtDate.compare($1.createAtDate) == .orderedAscending} )
            
            return (passport: passportSorted, license: licenseSorted)
        } else {
            return (passport: [], license: [])
        }
    }
    
    func deleteDocumentByType(userID: String, documentType: String) async throws -> String {
        let result: [String: String] = try await execute(endpoint: API.deleteDocumentByType(userID, documentType: documentType), isFullPath: false, logLevel: .debug)
        return result["document_id"] ?? ""
    }
    
    func deleteDocumentByID(id: String) async throws -> String {
        let result: [String: String] = try await execute(endpoint: API.deleteDocumentByID(id), isFullPath: false, logLevel: .debug)
        return result["document_id"] ?? ""
    }
}


// MARK: - Configuration
extension DocumentNetworkImpl {
    enum API: ResourceType {
        case processingSubmit(param: Parameters)
        case processingCheck(_ id: String)
        case processingReceive(_ id: String)
        case addDocument(param: Parameters)
        case getDocuments(_ userId: String)
        case deleteDocumentByType(_ userID: String, documentType: String)
        case deleteDocumentByID(_ id: String)
        
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
            case .deleteDocumentByType(let userID, let documentType):
                return .delete(path: "documents/delete/\(userID)?documentType=\(documentType)")
            case .deleteDocumentByID(let id):
                return .delete(path: "documents/\(id)")
                
            }
        }
        
        var task: HTTPTask {
            switch self {
            case .processingCheck, .processingReceive, .getDocuments, .deleteDocumentByID, .deleteDocumentByType(_, _):
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
