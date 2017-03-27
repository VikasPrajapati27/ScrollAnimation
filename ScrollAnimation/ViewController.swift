//
//  ViewController.swift
//  ScrollAnimation
//
//  Created by Vikas-MAC237 on 24/03/17.
//  Copyright © 2017 Vikas. All rights reserved.
//

import UIKit

let deviceWidth = UIScreen.main.bounds.width
let deviceHeight = UIScreen.main.bounds.height

class ViewController: UIViewController {

    enum ScrollPosition {
        case top
        case bottom
        
    }

    @IBOutlet weak var viewTemp:UIView!
    
    let scrollViewTemp = UIScrollView.init(frame: CGRect.init(x: 0, y: 0, width: deviceWidth , height: deviceHeight))
    var timerTop:Timer?
    var buttonTop:UIButton!
    var buttonBottom:UIButton!
    let distanceForNotScroll:CGFloat = 50
    var panGestureViewTemp : UIPanGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let gesture = UILongPressGestureRecognizer.init(target: self, action: #selector(self.longPressTouch(longPress:)))
        self.viewTemp.addGestureRecognizer(gesture)
        
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(self.tapGestureTouch(gesture:)))
        self.view.addGestureRecognizer(tapGesture)
        
        scrollViewTemp.backgroundColor = UIColor.lightGray
        scrollViewTemp.contentSize = CGSize.init(width: 2000, height: 2000)
        scrollViewTemp.bounces = false
        self.setBackgorundColorInScroll()
        
        self.view.addSubview(scrollViewTemp)
        self.viewTemp.frame = CGRect.init(x: 100, y: 500, width: 250, height: 250)
        self.scrollViewTemp.contentOffset = CGPoint.init(x: 50, y: 300)
        self.view.setNeedsLayout()
        self.scrollViewTemp.addSubview(viewTemp)
        scrollViewTemp.clipsToBounds = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK:- CUSTOM METHODS
    
    private func setBackgorundColorInScroll(){
        
        var height:CGFloat = 0
        let loop:Int = Int(scrollViewTemp.contentSize.height / 200.00)
        
        for _ in 0..<loop {
            let view = UIView.init(frame: CGRect.init(x: 0, y: scrollViewTemp.frame.origin.y + height, width: scrollViewTemp.contentSize.width, height: 200))
            view.backgroundColor = UIColor.randomColor()
            self.scrollViewTemp.addSubview(view)
            height = height + 200
        }
        
    }
    func tapGestureTouch(gesture: UITapGestureRecognizer){
        
        if gesture.state == .ended{
            
            if !self.viewTemp.frame.contains(gesture.location(in: self.scrollViewTemp)){
                self.removeGesture()
            }
        }
    }
    
    private func removeGesture(){
        
        if self.buttonTop != nil{
            self.buttonTop.removeFromSuperview()
        }
        if self.buttonBottom != nil{
            self.buttonBottom.removeFromSuperview()
        }
        self.stopTimer()
        if self.panGestureViewTemp !=  nil{
            self.viewTemp.removeGestureRecognizer(self.panGestureViewTemp!)
        }
        
    }
    
