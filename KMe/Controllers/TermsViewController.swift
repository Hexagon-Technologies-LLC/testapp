//
//  GetstartedViewController.swift
//  KMe
//
//  Created by CSS on 07/09/23.
//

import UIKit
import WebKit

class TermsViewController: UIViewController ,WKNavigationDelegate{
    /**Declare IBOUTLET components**/
    @IBOutlet weak var webview: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /**To load terms and condition url to webview**/
        let url = URL(string: "https://www.iadeptive.com/privacy-policy")!
        webview.load(URLRequest(url: url))
        webview.allowsBackForwardNavigationGestures = true
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
        /**To hide default navigation bar**/
        self.navigationController?.isNavigationBarHidden = true
    }
    @IBAction func backnavigation(_ sender: UIButton){
        /**Action for back button move to previous screen**/
        
        self.navigationController?.popViewController(animated: true)
    }
}
