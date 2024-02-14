//
//  LoginViewModel.swift
//  KMe
//
//  Created by Le Quang Tuan Cuong(CuongLQT) on 14/02/2024.
//

import Foundation
import JWTDecode

enum LoginState: Equatable {
    case loggedIn
    case unRegistered(email: String)
}

public class LoginViewModel: ObservableObject {
    @LazyInjected public var appState: AppStore<AppState>
    @LazyInjected var repoAuth: AuthRepository
    private var cancelBag = CancelBag()
    @Published var errorMessage: String?
    @Published var loginState: LoginState?
    
    func loginProcess() async {
        var idToken = ""
        if let callbackCode = appState[\.system.callbackCode] {
            idToken = callbackCode
            appState[\.system.callbackCode] = nil
        }
        guard !idToken.isEmpty else {
            return
        }
        
        do {
            let decodedToken = try decode(jwt: idToken)
            if let email = decodedToken.body["email"] as? String {
                do {
                    let _ = try await repoAuth.getProfile(email: email)
                    await MainActor.run {
                        loginState = .loggedIn
                    }
                } catch {
                    await MainActor.run {
                        loginState = .unRegistered(email: email)
                    }
                }
            } else {
                errorMessage = "Email not found"
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
