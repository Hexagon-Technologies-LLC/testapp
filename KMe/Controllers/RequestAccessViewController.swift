//
//  RequestAccessViewController.swift
//  KMe
//
//  Created by CSS on 06/10/23.
//

import UIKit

/**Create protocol for delegation**/
protocol Requestdelegate: AnyObject {
   
    func requestclosed()
}
class RequestAccessViewController: UIViewController {
    /**declare Delegate method for request access**/
    weak var requestdelegate: Requestdelegate?

    /**Declare IBOUTLET components**/
    @IBOutlet weak var editorview: UIView!
    @IBOutlet weak var placeholderview: UILabel!
    @IBOutlet weak var messageeditor: UITextView!
    @IBOutlet weak var closebtn: UIImageView!

    var placeholderLabel : UILabel!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        /**Customize uitextview with placeholder**/
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissableViewTapped))
        closebtn.addGestureRecognizer(gestureRecognizer)
        closebtn.isUserInteractionEnabled = true
        editorview.layer.borderWidth  = 1.0
        editorview.layer.borderColor = UIColor.init(named: "accent")?.cgColor
        editorview.layer.cornerRadius = 10
        editorview.clipsToBounds = true
        editorview.bringSubviewToFront(placeholderview)
        // Do any additional setup after loading the view.
        messageeditor.delegate = self
               placeholderLabel = UILabel()
               placeholderLabel.text = "Type your purpose of access"
               placeholderLabel.font = .italicSystemFont(ofSize: (messageeditor.font?.pointSize)!)
               placeholderLabel.sizeToFit()
                messageeditor.addSubview(placeholderLabel)
               placeholderLabel.frame.origin = CGPoint(x: 5, y: (messageeditor.font?.pointSize)! / 2)
               placeholderLabel.textColor = .secondaryLabel
               placeholderLabel.isHidden = !messageeditor.text.isEmpty
    }
    
    
    /**Tapgesture action for close  button**/
    
    @objc
    fileprivate func dismissableViewTapped() {
        /**dismiss keyboard while click closee  button**/

        messageeditor.resignFirstResponder()
        /**close delegate function called**/
        requestdelegate?.requestclosed()
    }

  
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func requestclosed(_ sender: UIButton) {
        /**close delegate function called**/
        requestdelegate?.requestclosed()
    }
  
}

/**Delegate function to handle uitextview placeholder**/
extension RequestAccessViewController : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel?.isHidden = !textView.text.isEmpty
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        placeholderLabel?.isHidden = !textView.text.isEmpty
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeholderLabel?.isHidden = !textView.text.isEmpty
    }
}
