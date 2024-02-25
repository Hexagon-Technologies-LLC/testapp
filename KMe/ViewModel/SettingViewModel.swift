//
//  SettingViewModel.swift
//  KMe
//
//

import Foundation


public class SettingViewModel: ObservableObject {
    @LazyInjected public var appState: AppStore<AppState>
    @LazyInjected var repoAuth: AuthNetwork
    private var cancelBag = CancelBag()
    @Published var errorMessage: String?
    
    func deleteAccount() async {
        guard let userInfo = appState[\.userData.userInfo] else { return }
        do {
            let deletedUser = try await self.repoAuth.deleteProfile(id: userInfo.id)
            if !deletedUser.isEmpty {
                self.appState.value.logout()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
