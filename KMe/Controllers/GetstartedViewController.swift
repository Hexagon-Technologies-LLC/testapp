//
//  GetstartedViewController.swift
//  KMe
//
//  Created by CSS on 07/09/23.
//

import UIKit

class GetstartedViewController: UIViewController {
    @IBOutlet weak var contentLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /**This static content and change color for particular characters **/
        let myAttribute = [ NSAttributedString.Key.font: UIFont(name: "Montserrat-SemiBold", size: 40.0)! ]
        let myString = NSMutableAttributedString(string: "Streamline Your KYC DOC’s with KMe!", attributes: myAttribute )
        let myRange = NSRange(location: 31, length: 3) // range starting at location 17 with a lenth of 7: "Strings"
        myString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.init(named: "accent")!, range: myRange)
        
        contentLabel.attributedText = myString
        // Do any additional setup after loading the view.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    override func viewWillAppear(_ animated: Bool) {
        /**To hide default nav bar **/
        
        self.navigationController?.isNavigationBarHidden = true
    }
    @IBAction func flingActionCallback(_ sender: FlingActionButton){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(nextViewController, animated:true)
    }
}
