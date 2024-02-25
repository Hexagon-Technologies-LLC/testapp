//
//  Document.swift
//  KMe
//
//

import Foundation


//public struct Document: Codable {
//    var document_data: [String: Any]?
//    var document_type: String?
//    var edited_ocr: Bool?
//    var expiry_date: String?
//    var ocr_data: [String: Any]?
//    var region: String?
//    var user_id: String?
//}

public struct PassportDocument: Codable {
    var document_id: String
    var created_at: String
    var document_data: PassportData?
    var document_type: String?
    var edited_ocr: Bool?
    var expiry_date: String?
    var ocr_data: PassportData?
    var region: String?
    var user_id: String?

    struct PassportData: Codable {
        var sex: String?
        var last_name: String?
        var first_name: String?
        var nationality: String?
        var date_of_birth: String?
        var date_of_issue: String?
        var country_region: String?
        var place_of_birth: String?
        var issuing_authority: String?
        var date_of_expiration: String?
        
        var fullName: String {
            return (last_name ?? "") + " " + (first_name ?? "")
        }
    }
    
    var createAtDate: Date {
        return created_at.toDateISO8601() ?? Date()
    }
    
    var documentTypeName: String {
        return DocumentType.passport.title
    }
}

public struct LicenseDocument: Codable {
    var document_id: String
    var created_at: String
    var document_data: LicenseData?
    var document_type: String?
    var edited_ocr: Bool?
    var expiry_date: String?
    var ocr_data: LicenseData?
    var region: String?
    var user_id: String?
    
    struct LicenseData: Codable {
        var sex: String?
        var city: String?
        var state: String?
        var height: String?
        var region: String?
        var weight: String?
        var eye_color: String?
        var last_name: String?
        var first_name: String?
        var postal_code: String?
        var endorsements: String?
        var restrictions: String?
        var date_of_birth: String?
        var date_of_issue: String?
        var country_region: String?
        var street_address: String?
        var document_number: String?
        var date_of_expiration: String?
        var document_discriminator: String?
        
        var fullName: String {
            return (last_name ?? "") + " " + (first_name ?? "")
        }
        
        var fullAddress: String {
            return "\(street_address ?? "")\n\(city ?? ""), \(state ?? ""), \(postal_code ?? "")"
        }
    }
    
    var createAtDate: Date {
        return created_at.toDateISO8601() ?? Date()
    }
    
    var documentTypeName: String {
        return DocumentType.driverLicense.title
    }
}
