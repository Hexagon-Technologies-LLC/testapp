//
//  KMeNetworkingModule.swift
//  KMeNetworkingModule
//
//  Copyright © All rights reserved.
//

// Include Foundation
@_exported import Foundation

public enum NetworkEnvironment {
    case testing(url: String)
    case production(url: String)
    case dev(url: String)
    
    var url: String {
        switch self {
        case .testing(let url), .production(let url), .dev(let url):
            return url
        }
    }
}

public protocol RequestInterceptor {
    func refreshToken() async throws
}

public protocol ServiceConfiguration {
    var environment: NetworkEnvironment { get }
    var urlSession: URLSession { get }
//    var interceptor: RequestInterceptor { get }
}

public protocol AppEnvironment {
    var appState: AppStore<AppState> { get }
    var serviceConfig: ServiceConfiguration { get }
    var systemEventsHandler: SystemEvents { get }
}

/// RepositoryModule module definition
public final class KMeNetworking<T: AppEnvironment> {
    // MARK: - Fields
    var env: T
    // MARK: - Initializers
    
    /// Initializes a new instance
    public init(env: T) {
        // Initialize instance here as needed
        self.env = env
    }
    
    // MARK: - Routing
    
    /// Registers DI
    public func registerDI() {
        print("KMeNetworking registerDI")
        Resolver.register { self.env.appState }.scope(.shared)
        Resolver.register { self.env.systemEventsHandler }.scope(.shared)
        
        Resolver.register {
            AuthNetworkImpl(configuration: self.env.serviceConfig)
        }.implements(AuthNetwork.self)
        
        Resolver.register {
            DocumentNetworkImpl(configuration: self.env.serviceConfig)
        }.implements(DocumentNetwork.self)
    }
}
