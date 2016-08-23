//
//  VHHorSegmentView.swift
//  SwiftTestDemo
//
//  Created by keyan on 16/6/29.
//  Copyright © 2016年 keyan. All rights reserved.
//
//获取物理屏幕的尺寸
//#define VHScreenHeight  ([UIScreen mainScreen].bounds.size.height)
//#define VHScreenWidth   ([UIScreen mainScreen].bounds.size.width)
//#define VH_SW           ((VHScreenWidth<VHScreenHeight)?VHScreenWidth:VHScreenHeight)
//#define VH_SH           ((VHScreenWidth<VHScreenHeight)?VHScreenHeight:VHScreenWidth)
//#define VH_RATE         (VH_SW/320.0)
//#define VH_RATE_SCALE   (VH_SW/375.0)//以ip6为标准 ip5缩小 ip6p放大 zoom
//#define VH_RATE_6P      ((VH_SW>375.0)?VH_SW/375.0:1.0)//只有6p会放大

import UIKit
let VHScreenWidth = UIScreen.mainScreen().bounds.size.width
let VHScreenHeight = UIScreen.mainScreen().bounds.size.height
func VH_SW() -> CGFloat {
    return  (VHScreenWidth < VHScreenHeight) ? VHScreenWidth:VHScreenHeight
}
func VH_SH() -> CGFloat {
    return  (VHScreenWidth < VHScreenHeight) ? VHScreenHeight:VHScreenWidth
}
let VH_RATE = VH_SW()/CGFloat(320.0)
let VH_RATE_SCALE = VH_SW()/CGFloat(375.0)
//func VH_RATE_6P() -> CGFloat {
//    return (VH_SW>CGFloat(375.0))? VH_SW()/CGFloat(375.0): CGFloat(1.0)
//}


let GapWidth:CGFloat = 10


let ButtonTag = 1000


typealias VHHorSegmentViewBlock = (index: Int) -> ()

class VHHorSegmentView: UIView {

    var titleArray:[AnyObject]?
    var buttonArray:[AnyObject]?
    var sliderLine:UILabel?
    
    
    var segmentViewBlock:VHHorSegmentViewBlock?
    
    
    
    var contentScrollView:UIScrollView?
    override init(frame: CGRect ) {
        super.init(frame: frame)
        
      
   
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    init(frame: CGRect , dataArray: [AnyObject] ,block:VHHorSegmentViewBlock?) {
        super.init(frame: frame)
        
        if (block != nil) {
            self.segmentViewBlock = block
        }
        
        
        buttonArray = [];
        self.titleArray = dataArray;
    
        self.contentScrollView = UIScrollView.init(frame: self.bounds)
        self.contentScrollView?.backgroundColor = UIColor.grayColor()
        addSubview(self.contentScrollView!)
        
//        let  buttonWidth = self.bounds.width/(CGFloat)(dataArray.count);
        
        
        var  totalWidth:CGFloat = 0
        var  firstWidth:CGFloat = 0;
        var  button_x:CGFloat = GapWidth;
        for i in 0..<dataArray.count {
            let button = UIButton(type:.Custom)
            button.backgroundColor = UIColor.clearColor()
            button.addTarget(self, action: #selector(self.buttonClick(_:)), forControlEvents: .TouchUpInside)
            button.setTitle(dataArray[i] as? String, forState: .Normal)
            button.tag = ButtonTag+i

            self.buttonArray?.append(button)
            let tempWidth:CGFloat =  (button.titleLabel?.text!.boundingRectWithSize(CGSizeMake(200, self.bounds.height), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: (button.titleLabel?.font)!]  , context: nil).width)!
            button.frame = CGRectMake(button_x, 0, tempWidth, self.bounds.height)

            button_x = tempWidth+button_x+GapWidth
            
            totalWidth = totalWidth+CGFloat(button.frame.size.width)+GapWidth
            self.contentScrollView?.addSubview(button)
            if i==0 {
                firstWidth = button.frame.size.width
                button.setTitleColor(UIColor.redColor(), forState: .Normal)
            }
   
        }
        
        self.contentScrollView?.contentSize = CGSizeMake(totalWidth+GapWidth, self.bounds.height)
        
        self.sliderLine = UILabel.init(frame: CGRectMake(0, (CGRectGetHeight(contentScrollView!.frame)-1) , firstWidth,1))
        self.sliderLine?.backgroundColor = UIColor.blueColor()
        contentScrollView?.addSubview(self.sliderLine!)
    }

    
    
    @objc private func buttonClick(button:UIButton) {
        print("\(self.buttonArray)")

        
        
        for  button in (self.buttonArray)!{
            if button .isKindOfClass(UIButton) {
                button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            }
        }

        
        button.setTitleColor(UIColor.redColor(), forState: .Normal)
        UIView.animateWithDuration(0.3, animations: {
            self.sliderLine?.frame = CGRectMake(button.frame.origin.x, self.sliderLine!.frame.origin.y, button.frame.size.width, self.sliderLine!.frame.size.height)
        })
        
        self.segmentViewBlock!(index : button.tag-ButtonTag)
        
        
    }
    
    
//    func changeTitleColor(index:NSInteger) {
//
//    }
    
    
    
    
}


