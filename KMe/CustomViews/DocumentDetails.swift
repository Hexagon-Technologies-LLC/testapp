//
//  Documentsummary.swift
//  KMe
//
//  Created by CSS on 13/09/23.
//

import UIKit
import LocalAuthentication

class DocumentDetails: UIView,Menudelegate {
    func menuselected(menuitem: Int) {
        
    }
    
    func menuclose() {
        optiondelegate?.optionclose()
    }
    
    weak var optiondelegate: Optiondelegate?

    @IBOutlet weak var actionview: UIStackView!
    @IBOutlet weak var bgview: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var namelabel: UILabel!
    @IBOutlet weak var expiredate: UILabel!

    @IBOutlet weak var docimage: UIImageView!
    @IBOutlet weak var documentview: UIView!
    @IBOutlet weak var expireview: UIView!
    @IBOutlet weak var expiredaysview: UIView!

    
    
    @IBOutlet weak var bottomconstraint: NSLayoutConstraint!
    @IBOutlet weak var menubottomconstraint: NSLayoutConstraint!

    @IBOutlet weak var menuview: MoreoptionView!

    @IBOutlet weak var sharedocument: UIButton!
    
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
           let viewFromXib = Bundle.main.loadNibNamed("DocumentDetails", owner: self, options: nil)![0] as! UIView
           viewFromXib.frame = self.bounds
           menuview.menudelegate = self
           addSubview(viewFromXib)
       }

    public func setheightval()  {
        actionview.isHidden = true
    }
}
