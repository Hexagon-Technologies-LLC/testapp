//
//  File.swift
//  
//
//  Created by Le Quang Tuan Cuong(CuongLQT) on 06/02/2024.
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
}

public protocol SystemEvents {
    func sceneDidBecomeActive()
    func sceneWillResignActive()
    func logout()
}


public extension AppState {
    var isAuthorized: Bool { userData.userInfo != nil }
}
