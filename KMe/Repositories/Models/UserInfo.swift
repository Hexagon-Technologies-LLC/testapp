//
//  UserInfo.swift
//  
//
//  Created by Le Quang Tuan Cuong(CuongLQT) on 06/02/2024.
//

import Foundation


public struct TokenInfo: Codable {
    let id_token: String
    let access_token: String
    let refresh_token: String
    let expires_in: Int
}

public struct UserInfo: Codable, Equatable {
    let id: String
    let email: String
    let first_name: String
    let last_name: String
    let gender: String
    let middle_name: String
    let password: String?
    let photo_url: String?
    let region: String
    let username: String?
    let dob: String
    
    var fullName: String {
        first_name + " " + middle_name + " " + last_name
    }
    
    var dobFormatted: String? {
        let dateFromString = dob.toDate()
        return dateFromString?.toString()
    }
}
