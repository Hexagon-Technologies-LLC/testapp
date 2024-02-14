//
//  DocumentJob.swift
//  KMe
//
//  Created by Le Quang Tuan Cuong(CuongLQT) on 14/02/2024.
//

import Foundation

public struct DocumentJob: Codable, Equatable {
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
}
