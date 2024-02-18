//
//  Documentsummary.swift
//  KMe
//
//  Created by CSS on 13/09/23.
//

import UIKit
import LocalAuthentication

protocol Optiondelegate: AnyObject {
    func optionselected(menuitem: Int)
    func optionclose()
    func copyclipboardsuccess()
    func menuselected(menuitem: DocumentMenuAction, license: LicenseDocument?, passport: PassportDocument?)
}
class Documentsummary: UIView {
    weak var optiondelegate: Optiondelegate?

    @IBOutlet weak var actionview: UIStackView!
    @IBOutlet weak var bgview: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var namelabel: UILabel!
    @IBOutlet weak var docimage: UIImageView!
    @IBOutlet weak var documentview: UIView!
    @IBOutlet weak var bottomconstraint: NSLayoutConstraint!
    @IBOutlet weak var menubottomconstraint: NSLayoutConstraint!

    @IBOutlet weak var menuview: MoreoptionView!
    @IBOutlet weak var sharedocument: UIButton!
    
    @IBOutlet weak var cardType: UILabel!
    @IBOutlet weak var cardName: UILabel!
    @IBOutlet weak var documentNumberName: UILabel!
    @IBOutlet weak var documentNumber: UILabel!
    @IBOutlet weak var cardProfileImage: UIImageView!
    @IBOutlet weak var cardProfileQR: UIImageView!
    @IBOutlet weak var cardDOB: UILabel!
    var licenseDocument: LicenseDocument?
    var passportDocument: PassportDocument?
    
    // Card Detail
    
    @IBAction func copyclipboard(_ sender: Any) {
        UIPasteboard.general.string = "BEHPM3927C"
        optiondelegate?.copyclipboardsuccess()
    }
    @IBAction func authenticateUser(_ sender: Any) {
        authenticate()
    }
    
    @IBAction func showmoremenu(_ sender: Any) {
        optiondelegate?.optionselected(menuitem: self.tag)
    }
    
    func configureDriverLicenseCard(_ license: LicenseDocument) {
        cardProfileQR.isHidden = true
        cardProfileImage.isHidden = true
        documentNumberName.text = "LIC NO"
        documentNumber.text = license.document_data?.document_number
        cardType.text = DocumentType.driverLicense.title.uppercased()
        cardName.text = license.document_data?.fullName
        cardDOB.text = license.document_data?.date_of_birth?.toDate(dateFormat: "yyyy-MM-dd")?.toString(dateFormat: "dd/MM/yyyy")
        licenseDocument = license
    }
    
    func configurePasspore(_ passport: PassportDocument) {
        cardProfileQR.isHidden = true
        cardProfileImage.isHidden = true
        documentNumberName.text = "PASSPORT NO"
        documentNumber.isHidden = true
//        documentNumber.text = passport.document_data?.document_number
        cardType.text =  DocumentType.passport.title.uppercased()
        cardName.text = passport.document_data?.fullName
        cardDOB.text = passport.document_data?.date_of_birth?.toDate(dateFormat: "yyyy-MM-dd")?.toString(dateFormat: "dd/MM/yyyy")
        passportDocument = passport
    }
    
    func authenticate() {
            let authenticationContext = LAContext()
            var error: NSError?
            let reasonString = "Touch the Touch ID sensor to unlock."

            // Check if the device can evaluate the policy.
            if authenticationContext.canEvaluatePolicy(LAPolicy.deviceOwnerAuthentication, error: &error) {

                authenticationContext.evaluatePolicy( .deviceOwnerAuthentication, localizedReason: reasonString, reply: { (success, evalPolicyError) in

                    if success {
                        print("success")
                    } else {
                        // Handle evaluation failure or cancel
                    }
                })

            } else {
                print("passcode not set")
            }
        }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
           super.init(frame: frame)
           commonInit()
       }
       
       required init?(coder: NSCoder) {
           super.init(coder: coder)
           commonInit()
       }
       
       func commonInit(){
           let viewFromXib = Bundle.main.loadNibNamed("Documentsummary", owner: self, options: nil)![0] as! UIView
           viewFromXib.frame = self.bounds
           menuview.menudelegate = self
           addSubview(viewFromXib)
       }

    public func setheightval()  {
        actionview.isHidden = true
    }
}

extension Documentsummary: MenuDelegate {
    func menuselected(menuitem: DocumentMenuAction) {
        optiondelegate?.menuselected(menuitem: menuitem, license: licenseDocument, passport: passportDocument)
    }
    
    func menuclose() {
        optiondelegate?.optionclose()
    }
}
