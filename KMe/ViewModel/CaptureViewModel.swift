//
//  CaptureViewModel.swift
//  KMe
//
//  Created by Le Quang Tuan Cuong(CuongLQT) on 14/02/2024.
//

import Foundation

public class CaptureViewModel: ObservableObject {
    @LazyInjected public var appState: AppStore<AppState>
    @LazyInjected var repoDocument: DocumentNetwork
    private var cancelBag = CancelBag()
    @Published var errorMessage: String?
    @Published var loadingState: LoadingState = .none
    @Published var licenseProcessingJob: LicenseJob?
    @Published var passportProcessingJob: PassportJob?
    
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
                    // Receive processed job
                    let job = try await self.repoDocument.processingReceive(id: returnedJobId)
                    
                    // Add processed job into document
                    if let licenseJob = job.licenseJob {
                        licenseProcessingJob = licenseJob
                    } else if let passportJob = job.passportJob {
                        passportProcessingJob = passportJob
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
