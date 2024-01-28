//
//  EmptyRequestView.swift
//  KMe
//
//  Created by CSS on 31/10/23.
//

import UIKit
protocol Invitedelegate: AnyObject {
   
    func inviteclicked()
}
class EmptyRequestView: UIView {
    weak var invitedelegate: Invitedelegate?

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBAction func inviteclicked(_ sender: UIButton) {
        invitedelegate?.inviteclicked()
    }
  

}