    private func startTimer(scroll:ScrollPosition){
        
        if ((timerTop == nil) ? true : ((timerTop?.isValid)! ? false:true)){
            
            switch scroll {
            case .top:
                timerTop =  Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.upperScrollCalled), userInfo: nil, repeats: true)
                
            case .bottom:
                timerTop =  Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.downScrollCalled), userInfo: nil, repeats: true)
            }
        }
    }
    
    private func startTimerForViewTemp(scroll:ScrollPosition){
        
        if ((timerTop == nil) ? true : ((timerTop?.isValid)! ? false:true)){
            
            switch scroll {
            case .top:
                timerTop =  Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.upperScrollCalledViewTemp), userInfo: nil, repeats: true)
                
            case .bottom:
                timerTop =  Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.downScrollCalledViewTemp), userInfo: nil, repeats: true)
            }
        }
    }
    
    private func stopTimer(){
        
        if timerTop != nil{
            timerTop?.invalidate()
        }
    }
    
    //MARK:- SCROLLING METHODS
    
    @objc private func upperScrollCalledViewTemp(){
        
        let distanceToMove:CGFloat = 20
        var contentOffset = self.scrollViewTemp.contentOffset
        
        if contentOffset.y >= 100{
            
            contentOffset.y = contentOffset.y - distanceToMove
            self.viewTemp.center = CGPoint(x: self.viewTemp.center.x, y: self.viewTemp.center.y - distanceToMove)
            self.buttonTop.center = CGPoint(x: self.buttonTop.center.x, y: self.buttonTop.center.y - distanceToMove)
            self.buttonBottom.center = CGPoint(x: self.buttonBottom.center.x, y: self.buttonBottom.center.y - distanceToMove)
            
            self.scrollViewTemp.setContentOffset(contentOffset, animated: false)
            
            print("timer called")
        }else{
            self.stopTimer()
        }
    }
    
    @objc private func downScrollCalledViewTemp(){
        
        let distanceToMove:CGFloat = 20
        var contentOffset = self.scrollViewTemp.contentOffset
        let contentSize = self.scrollViewTemp.contentSize
        let totalHeightViewTemp = self.viewTemp.frame.size.height + self.viewTemp.frame.origin.y
        
        if (contentSize.height - totalHeightViewTemp) >= 100{
            
            contentOffset.y = contentOffset.y + distanceToMove
            
            self.viewTemp.center = CGPoint(x: self.viewTemp.center.x, y: self.viewTemp.center.y + distanceToMove)
            self.buttonTop.center = CGPoint(x: self.buttonTop.center.x, y: self.buttonTop.center.y + distanceToMove)
            self.buttonBottom.center = CGPoint(x: self.buttonBottom.center.x, y: self.buttonBottom.center.y + distanceToMove)
            
            self.scrollViewTemp.setContentOffset(contentOffset, animated: false)
            
            print("timer called")
        }else{
            self.stopTimer()
        }
    }
    @objc private func upperScrollCalled(){
        
        let distanceToMove:CGFloat = 20
        var contentOffset = self.scrollViewTemp.contentOffset
        
        if contentOffset.y >= distanceForNotScroll{
            
            contentOffset.y = contentOffset.y - distanceToMove
            
            self.buttonTop.center = CGPoint(x: self.buttonTop.center.x, y: self.buttonTop.center.y - distanceToMove)
            self.viewTemp.frame = CGRect.init(x: self.viewTemp.frame.origin.x, y: self.viewTemp.frame.origin.y - distanceToMove, width: self.viewTemp.frame.width, height: self.viewTemp.frame.height +  distanceToMove)
            
            self.scrollViewTemp.setContentOffset(contentOffset, animated: false)
            
            print("timer called")
        }else{
            self.stopTimer()
        }
    }
    
    @objc private func downScrollCalled(){
        
        let distanceToMove:CGFloat = 20
        var contentOffset = self.scrollViewTemp.contentOffset
        let contentSize = self.scrollViewTemp.contentSize
        let totalHeightViewTemp = self.viewTemp.frame.size.height + self.viewTemp.frame.origin.y
        
        if (contentSize.height - totalHeightViewTemp) >= distanceForNotScroll{
            
            contentOffset.y = contentOffset.y + distanceToMove
            
            self.buttonBottom.center = CGPoint(x: self.buttonBottom.center.x, y: self.buttonBottom.center.y + distanceToMove)
            self.viewTemp.frame = CGRect.init(x: self.viewTemp.frame.origin.x, y: self.viewTemp.frame.origin.y, width: self.viewTemp.frame.width, height: self.viewTemp.frame.height +  distanceToMove)
            
            self.scrollViewTemp.setContentOffset(contentOffset, animated: false)
            
            print("timer called")
        }else{
            self.stopTimer()
        }
    }
    
    //MARK:-  GESTURE METHODS
    
    @objc private  func longPressTouch(longPress: UILongPressGestureRecognizer){
        
        if longPress.state == .began{
            
            self.removeGesture()
            buttonTop = UIButton.init(frame: CGRect.init(x:self.viewTemp.frame.origin.x + self.viewTemp.frame.size.width - 20 , y: self.viewTemp.frame.origin.y - 10, width: 10, height: 10))
            buttonTop.backgroundColor = UIColor.black
            buttonTop.layer.cornerRadius = 5
            
            let panGestureTop = UIPanGestureRecognizer.init(target: self, action: #selector((self.panGestureTop(gesture:))))
            
            panGestureTop.maximumNumberOfTouches = 1
            buttonTop.addGestureRecognizer(panGestureTop)
            
            buttonBottom = UIButton.init(frame: CGRect.init(x: self.viewTemp.frame.origin.x + 20, y: self.viewTemp.frame.height + self.viewTemp.frame.origin.y, width: 10, height: 10))
            buttonBottom.backgroundColor = UIColor.red
            buttonBottom.layer.cornerRadius = 5
            
            let panGestureBottom = UIPanGestureRecognizer.init(target: self, action: #selector((self.panGestureBottom(gesture:))))
            panGestureBottom.maximumNumberOfTouches = 1
            buttonBottom.addGestureRecognizer(panGestureBottom)
            
            panGestureViewTemp = UIPanGestureRecognizer.init(target: self, action: #selector((self.panGestureViewTemp(gesture:))))
            panGestureViewTemp?.maximumNumberOfTouches = 1
            self.viewTemp.addGestureRecognizer(panGestureViewTemp!)
            
            scrollViewTemp.addSubview(buttonTop)
            scrollViewTemp.addSubview(buttonBottom)
        }
    }
    
    func panGestureTop(gesture:UIPanGestureRecognizer){
        
        if gesture.state == .began || gesture.state == .changed {
            
            let pointTranstion = gesture.translation(in: self.viewTemp)
            
            if (self.viewTemp.frame.height - pointTranstion.y) >= 20{
                
                gesture.view!.center = CGPoint(x: gesture.view!.center.x, y: gesture.view!.center.y + pointTranstion.y)
                self.viewTemp.frame = CGRect.init(x: self.viewTemp.frame.origin.x, y: self.viewTemp.frame.origin.y + pointTranstion.y, width: self.viewTemp.frame.width, height: self.viewTemp.frame.height  -  pointTranstion.y)
                
                if (self.viewTemp.frame.origin.y - self.scrollViewTemp.contentOffset.y) <= distanceForNotScroll{
                    
                    if pointTranstion.y > 0.0{
                        self.stopTimer()
                    }else{
                        self.startTimer(scroll: .top)
                    }
                }
            }
            gesture.setTranslation(CGPoint.zero, in: self.viewTemp)
        }
        if gesture.state == .ended{
            self.stopTimer()
        }
    }
    
    func panGestureBottom(gesture:UIPanGestureRecognizer){
        print(gesture)
        
        if gesture.state == .began || gesture.state == .changed {
            
            let pointTranstion = gesture.translation(in: self.viewTemp)
            
            if (self.viewTemp.frame.height + pointTranstion.y) >= 20{
                
                gesture.view!.center = CGPoint(x: gesture.view!.center.x, y: gesture.view!.center.y + pointTranstion.y)
                self.viewTemp.frame = CGRect.init(x: self.viewTemp.frame.origin.x, y: self.viewTemp.frame.origin.y, width: self.viewTemp.frame.width, height: self.viewTemp.frame.height  +  pointTranstion.y)
                
                let x = self.scrollViewTemp.contentOffset.y + UIScreen.main.bounds.height
                
                if (x - gesture.view!.center.y) < distanceForNotScroll{
                    
                    if pointTranstion.y > 0.0{
                        self.startTimer(scroll: .bottom)
                    }else{
                        self.stopTimer()
                    }
                }
                
            }
            gesture.setTranslation(CGPoint.zero, in: self.viewTemp)
        }
        if gesture.state == .ended{
            self.stopTimer()
        }
    }
    
    func panGestureViewTemp(gesture:UIPanGestureRecognizer){
        
        if gesture.state == .began || gesture.state == .changed {
            
            let pointTranstion = gesture.translation(in: self.viewTemp)
            
            if ((self.buttonTop.center.y + pointTranstion.y) >= 40) && ((self.scrollViewTemp.contentSize.height -  (self.viewTemp.frame.origin.y + self.viewTemp.frame.size.height + pointTranstion.y )) >= 40){
                
                gesture.view!.center = CGPoint(x: gesture.view!.center.x, y: gesture.view!.center.y + pointTranstion.y)
                self.buttonTop.center = CGPoint(x: self.buttonTop.center.x, y: self.buttonTop.center.y + pointTranstion.y)
                self.buttonBottom.center = CGPoint(x: self.buttonBottom.center.x, y: self.buttonBottom.center.y + pointTranstion.y)
                
                if (self.viewTemp.frame.origin.y - self.scrollViewTemp.contentOffset.y) <= 100{
                    
                    if pointTranstion.y > 0.0{
                        self.stopTimer()
                    }else{
                        self.startTimerForViewTemp(scroll: .top)
                    }
                }
                
                let x = self.scrollViewTemp.contentOffset.y + UIScreen.main.bounds.height
                
                if (x - buttonBottom.center.y) < 100{
                    
                    if pointTranstion.y > 0.0{
                        self.startTimerForViewTemp(scroll: .bottom)
                    }else{
                        self.stopTimer()
                    }
                }
                
            }
            
            gesture.setTranslation(CGPoint.zero, in: self.viewTemp)
            
        }else{
            self.stopTimer()
        }
    }
    
}


//MARK:- EXTENSIONS

extension UIColor {
    static func randomColor() -> UIColor {
        return UIColor(red:   .random(),
                       green: .random(),
                       blue:  .random(),
                       alpha: 1.0)
    }
}
extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}


