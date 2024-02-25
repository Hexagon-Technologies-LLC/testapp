//
//  AddDocuments.swift
//  KMe
//
//

import Foundation

public struct AddDocument {
    var documentData: [String: Any]?
    var documentType: String?
    var editedOCR: Bool?
    var expiryDate: String?
    var OCRData: [String: Any]?
    var region: String?
    var userID: String?
    
    public init(documentData: [String: Any]?,
                documentType: String?,
                editedOCR: Bool?,
                expiryDate: String?,
                OCRData: [String: Any]?,
                region: String?,
                userID: String?) {
        self.documentData = documentData
        self.documentType = documentType
        self.editedOCR = editedOCR
        self.expiryDate = expiryDate
        self.OCRData = OCRData
        self.region = region
        self.userID = userID
    }
    
    func convertToRequest() -> [String: Any?] {
        return [
            "document_data": documentData,
            "document_type": documentType,
            "edited_ocr": editedOCR,
            "expiry_date": expiryDate,
            "ocr_data": OCRData,
            "region": region,
            "user_id": userID,
        ]
    }
}
