//
//  EditDocumentViewModel.swift
//  KMe
//
//

import Foundation

public class EditDocumentViewModel: ObservableObject {
    @LazyInjected public var appState: AppStore<AppState>
    @LazyInjected var repoDocument: DocumentNetwork
    private var cancelBag = CancelBag()
    @Published var errorMessage: String?
    @Published var loadingState: LoadingState = .none
    @Published var documentIDAdded: String?
    
    @Published var firstName: String?
    @Published var lastName: String?
    @Published var gender: String?
    @Published var dateIssue: String?
    @Published var dateExpired: String?
    @Published var dateOfBirth: String?
    @Published var placeOfBirth: String?
    @Published var licenseNo: String?
    @Published var region: String?
    @Published var height: String?
    @Published var weight: String?
    @Published var eye: String?
    @Published var street: String?
    @Published var city: String?
    @Published var state: String?
    @Published var postalCode: String?
    
    var editingPassport: PassportJob?
    var editingLicense: LicenseJob?
    
    func isAgeInvalid(_ dateInput: Date) -> Bool {
        return dateInput > Defined.MINIMUM_AGE
    }
    
    func submitPassportDocument() async {
        guard let userInfo = appState[\.userData.userInfo] else { return }
        await MainActor.run {
            loadingState = .loading
        }
        
        do {
            
            if let passportJob = editingPassport, let data = passportJob.data {
                let editedInfo = PassportJob(docType: DocumentType.passport.rawValue,
                                             data: PassportJob.PassportJobData(country_region: data.country_region,
                                                                               place_of_birth: placeOfBirth ?? data.place_of_birth,
                                                                               date_of_birth: dateOfBirth ?? data.date_of_birth,
                                                                               date_of_expiration: dateExpired ?? data.date_of_expiration,
                                                                               issuing_authority: data.issuing_authority,
                                                                               date_of_issue: dateIssue ?? data.date_of_issue,
                                                                               last_name: lastName ?? data.last_name,
                                                                               nationality: data.nationality,
                                                                               sex: gender ?? data.sex,
                                                                               first_name: firstName ?? data.first_name))
                
                // Delete old document before upload
                let _ = try await repoDocument.deleteDocumentByType(userID: userInfo.id, documentType: passportJob.docType ?? "")
                let documentData = AddDocument(documentData: editedInfo.data.asDictionary,
                                               documentType: passportJob.docType,
                                               editedOCR: true,
                                               expiryDate: passportJob.data?.date_of_expiration,
                                               OCRData: passportJob.data.asDictionary,
                                               region: passportJob.data?.country_region,
                                               userID: userInfo.id).convertToRequest()
                documentIDAdded = try await self.repoDocument.addDocument(params: documentData as [String : Any])
            }
            
            await MainActor.run {
                loadingState = .done
            }
        } catch {
            errorMessage = "Failed To Process The Image"
            await MainActor.run {
                loadingState = .done
            }
        }
    }
    
    func submitLicenseDocument() async {
        guard let userInfo = appState[\.userData.userInfo] else { return }
        await MainActor.run {
            loadingState = .loading
        }
        
        do {
            if let licenseJob = editingLicense, let data = licenseJob.data {
                let editedInfo = LicenseJob(docType: DocumentType.driverLicense.rawValue,
                                            data: LicenseJob.LicenseJobData(city: city ?? data.city,
                                                                            state: state ?? data.state,
                                                                            street_address: street ?? data.street_address,
                                                                            postal_code: postalCode ?? data.postal_code,
                                                                            country_region: data.country_region,
                                                                            region: region ?? data.region,
                                                                            date_of_birth: dateOfBirth ?? data.date_of_birth,
                                                                            date_of_expiration: dateExpired ?? data.date_of_expiration,
                                                                            date_of_issue: dateIssue ?? data.date_of_issue,
                                                                            first_name: firstName ?? data.first_name,
                                                                            last_name: lastName ?? data.last_name,
                                                                            document_number: licenseNo ?? data.document_number,
                                                                            document_discriminator: data.document_discriminator,
                                                                            sex: gender ?? data.sex,
                                                                            height: height ?? data.height,
                                                                            weight: weight ?? data.weight,
                                                                            eye_color: eye ?? data.eye_color,
                                                                            endorsements: data.endorsements,
                                                                            restrictions: data.restrictions))
                // Delete old document before upload
                let _ = try await repoDocument.deleteDocumentByType(userID: userInfo.id, documentType: licenseJob.docType ?? "")
                let documentData = AddDocument(documentData: editedInfo.data.asDictionary,
                                               documentType: licenseJob.docType,
                                               editedOCR: true,
                                               expiryDate: licenseJob.data?.date_of_expiration,
                                               OCRData: licenseJob.data.asDictionary,
                                               region: licenseJob.data?.region,
                                               userID: userInfo.id).convertToRequest()
                documentIDAdded = try await self.repoDocument.addDocument(params: documentData as [String : Any])
            }
        } catch {
            errorMessage = "Failed To Process The Image"
            await MainActor.run {
                loadingState = .done
            }
        }
        
    }
}
