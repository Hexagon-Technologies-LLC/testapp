//
//  InviteViewController.swift
//  KMe
//
//  Created by CSS on 05/10/23.
//

import UIKit
import ToastViewSwift

class InviteViewController: UIViewController {
    @IBOutlet weak var searchview: UIView!
    @IBOutlet weak var searchfield: UITextField!
    @IBOutlet weak var addkidview: UIView!
    @IBOutlet weak var copyinvite: UIImageView!
    @IBOutlet weak var invitemembers: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        searchview.layer.borderWidth = 1.0
        searchview.layer.borderColor = UIColor.init(hex: "E1FF00").cgColor
        // Do any additional setup after loading the view.
        searchfield.attributedPlaceholder = NSAttributedString(
            string: "Search by name or email id…",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        searchfield.isUserInteractionEnabled = false
                    let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.uploadAction (_:)))
        addkidview.addGestureRecognizer(gesture)
        let searchinvite = UITapGestureRecognizer(target: self, action:  #selector (self.searchInvite (_:)))
searchview.addGestureRecognizer(searchinvite)
        
        let invitegesture = UITapGestureRecognizer(target: self, action:  #selector (self.copyInvite (_:)))
copyinvite.addGestureRecognizer(invitegesture)
        
        let textcontent = "Invite to KMe members"
        let myAttribute = [ NSAttributedString.Key.font: UIFont(name: "Montserrat-SemiBold", size: 20.0)! ]
        let myString = NSMutableAttributedString(string: textcontent, attributes: myAttribute )
        let myRange = NSRange(location: 10 , length: 4) // range starting at location 17 with a lenth of 7: "Strings"
        myString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.init(named: "accent")!, range: myRange)

        invitemembers.attributedText = myString
    }
    
    @objc func searchInvite(_ sender:UITapGestureRecognizer){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SendInviteViewController") as! SendInviteViewController
        self.navigationController?.pushViewController(nextViewController, animated:true)
    }
    @objc func copyInvite(_ sender:UITapGestureRecognizer){
        
     
        let config = ToastConfiguration(
            direction: .bottom,
            dismissBy: [.time(time: 4.0), .swipe(direction: .natural), .longPress],
            animationTime: 0.2
        )
        let attributes = [
            NSAttributedString.Key.font: UIFont(name: "Montserrat-Semibold", size: 15)!,
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
        let attributedString  = NSMutableAttributedString(string: "Invite link is copied!" , attributes: attributes)
        let toast = Toast.text(attributedString,config: config)

        toast.show()
    }
    @objc func uploadAction(_ sender:UITapGestureRecognizer){
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "AddKidsViewController") as! AddKidsViewController
        self.navigationController?.pushViewController(nextViewController, animated:true)
    }

    @IBAction func backnavigation(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}
