//
//  Defined.swift
//  KMe
//
//  Created by Le Quang Tuan Cuong(CuongLQT) on 07/02/2024.
//

import Foundation

struct Defined {
    static let authHostedURL = "https://kme.auth.us-east-1.amazoncognito.com/oauth2/authorize?client_id=45vr75joq0hgjv6k8ath6ifimm&response_type=code&scope=email+openid+phone+profile&redirect_uri=kmeapp%3A%2F%2F"
    static let baseURL = "https://jqejihe8yb.execute-api.us-east-1.amazonaws.com/"
    static let commonDateFormat = "yyyy-MM-dd"
    
    // Age of 18.
    static let MINIMUM_AGE: Date = Calendar.current.date(byAdding: .year, value: -18, to: Date())!;
}
