//
//  UIKit+Ex.swift
//  KMe
//
//  Created by Le Quang Tuan Cuong(CuongLQT) on 11/02/2024.
//

import Foundation
import UIKit

public extension UIScreen {
    static func visibleViewController(baseVC: UIViewController? = nil) -> UIViewController? {
        let rootVC = baseVC ?? UIApplication.shared.windows.first(where: \.isKeyWindow)?.rootViewController
        
        if let nav = rootVC as? UINavigationController {
            return visibleViewController(baseVC: nav.visibleViewController)
        }
        if let tab = rootVC as? UITabBarController, let selected = tab.selectedViewController {
            return visibleViewController(baseVC: selected)
        }
        if let presented = rootVC?.presentedViewController {
            return visibleViewController(baseVC: presented)
        }
        return rootVC
    }
}
