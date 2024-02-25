//
//  DocumentJob.swift
//  KMe
//
//

import Foundation

struct DocumentJob {
    var licenseJob: LicenseJob?
    var passportJob: PassportJob?
}

struct LicenseJob: Codable, Equatable {
    var docType: String?
    var data: LicenseJobData?
    
    struct LicenseJobData: Codable, Equatable {
        let city: String
        let state: String
        let street_address: String
        let postal_code: String
        let country_region: String
        let region: String
        let date_of_birth: String
        let date_of_expiration: String
        let date_of_issue: String
        let first_name: String
        let last_name: String
        let document_number: String
        let document_discriminator: String
        let sex: String
        let height: String
        let weight: String
        let eye_color: String
        let endorsements: String
        let restrictions: String
        
        var sexString: String {
            Gender(rawValue: sex)?.toString ?? ""
        }
    }
}
    
struct PassportJob: Codable, Equatable {
    var docType: String?
    var data: PassportJobData?
    
    struct PassportJobData: Codable, Equatable {
        var country_region: String
        var place_of_birth: String
        var date_of_birth: String
        var date_of_expiration: String
        var issuing_authority: String
        var date_of_issue: String
        var last_name: String
        var nationality: String
        var sex: String
        var first_name: String
        
        var sexString: String {
            Gender(rawValue: sex)?.toString ?? ""
        }
    }
}
