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

public struct UserInfo: Codable {
    let email: String
    let firstName: String
    let lastName: String
    let gender: String
    let middle_name: String
    let password: Bool
    let photo_url: Int
    let region: Int
    let username: Bool
    let dob: String
}
