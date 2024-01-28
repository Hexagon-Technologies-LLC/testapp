//
//  FlingActionButton.swift
//  KMe
//
//  Created by CSS on 05/09/23.
//

import UIKit

class FlingActionButton: UIButton {

    
    private var panGestureR:UIPanGestureRecognizer?
    
    private var swipableView:UILabel?
    private var swipeOverlay:UIImageView?

    
    private(set) var swipe_direction:Swipe_Direction = .none
    
    
    enum Swipe_Direction {
        case right
        case left
        case none
    }
    
    @IBInspectable var InitialStateColor: UIColor? = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0) {
        didSet {
            self.InitialStateColor = InitialStateColor!
        }
    }
    
    @IBInspectable var FinalStateColor: UIColor? = UIColor(red: 0.0/255.0 , green: 138.0/255.0, blue: 62.0/255.0, alpha: 1.0) {
        didSet {
            self.FinalStateColor = FinalStateColor!
        }
    }
    
    @IBInspectable var ImageOverlay: UIImage?  {
        didSet {
            self.ImageOverlay = ImageOverlay!
        }
    }
    
    
    override func draw(_ rect: CGRect) {
        
        if self.swipableView == nil {
            self.addSubview(self.setSwipableLayer())
        }
        self.clipsToBounds = true
        super.draw(rect)
    }
    
    // To Add the swipable lable with pan-gesture enabled over the button
    func setSwipableLayer() -> UIView {
        self.layer.cornerRadius = self.frame.size.height/2
        
        swipableView = UILabel.init(frame: CGRect(x: 8 , y: 8, width: self.frame.size.height - 16, height: (self.frame.size.height - 16)))
        swipableView?.isUserInteractionEnabled = true
        swipableView?.textAlignment = .left
        swipableView?.tag = 1020
        swipableView?.textColor = self.titleColor(for: UIControl.State.normal)
        swipableView?.backgroundColor = InitialStateColor
        swipableView?.layer.cornerRadius = (swipableView?.frame.height)!/2
        swipableView?.font = UIFont.boldSystemFont(ofSize: 16.0)
        swipableView?.clipsToBounds = true
        
        
        if (ImageOverlay != nil) {
            swipeOverlay = UIImageView.init(image: ImageOverlay)
            swipeOverlay!.frame = CGRect(x: 8 , y: 8, width: (swipableView?.frame.width)! - 16, height: (swipableView?.frame.width)! - 16)
            swipeOverlay!.isUserInteractionEnabled = true
            swipeOverlay!.backgroundColor = UIColor.clear
            swipeOverlay!.contentMode = UIView.ContentMode.scaleAspectFill
            swipeOverlay?.clipsToBounds = true
            swipableView?.insertSubview(swipeOverlay!, at: 1)
        }
        
        
        panGestureR = UIPanGestureRecognizer.init(target: self, action: #selector(handelPanGesture(panGesture:)))
        swipableView!.addGestureRecognizer(panGestureR!)
        
        return swipableView!
    }
    
    
    @objc func handelPanGesture(panGesture: UIPanGestureRecognizer) {
        
        let translation = panGesture.translation(in: panGesture.view?.superview)
        let xPos:Int = Int(translation.x)
        let threshHoldX:Int = Int(self.frame.size.width - self.frame.size.height)
        if xPos >= 0 {
            if self.swipe_direction == .none {
                self.swipe_direction = self.getSwipeDirection(translation: translation)
            }
            
            if self.swipe_direction == .right {
                if Int((self.swipableView?.frame.origin.x)!) > threshHoldX {
                    //Ignore if the state is final.
                    return
                }
                
                if panGesture.state == UIGestureRecognizer.State.ended {
                    if  xPos > threshHoldX {
                        UIView.animate(withDuration: 0.2, animations: {
                            self.swipableView!.frame = CGRect(x:((self.frame.size.width)-(self.swipableView?.frame.size.width)! - 8), y: (self.swipableView?.frame.origin.y)!, width: (self.swipableView?.frame.size.width)!, height: (self.frame.size.height - 16))
                        })
                        UIView.animate(withDuration: 0.5) {
                            self.swipableView?.backgroundColor = self.FinalStateColor
                            self.swipeOverlay?.transform = (self.swipeOverlay?.transform.rotated(by: CGFloat(180.0 * .pi / 180.0)))!                        }
                        self.sendActions(for: .valueChanged)
                    }else {
                        UIView.animate(withDuration: 0.2, animations: {
                            self.swipableView!.frame = CGRect(x:8, y: (self.swipableView?.frame.origin.y)!, width: (self.swipableView?.frame.size.width)!, height: (self.frame.size.height - 16))
                        })
                    }
                }else{
                    if xPos > threshHoldX {
                        return
                    }
                    //To set the x position of the swipe lable layer to the gesture translation value.
                    UIView.animate(withDuration: 0.0) {
                        self.swipableView!.frame = CGRect(x: (translation.x) , y: (self.swipableView?.frame.origin.y)!, width: (self.swipableView?.frame.size.width)!, height: (self.frame.size.height - 16))
                    }
                    
                }
            }
        }
        
    }
    
    
    //To reset teh fling button to initial state.
    func reset() {
        UIView.animate(withDuration: 0.2, animations: {
            self.swipe_direction = .none
            self.swipableView!.frame = CGRect(x:2, y: (self.swipableView?.frame.origin.y)!, width: (self.swipableView?.frame.size.width)!, height: (self.frame.size.height - 4))
        })
        
        UIView.animate(withDuration: 0.5) {
            self.swipableView?.backgroundColor = self.InitialStateColor
            self.swipeOverlay?.transform = (self.swipeOverlay?.transform.rotated(by: CGFloat(180.0 * .pi / 180.0)))!
        }
    }
    
    
    func getSwipeDirection(translation:CGPoint) -> Swipe_Direction {
        
        if translation.x > 0 {
            return .right
        }else if translation.x < 0 {
            return .left
        }else{
            return .none
        }
        
    }
    
    override func sendActions(for controlEvents: UIControl.Event) {
        super.sendActions(for: controlEvents)
    }

}
