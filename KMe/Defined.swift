//
//  Defined.swift
//  KMe
//
//  Created by Le Quang Tuan Cuong(CuongLQT) on 07/02/2024.
//

import Foundation

struct Defined {
    static let authHostedURL = "https://kme.auth.us-east-1.amazoncognito.com/login?client_id=2so19e2ueaujl5d4uv786kcvi1&response_type=token&scope=email+openid+phone+profile&redirect_uri=kmeapp%3A%2F%2F"
    static let baseURL = "https://jqejihe8yb.execute-api.us-east-1.amazonaws.com/"
    static let commonDateFormat = "dd/MM/yyyy"
    
    // Age of 18.
    static let MINIMUM_AGE: Date = Calendar.current.date(byAdding: .year, value: -18, to: Date())!;
}
