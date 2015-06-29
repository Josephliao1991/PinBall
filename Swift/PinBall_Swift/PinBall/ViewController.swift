//
//  ViewController.swift
//  PinBall
//
//  Created by TSUNG-LUN LIAO on 2015/6/29.
//  Copyright (c) 2015年 TSUNG-LUN LIAO. All rights reserved.
//



import UIKit

class ViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let board:JLPinBallBoard = JLPinBallBoard(frame: CGRectMake(CGFloat(0), CGFloat(0), self.view.frame.size.width, self.view.frame.size.height))
        self.view.addSubview(board)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

