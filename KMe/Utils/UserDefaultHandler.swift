//
//  UserDefaultHandler.swift
//  KMe
//
//  Created by Le Quang Tuan Cuong(CuongLQT) on 09/02/2024.
//

import Foundation

public enum UserDefaultKey: String {
    case userTokenInfo = "userTokenInfo"
    case userInfo = "userInfo"
    case userSelectedLanguage = "userSelectedLanguage"
    case pushDeviceToken = "pushDeviceToken"
}

public struct UserDefaultHandler {
    @LazyInjected static var appState: AppStore<AppState>
    static let udStandard = UserDefaults.standard
    
    public static var userTokenInfo: TokenInfo? {
        get {
            UserDefaults.standard.codableObject(dataType: TokenInfo.self, key: UserDefaultKey.userTokenInfo.rawValue)
        }
        set {
            UserDefaults.standard.setCodableObject(newValue, forKey: UserDefaultKey.userTokenInfo.rawValue)
        }
    }
    
    public static var userInfo: UserInfo? {
        get {
            UserDefaults.standard.codableObject(dataType: UserInfo.self, key: UserDefaultKey.userInfo.rawValue)
        }
        set {
            UserDefaults.standard.setCodableObject(newValue, forKey: UserDefaultKey.userInfo.rawValue)
            appState[\.userData.userInfo] = UserDefaultHandler.userInfo
        }
    }
}
