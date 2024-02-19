//
//  PassportDocumentView.swift
//  KMe
//
//  Created by Le Quang Tuan Cuong(CuongLQT) on 19/02/2024.
//

import UIKit

class PassportDocumentView: BaseXibView {
    @IBOutlet weak var cardType: UILabel!
    @IBOutlet weak var cardName: UILabel!
    @IBOutlet weak var cardRegion: UILabel!
    @IBOutlet weak var documentNumberName: UILabel!
    @IBOutlet weak var documentNumber: UILabel!
    @IBOutlet weak var cardDOB: UILabel!
    @IBOutlet weak var cardAuthorize: UILabel!
    
    @IBOutlet weak var cardDateExpired: UILabel!
    @IBOutlet weak var cardDateIssue: UILabel!
    @IBOutlet weak var cardSex: UILabel!
    @IBOutlet weak var cardPlaceOfBirth: UILabel!
    
    override func viewSettings() {
        //
    }
    
    func configureDocument(documentInfo: PassportDocument) {
        cardType.text =  DocumentType.passport.title.uppercased()
        cardRegion.text = documentInfo.region
        cardAuthorize.text = documentInfo.document_data?.issuing_authority
        
        cardName.text = documentInfo.document_data?.fullName
        
        cardSex.text = documentInfo.document_data?.sex
        cardDateIssue.text = documentInfo.document_data?.date_of_issue
        cardDateExpired.text = documentInfo.document_data?.date_of_expiration
        
        cardDOB.text = documentInfo.document_data?.date_of_birth?.toDate(dateFormat: "yyyy-MM-dd")?.toString(dateFormat: "dd/MM/yyyy")
        cardPlaceOfBirth.text = documentInfo.document_data?.place_of_birth
    }
}
