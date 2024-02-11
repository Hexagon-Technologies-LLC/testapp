//
//  ProfileCompletionViewModel.swift
//  KMe
//
//  Created by Le Quang Tuan Cuong(CuongLQT) on 11/02/2024.
//

import Foundation
import Combine

public class ProfileCompletionViewModel: ObservableObject {
    @LazyInjected public var appState: AppStore<AppState>
    @LazyInjected var repoAuth: AuthRepository
    private var cancelBag = CancelBag()
    
    @Published var dateOfBirth: String?
    @Published var email: String = ""
    @Published var firstName: String?
    @Published var middleName: String?
    @Published var lastName: String?
    @Published var gender: String?
    @Published var region: String?
    
    @Published var errorMessage: String?
    @Published var userInfo: UserInfo?
    
    func register() {
        Task {
            do {
                let params = ["dob": self.dateOfBirth,
                              "email": "test@gmail.com",
                              "first_name": self.firstName,
                              "gender": self.gender,
                              "last_name": self.lastName,
                              "middle_name": self.middleName,
                              "photo_url": "",
                              "region": self.region]
                
                let createdUserID = try await repoAuth.createProfile(params: params)
                let userInfo = try await repoAuth.getProfile(id: createdUserID)
                self.userInfo = userInfo
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
    
}