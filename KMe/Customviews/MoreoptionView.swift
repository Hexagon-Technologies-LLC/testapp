//
//  MoreoptionView.swift
//  KMe
//
//  Created by CSS on 20/09/23.
//

import UIKit
protocol Menudelegate: AnyObject {
    func  menuselected(menuitem: Int)
    func menuclose()

}
class MoreoptionView: UIView {
    weak var menudelegate: Menudelegate?

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBOutlet weak var sharemenu: UILabel!
    @IBOutlet weak var bgview: UIView!
    @IBOutlet weak var deletemenu: UILabel!

    @IBOutlet weak var closemenu: UIButton!
    @IBAction func closemenu(_ sender: Any) {
        menudelegate?.menuclose()
    }
    
    
    override init(frame: CGRect) {
           super.init(frame: frame)
           commonInit()
       }
       
       required init?(coder: NSCoder) {
           super.init(coder: coder)
           commonInit()
           
           let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.someAction (_:)))
           sharemenu.isUserInteractionEnabled = true
           sharemenu.addGestureRecognizer(gesture)
           
           let deletegesture = UITapGestureRecognizer(target: self, action:  #selector (self.deleteAction (_:)))
           deletemenu.isUserInteractionEnabled = true
           deletemenu.addGestureRecognizer(deletegesture)
           
           
           let bggestuure = UITapGestureRecognizer(target: self, action:  #selector (self.dummyAction (_:)))

           bgview.isUserInteractionEnabled = true
           bgview.addGestureRecognizer(bggestuure)

       }
    @objc func dummyAction(_ sender:UITapGestureRecognizer){
    }
    @objc func deleteAction(_ sender:UITapGestureRecognizer){
        menudelegate?.menuselected(menuitem: 2)

    }
    @objc func someAction(_ sender:UITapGestureRecognizer){
        menudelegate?.menuselected(menuitem: 0)
    }
       
       func commonInit(){
           let viewFromXib = Bundle.main.loadNibNamed("MoreoptionView", owner: self, options: nil)![0] as! UIView
           viewFromXib.frame = self.bounds
           viewFromXib.layer.cornerRadius  = 16
           viewFromXib.clipsToBounds = true
           addSubview(viewFromXib)
       }

}
