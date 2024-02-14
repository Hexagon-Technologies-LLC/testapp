//
//  EditProfileViewModel.swift
//  KMe
//
//  Created by Le Quang Tuan Cuong(CuongLQT) on 14/02/2024.
//

import Foundation

public class EditProfileViewModel: ObservableObject {
    @LazyInjected public var appState: AppStore<AppState>
    @LazyInjected var repoAuth: AuthRepository
    private var cancelBag = CancelBag()
    
    @Published var dateOfBirth: String?
    @Published var firstName: String?
    @Published var middleName: String?
    @Published var lastName: String?
    @Published var gender: String?
    @Published var region: String?
    
    @Published var errorMessage: String?
    @Published var isUpdateSuccess: Bool?
    
    func updateProfile() async {
        guard let userInfo = appState[\.userData.userInfo] else { return }
        
        do {
            let params = ["dob": dateOfBirth,
                          "first_name": firstName,
                          "gender": gender,
                          "last_name": lastName,
                          "middle_name": middleName,
                          "region": region]
            let createdUserID = try await repoAuth.updateProfile(id: userInfo.id, params: params)
            if !createdUserID.isEmpty {
                let _ = try await repoAuth.getProfile(id: createdUserID)
                isUpdateSuccess = true
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func isAgeInvalid(_ dateInput: Date) -> Bool {
        return dateInput > Defined.MINIMUM_AGE
    }
}
