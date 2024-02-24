//
//  File.swift
//  
//
//

import Combine
import CoreLocation
import SwiftUI

public typealias AppStore<State> = CurrentValueSubject<State, Never>

public protocol AppState {
    var userData: UserData { get set }
    var system: System { get set }
}

public protocol UserData: AnyObject {
    var userInfo: UserInfo? { get set }
}

public protocol System {
    var isActive: Bool { get set }
    var isSystemDialogShow: Bool { get set }
    var keyboardHeight: CGFloat { get set }
    var callbackCode: String? { get set }
}

public protocol SystemEvents {
    func sceneDidBecomeActive()
    func sceneWillResignActive()
    func logout()
}

public extension AppState {
    var isAuthorized: Bool { userData.userInfo != nil }
    
    mutating func logout() {
        self.userData.userInfo = nil
        UserDefaultHandler.userInfo = nil
        UserDefaultHandler.userTokenInfo = nil
        NotificationCenter.default.post(name: Notification.Name("logOut"), object: nil)
    }
}