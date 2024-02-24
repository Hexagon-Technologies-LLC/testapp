//
//  KAlert.swift
//  KMe
//
//

import Foundation
import UIKit

public class KMAlert {
    public static func alert(title: String,
                             message: String? = nil,
                             sumbitTitle: String = "OK",
                             submitAction: @escaping (UIAlertAction) -> Void) {
        
        if let vc = UIScreen.visibleViewController() {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: sumbitTitle, style: .default, handler: submitAction))
            
            DispatchQueue.main.async {
                vc.present(alert, animated: true)
            }
        }
    }
    
    public static func confirmAlert(title: String,
                                    message: String? = nil,
                                    cancelTitle: String = "Cancel",
                                    submitTitle: String = "OK",
                                    cancelAction: @escaping (UIAlertAction) -> Void,
                                    submitAction: @escaping (UIAlertAction) -> Void) {
        
        if let vc = UIScreen.visibleViewController() {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: cancelTitle, style: .default, handler: cancelAction))
            alert.addAction(UIAlertAction(title: submitTitle, style: .destructive, handler: submitAction))
            
            DispatchQueue.main.async {
                vc.present(alert, animated: true)
            }
        }
    }
    
    public static func actionSheetDefault(title: String,
                             message: String? = nil,
                             sumbitTitle: String = "OK",
                             submitAction: @escaping (UIAlertAction) -> Void) {
        
        if let vc = UIScreen.visibleViewController() {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: sumbitTitle, style: .default, handler: submitAction))
            
            DispatchQueue.main.async {
                vc.present(alert, animated: true)
            }
        }
    }
    
    public static func actionSheetConfirm(title: String,
                                          message: String? = nil,
                                          cancelTitle: String = "Cancel",
                                          submitTitle: String = "OK",
                                          cancelAction: @escaping (UIAlertAction) -> Void,
                                          submitAction: @escaping (UIAlertAction) -> Void) {
        
        if let vc = UIScreen.visibleViewController() {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: cancelTitle, style: .default, handler: cancelAction))
            alert.addAction(UIAlertAction(title: submitTitle, style: .destructive, handler: submitAction))
            
            DispatchQueue.main.async {
                vc.present(alert, animated: true)
            }
        }
    }
}
