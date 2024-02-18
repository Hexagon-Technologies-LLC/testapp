//
//  CaptureViewModel.swift
//  KMe
//
//  Created by Le Quang Tuan Cuong(CuongLQT) on 14/02/2024.
//

import Foundation

public class CaptureViewModel: ObservableObject {
    @LazyInjected public var appState: AppStore<AppState>
    @LazyInjected var repoDocument: DocumentRepository
    private var cancelBag = CancelBag()
    @Published var errorMessage: String?
    @Published var loadingState: LoadingState = .none
    @Published var documentIDAdded: String?
    
    var retryStatusCount = 0
    
    func submitToProgressing(documentBase64: String) async {
        guard let userInfo = appState[\.userData.userInfo] else { return }
        retryStatusCount = 0
        await MainActor.run {
            loadingState = .loading
        }
        
        do {
            let params = ["user_id": userInfo.id,
                          "document_b64": documentBase64]
            let returnedJobId = try await self.repoDocument.processingSubmit(params: params)
            if !returnedJobId.isEmpty {
                let processingStatus = await self.processingCheck(jobId: returnedJobId)
                if processingStatus {
                    let job = try await self.repoDocument.processingReceive(id: returnedJobId)

                    if let licenseJob = job.licenseJob {
                        let documentData = AddDocument(documentData: licenseJob.data.asDictionary,
                                                       documentType: licenseJob.docType,
                                                       editedOCR: false,
                                                       expiryDate: licenseJob.data?.date_of_expiration,
                                                       OCRData: licenseJob.asDictionary,
                                                       region: licenseJob.data?.region,
                                                       userID: userInfo.id).convertToRequest()
                        documentIDAdded = try await self.repoDocument.addDocument(params: documentData as [String : Any])
                    } else if let passportJob = job.passportJob {
                        let documentData = AddDocument(documentData: passportJob.data.asDictionary,
                                                       documentType: passportJob.docType,
                                                       editedOCR: false,
                                                       expiryDate: passportJob.data?.date_of_expiration,
                                                       OCRData: passportJob.asDictionary,
                                                       region: passportJob.data?.country_region,
                                                       userID: userInfo.id).convertToRequest()
                        documentIDAdded = try await self.repoDocument.addDocument(params: documentData as [String : Any])
                    }
                    
                    await MainActor.run {
                        loadingState = .done
                    }
                }
            }
        } catch {
            errorMessage = "Failed to process image"
            await MainActor.run {
                loadingState = .done
            }
        }
    }
    
    func processingCheck(jobId: String) async -> Bool {
        let retryTime = 6
        do {
            if retryStatusCount <= retryTime {
                let processingStatus = try await self.repoDocument.processingCheck(id: jobId)
                if !processingStatus {
                    print("🥵 STARTING RETRY CHECK")
                    try await Task.sleep(seconds: 2)
                    retryStatusCount += 1
                    return await processingCheck(jobId: jobId)
                } else {
                    return true
                }
            } else {
                return false
            }
        } catch {
            if retryStatusCount <= retryTime {
                print("🥵 STARTING RETRY CHECK")
                retryStatusCount += 1
                return await processingCheck(jobId: jobId)
            }
            return false
        }
    }
}
