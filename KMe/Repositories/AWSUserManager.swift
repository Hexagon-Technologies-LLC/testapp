//
//  AWSUserManager.swift
//  KMe
//
//  Created by Le Quang Tuan Cuong(CuongLQT) on 06/02/2024.
//

import Foundation
import Amplify
import AWSCognitoAuthPlugin

public class AWSUserManager {
    public enum SetupResult {
        case success
        case fail
        case sessionExpired
        case doNothing
        case networkError(String)
    }
    
    public static let shared = AWSUserManager()
    public var idToken: String?
    public var accessToken: String?
    
    private struct Defaults {
        static let awsInitialized = "AWSUserManager.awsInitialized"
    }
    
    public private(set) var isInitialized: Bool = false {
        didSet {
            if isInitialized {
                let defaults = UserDefaults.standard
                defaults.set(true, forKey: AWSUserManager.Defaults.awsInitialized)
                defaults.synchronize()
            }
        }
    }
    
    public func setup() async -> SetupResult {
        if isInitialized {
            return await checkUserSession()
        }

        isInitialized = false
        
        do {
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.configure()
        } catch let e {
            print(e.localizedDescription)
        }
        
        
        do {
            let session = try await Amplify.Auth.fetchAuthSession()
            print("Is user signed in - \(session.isSignedIn)")
            if session.isSignedIn {
                self.extractToken(with: session as? AWSAuthCognitoSession)
                
                let checkSessionResult = await self.checkUserSession()
                self.isInitialized = true
                return checkSessionResult
            } else {
                throw AuthError.authNeeded
            }
        } catch let error as AuthError {
            print("Fetch session failed with error \(error)")
            self.isInitialized = true
            return .fail
        } catch {
            print("Unexpected error: \(error)")
            self.isInitialized = true
            return .fail
        }
    }
    
    public func checkUserSession() async  -> SetupResult {
        var result: SetupResult = .fail
        let checkTokenResult = await checkToken()
        if let error = checkTokenResult {
            if (error as NSError).domain == NSURLErrorDomain {
                result = .networkError(error.localizedDescription)
            }
        } else {
            result  = .success
        }
        return result
    }
    
    
    public func checkToken() async -> Error? {
        do {
            let session = try await Amplify.Auth.fetchAuthSession()
            print("Is user signed in - \(session.isSignedIn)")
            if let tokensResult = (session as? AWSAuthCognitoSession)?.getCognitoTokens() {
                switch tokensResult {
                case .success(_):
                    self.extractToken(with: session as? AWSAuthCognitoSession)
                    return nil
                case .failure(let error):
                    print("Token result error: \(error)")
                    return error
                }
            } else {
                print("No Token error")
                throw AuthError.tokenFindError
            }
        } catch let error as AuthError {
            print("Fetch session failed with error \(error)")
            return error
        } catch {
            print("Unexpected error: \(error)")
            return error
        }
    }
    
    private func extractToken(with session: AWSAuthCognitoSession?) {
        guard let session = session else {
            return
        }
        
        do {
            let tokens = try session.getCognitoTokens().get()
            idToken = tokens.idToken
            accessToken = tokens.accessToken
            print("\(tokens)")
        } catch {
            print(error.localizedDescription)
        }
    }
}
