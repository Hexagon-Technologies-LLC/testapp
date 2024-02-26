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
    
    @IBOutlet weak var documentView: UIView!
    @IBOutlet weak var cardType: UILabel!
    @IBOutlet weak var cardName: UILabel!
    @IBOutlet weak var documentNumberName: UILabel!
    @IBOutlet weak var documentNumber: UILabel!
    @IBOutlet weak var cardProfileImage: UIImageView!
    @IBOutlet weak var cardProfileQR: UIImageView!
    @IBOutlet weak var cardDOB: UILabel!
    @IBOutlet weak var documentHeightConstrant: NSLayoutConstraint!
    
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
        documentHeightConstrant.constant = UIScreen.main.bounds.width*0.72
        licenseDocument = license
        let licenseView = DriverDocumentView()
        licenseView.configureDocument(documentInfo: license)
        documentview.addSubview(licenseView)
        licenseView.translatesAutoresizingMaskIntoConstraints = false
        documentview.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            licenseView.centerXAnchor.constraint(equalTo: documentview.centerXAnchor),
            licenseView.centerYAnchor.constraint(equalTo: documentview.centerYAnchor),
            licenseView.widthAnchor.constraint(equalTo: documentview.widthAnchor),
            licenseView.heightAnchor.constraint(equalTo: documentview.heightAnchor)
        ])
        
        documentview.layoutIfNeeded()
        documentview.setNeedsLayout()
    }
    
    func configurePasspore(_ passport: PassportDocument) {
        documentHeightConstrant.constant = UIScreen.main.bounds.width*0.58
        passportDocument = passport
        let passportView = PassportDocumentView()
        passportView.configureDocument(documentInfo: passport)
        documentview.addSubview(passportView)
        passportView.translatesAutoresizingMaskIntoConstraints = false
        documentview.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            passportView.centerXAnchor.constraint(equalTo: documentview.centerXAnchor),
            passportView.centerYAnchor.constraint(equalTo: documentview.centerYAnchor),
            passportView.widthAnchor.constraint(equalTo: documentview.widthAnchor),
            passportView.heightAnchor.constraint(equalTo: documentview.heightAnchor)
        ])
        
        documentview.layoutIfNeeded()
        documentview.setNeedsLayout()
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
