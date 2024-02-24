//
//  AppEnvironment.swift
//  KMe
//
//

import Foundation
import Combine
import UIKit
import SwiftUI

class AppEnvironmentImpl: AppEnvironment {
    var appState: AppStore<AppState>
    var serviceConfig: ServiceConfiguration = Configuration()
    var systemEventsHandler: SystemEvents
    
    init() {
        self.appState = .init(AppStateImpl())
        self.systemEventsHandler = SystemEventsImpl(self.appState)
    }
}


// MARK: - AppState
extension AppEnvironmentImpl {
    struct AppStateImpl: AppState {
        var userData: UserData = UserDataImpl()
        var system: System = SystemImpl()
        
        class UserDataImpl: UserData {
            var userInfo: UserInfo?
        }
        
        struct SystemImpl: System {
            var isSystemDialogShow: Bool = false
            var locale: String = "en"
            var isActive: Bool = false
            var keyboardHeight: CGFloat = 0
            var callbackCode: String? = ""
        }
    }
}

// MARK: - Configuration
extension AppEnvironmentImpl {
    struct Configuration: ServiceConfiguration {
        var environment: NetworkEnvironment = .testing(url: Defined.baseURL)
        
        var urlSession: URLSession {
            let configuration = URLSessionConfiguration.default
            configuration.timeoutIntervalForRequest = 15
            configuration.timeoutIntervalForResource = 15
            configuration.waitsForConnectivity = true
            configuration.httpMaximumConnectionsPerHost = 5
            configuration.requestCachePolicy = .returnCacheDataElseLoad
            configuration.urlCache = .shared
            return URLSession(configuration: configuration)
        }
    }
}


// MARK: - SystemEventsImpl
extension AppEnvironmentImpl {
    class SystemEventsImpl: SystemEvents {
        var appState: AppStore<AppState>
        private var cancelBag = CancelBag()
        
        init(_ appState: AppStore<AppState>) {
            self.appState = appState
            setupUserData()
        }
        
        private func setupUserData() {
            appState[\.userData.userInfo] = UserDefaultHandler.userInfo
        }
        
        func sceneDidBecomeActive() {
            if appState[\.system.isActive] == false { appState[\.system.isActive] = true }
            print("sceneDidBecomeActive", appState[\.system.isActive])
        }
        
        func sceneWillResignActive() {
            if appState[\.system.isActive] == true { appState[\.system.isActive] = false }
            print("sceneWillResignActive", appState[\.system.isActive])
        }
        
        func logout() {
            print("logout")
        }
    }
}

