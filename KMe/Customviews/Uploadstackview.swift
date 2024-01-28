//
//  Uploadstackview.swift
//  KMe
//
//  Created by CSS on 12/09/23.
//

import UIKit
protocol requestaccessdelegate: AnyObject {
    func requestclick(index: Int)
    

}
class Uploadstackview: UIView {
    weak var requestdelegate: requestaccessdelegate?
    @IBOutlet weak var requestaccessbtn: UIButton!
    @IBOutlet weak var titlelabel: UILabel!
    @IBOutlet weak var rightimage: UIImageView!
    @IBOutlet weak var leftimage: UIImageView!

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBAction func requestaccess(_ sender: UIButton) {
       
        
        requestdelegate?.requestclick(index: sender.tag)
    
    }
    
}
