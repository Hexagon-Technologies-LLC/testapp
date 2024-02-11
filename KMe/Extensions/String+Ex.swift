//
//  String+Ex.swift
//  KMe
//
//  Created by Le Quang Tuan Cuong(CuongLQT) on 11/02/2024.
//

import Foundation

public extension String {
    enum ValidationType {
        case alphabet
        case alphabetWithSpace
        case alphabetNum
        case alphabetNumWithSpace
        case userName
        case name
        case email
        case number
        case password
        case mobileNumber
        case postalCode
        case custom(String)
        
        var regex: String {
            switch self {
            case .alphabet:
                return "[A-Za-z]+"
            case .alphabetWithSpace:
                return "[A-Za-z ]*"
            case .alphabetNum:
                return "[A-Za-z-0-9]*"
            case .alphabetNumWithSpace:
                return "[A-Za-z0-9 ]*"
            case .userName:
                return "[A-Za-z0-9_]*"
            case .name:
                return "^[A-Z a-z]*$"
            case .email:
                return "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            case .number:
                return "[0-9]+"
            case .password:
                return "^(?=.*[a-zA-Z]).{6,}$"
            case .mobileNumber:
                return "^[0-9]{8,11}$"
            case .postalCode:
                return "^[A-Za-z0-9- ]{1,10}$"
            case .custom(let customRegex):
                return customRegex
            }
        }
    }
    
    func isValid(_ type: ValidationType) -> Bool {
        guard !isEmpty else { return false }
        let regTest = NSPredicate(format: "SELF MATCHES %@", type.regex)
        return regTest.evaluate(with: self)
    }
    
    func decodeBrokenJSON() -> String? {

         var bytes = Data()
         var position = startIndex

         while let range = range(of: "\\u", range: position..<endIndex) {
             bytes.append(contentsOf:self[position ..< range.lowerBound].utf8)
             position = range.upperBound
             let hexCode = self[position...].prefix(4)
             guard hexCode.count == 4, let byte = UInt8(hexCode, radix: 16) else {
                 return nil // Invalid hex code
             }
             bytes.append(byte)
             position = index(position, offsetBy: hexCode.count)
         }
         bytes.append(contentsOf: self[position ..< endIndex].utf8)
         return String(data: bytes, encoding: .utf8)
     }
}
