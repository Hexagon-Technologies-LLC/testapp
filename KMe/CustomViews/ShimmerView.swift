//
//  ShimmerView.swift
//  KMe
//
//  Created by CSS on 31/10/23.
//

import UIKit

class ShimmerView: UIView {
    let gradientLayer = CAGradientLayer()

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var gradientColorOne : CGColor = UIColor.init(hex: "323232").cgColor
    var gradientColorTwo : CGColor = UIColor.init(hex: "535353").cgColor
    
    
    
    func addGradientLayer() -> CAGradientLayer {
        
        
        gradientLayer.frame = self.bounds
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.colors = [gradientColorOne, gradientColorTwo, gradientColorOne]
        gradientLayer.locations = [0.0, 0.5, 1.0]
        gradientLayer.frame = self.bounds
        self.layer.addSublayer(gradientLayer)
        
        return gradientLayer
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //self.frame will be correct here
        gradientLayer.frame = self.bounds
    }
    
    func addAnimation() -> CABasicAnimation {
       
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [-1.0, -0.5, 0.0]
        animation.toValue = [1.0, 1.5, 2.0]
        animation.repeatCount = .infinity
        animation.duration = 0.9
        return animation
    }
    
    func startAnimating() {
        
        let gradientLayer = addGradientLayer()
        let animation = addAnimation()
       
        gradientLayer.add(animation, forKey: animation.keyPath)
    }


}
