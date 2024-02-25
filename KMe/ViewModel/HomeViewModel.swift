//
//  HomeViewModel.swift
//  KMe
//
//

import Foundation

public class HomeViewModel: ObservableObject {
    @LazyInjected public var appState: AppStore<AppState>
    @LazyInjected var repoDocument: DocumentNetwork
    private var cancelBag = CancelBag()
    @Published var errorMessage: String?
    @Published var documentResult: (passport: [PassportDocument], license: [LicenseDocument])?
    
    func reloadCard() async {
        guard let userInfo = appState[\.userData.userInfo] else { return }
        do {
            let documentsData = try await repoDocument.getDocuments(userId: userInfo.id)
            documentResult = documentsData
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func deleteSingleDocument(_ id: String) async {
        do {
            let _ = try await self.repoDocument.deleteDocumentByID(id: id)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
