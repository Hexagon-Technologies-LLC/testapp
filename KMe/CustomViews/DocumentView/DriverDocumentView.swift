//
//  DriverDocumentView.swift
//  KMe
//
//  Created by Le Quang Tuan Cuong(CuongLQT) on 20/02/2024.
//

import UIKit

class DriverDocumentView: BaseXibView {
    @IBOutlet weak var cardType: UILabel!
    @IBOutlet weak var cardName: UILabel!
    @IBOutlet weak var cardRegion: UILabel!
    @IBOutlet weak var cardDOB: UILabel!
    @IBOutlet weak var cardNo: UILabel!
    @IBOutlet weak var cardRest: UILabel!
    @IBOutlet weak var cardDateExpired: UILabel!
    @IBOutlet weak var cardDateIssue: UILabel!
    @IBOutlet weak var cardSex: UILabel!
    @IBOutlet weak var cardAddress: UILabel!
    @IBOutlet weak var cardDiscriminator: UILabel!
    
    @IBOutlet weak var cardEye: UILabel!
    @IBOutlet weak var cardWeight: UILabel!
    @IBOutlet weak var cardHeight: UILabel!
    
    override func viewSettings() {
        //
    }
    
    func configureDocument(documentInfo: LicenseDocument) {
        cardType.text =  DocumentType.driverLicense.title.uppercased()
        cardRegion.text = documentInfo.region
        cardNo.text = documentInfo.document_data?.document_number
    
        cardName.text = documentInfo.document_data?.fullName
        
        cardSex.text = documentInfo.document_data?.sex
        cardDateIssue.text = documentInfo.document_data?.date_of_issue
        cardDateExpired.text = documentInfo.document_data?.date_of_expiration
        
        cardDOB.text = documentInfo.document_data?.date_of_birth?.toDate(dateFormat: "yyyy-MM-dd")?.toString(dateFormat: "dd/MM/yyyy")
        
        cardEye.text = documentInfo.document_data?.eye_color
        cardWeight.text = documentInfo.document_data?.weight
        cardHeight.text = documentInfo.document_data?.height
        
        cardAddress.text = documentInfo.document_data?.fullAddress
        cardRest.text = documentInfo.document_data?.restrictions
        cardDiscriminator.text = documentInfo.document_data?.document_discriminator
//        cardPlaceOfBirth.text = documentInfo.document_data?.place_of_birth
    }
}
