//
//  JLPinBallBoard.swift
//  PinBall
//
//  Created by TSUNG-LUN LIAO on 2015/6/29.
//  Copyright (c) 2015年 TSUNG-LUN LIAO. All rights reserved.
//

import UIKit

class JLPinBallBoard: UIView, UICollisionBehaviorDelegate {

// MARK: -
// MARK: defind
    let ballSize       :CGFloat     =   25
    let ballElasticity :CGFloat     =   0.6
    let ballFriction   :CGFloat     =   1
    let ballDensity    :CGFloat     =   8
    
    let pinSize        :CGFloat     =   3
    let pinWidthBlock  :CGFloat     =   30
    let pinHeightBlock :CGFloat     =   15
    let pinDownBlock   :CGFloat     =   10

// MARK: -
// MARK: Various
    var animator        :UIDynamicAnimator!
    var gravity         :UIGravityBehavior!
    var collision       :UICollisionBehavior!
    var itemBehavior    :UIDynamicItemBehavior!
    
    var pinArray        :NSMutableArray!

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.pinArray = NSMutableArray()
        self.settingPin()
        self.setEnvironment()
        
        self.setTouchView()
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
// MARK: - Physical Environment Setting
    private func setEnvironment(){
        
        //add animator
        animator    =   UIDynamicAnimator(referenceView: self)
        
        //add Gravity
        gravity     =   UIGravityBehavior(items: [])
        gravity.gravityDirection = CGVector(dx: 0, dy: 1)
        animator.addBehavior(gravity)
        
        //add Collision
        collision = UICollisionBehavior(items: [])
        collision.translatesReferenceBoundsIntoBoundary = true
        
        // add a boundary that has the same frame as the pin
        for pin in self.pinArray{
            
            collision.addBoundaryWithIdentifier("pin", forPath: UIBezierPath(rect: pin.frame))
            animator.addBehavior(collision)
        }
        
        collision.collisionDelegate = self
        
        //add itemBehavior
        itemBehavior = UIDynamicItemBehavior(items: [])
        itemBehavior.elasticity = ballElasticity
        itemBehavior.friction   = ballFriction
        itemBehavior.density    = ballDensity
        itemBehavior.allowsRotation = true
        animator.addBehavior(itemBehavior)
        
        
    }
    
// MARK: - Creat View Function
    private func settingPin(){
        
        let dwTimes = Int(Float(self.frame.size.width) / Float(ballSize + pinWidthBlock))
        var dw      = (self.frame.size.width - pinSize) / CGFloat(dwTimes)
        
        let dh      = ballSize + pinHeightBlock
        let dhTimes = Int(self.frame.size.height * 0.73 / dh)
        
        for indexH in 0...dhTimes{
            
            for indexW in 0...dwTimes{
                
                
                var x = Float(indexW) * Float(dw)
                let y = (Float(indexH) * Float(dh))
                
                if indexH%2 == 0 {
                    
                    x -= Float(dw/2)
                }

                let pin:UIView = UIView(frame: CGRectMake(CGFloat(x), CGFloat(y), pinSize, pinSize))
                
                self.addSubview(pin)
                pin.backgroundColor = UIColor.blackColor()
                pin.layer.cornerRadius = pin.frame.size.width/2
                self.pinArray.addObject(pin)
                
            }
            
        }
        
        let ldwTimes    = Int(Float(self.frame.size.width) / Float(ballSize * 1.6))
        let ldw         = (self.frame.size.width - pinSize) / CGFloat(ldwTimes)
        
        let ldh         = pinDownBlock
        let ldhTimes    = Int(self.frame.size.height * 0.3 / ldh)
        
        for indexLH in 0...ldhTimes{
            
            for indexLW in 0...ldwTimes{
                
                let x = Float(indexLW) * Float(ldw)
                let y = Float(indexLH) * Float(ldh) + Float(self.frame.size.height * 0.8)
                
                let pin:UIView = UIView(frame: CGRectMake(CGFloat(x), CGFloat(y), pinSize, pinSize))
                self.addSubview(pin)
                pin.backgroundColor = UIColor.blackColor()
                pin.layer.cornerRadius = pin.frame.size.width/2
                self.pinArray.addObject(pin)
                
            }
        }
    
    }
    
    private func settingBall(x:Float, y:Float){
        
        let ball:UIView!

        ball = UIView(frame: CGRectMake(CGFloat(x), CGFloat(y), ballSize, ballSize))
        ball.backgroundColor = UIColor.blackColor()
        self.addSubview(ball)
        ball.layer.cornerRadius = ball.frame.size.width/2
        
        self.gravity.addItem(ball)
        self.collision.addItem(ball)
        self.itemBehavior.addItem(ball)
        
    }
    
    private func setTouchView(){
    
        let touchView:UIView = UIView(frame: CGRectMake(CGFloat(0), CGFloat(0), self.frame.size.width, self.frame.size.height*0.2))
        touchView.backgroundColor = UIColor.grayColor()
        touchView.alpha = 0.3
        touchView.layer.cornerRadius = touchView.frame.size.height/3
        
        let label:UILabel = UILabel(frame: CGRectMake(CGFloat(0), CGFloat(0), self.frame.size.width, self.frame.size.height*0.2))
        label.text = "Please Touch Here!"
        label.font = UIFont.systemFontOfSize(15)
        label.textColor = UIColor.whiteColor()
        label.textAlignment = NSTextAlignment.Center
        label.center = touchView.center
        touchView.addSubview(label)
        
        self.addSubview(touchView)
        
    }
    
// MARK: - Touch Event
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        //
        
        let point:CGPoint   = (touches.first as! UITouch).locationInView(self)
        if point.y > self.frame.size.height*0.2{
            return
        }
        
        self.settingBall(Float(point.x), y: Float(point.y))
        
    }


// MARK: - UICollisionBehaviorDelegate
    
    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying, atPoint p: CGPoint) {
 
        let collidingView = item as! UIView

        UIView.animateWithDuration(0.1, animations: { () -> Void in
            //
            collidingView.backgroundColor = UIColor.grayColor()
            
        }) { (Bool) -> Void in
            //
            collidingView.backgroundColor = UIColor.blackColor()
        }
        
        
    }

    
}
