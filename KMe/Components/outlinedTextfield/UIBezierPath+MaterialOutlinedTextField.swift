//
//  UIBezierPath+MaterialOutlinedTextField.swift
//  KMe
//
//  Created by CSS on 08/09/23.
//

import UIKit

extension UIBezierPath {
    func addTopRightCorner(from point1: CGPoint, to point2: CGPoint, with radius: CGFloat) {
        let startAngle = -(CGFloat.pi / 2)
        let endAngle = CGFloat.zero
        let center = CGPoint(x: point1.x, y: point2.y)
        addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
    }

    func addBottomRightCorner(from point1: CGPoint, to point2: CGPoint, with radius: CGFloat) {
        let startAngle = CGFloat.zero
        let endAngle = -((CGFloat.pi * 3) / 2)
        let center = CGPoint(x: point2.x, y: point1.y)
        addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
    }

    func addBottomLeftCorner(from point1: CGPoint, to point2: CGPoint, with radius: CGFloat) {
        let startAngle = -((CGFloat.pi * 3) / 2)
        let endAngle = -CGFloat.pi
        let center = CGPoint(x: point1.x, y: point2.y)
        addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
    }

    func addTopLeftCorner(from point1: CGPoint, to point2: CGPoint, with radius: CGFloat) {
        let startAngle = -CGFloat.pi
        let endAngle = -(CGFloat.pi / 2)
        let center = CGPoint(x: point1.x + radius, y: point2.y + radius)
        addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
    }
}
