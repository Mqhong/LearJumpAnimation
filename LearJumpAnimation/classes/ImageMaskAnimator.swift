//
//  ImageMaskAnimator.swift
//  LearJumpAnimation
//
//  Created by mm on 2017/5/18.
//  Copyright © 2017年 mm. All rights reserved.
//
import Foundation
import UIKit

enum ImageMaskTransitionType{
    case present
    case dismiss
}


class ImageMaskAnimator: NSObject,UIViewControllerAnimatedTransitioning{
    var config:TransitionConfig
    var maskContentView:UIImageView!
    var imageView:UIImageView!
    var blurImage:UIImage?
    var transitionType:ImageMaskTransitionType = .present
    init(config:TransitionConfig){
        self.config = config
        super.init()
    }
    /**
    把toView添加到转场ContainView中，并且定义好toView的初始位和状态
    定义好FromView和ToView的转场结束时候的状态
    创建fromView到toView动画
    */
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)!
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        let containView = transitionContext.containerView
        let frame = UIScreen.main.bounds
        maskContentView = UIImageView(frame: frame)
        maskContentView.backgroundColor = UIColor.lightGray
        
        if self.transitionType == .present {
            let fromImageView = self.config.fromImageView
            fromImageView.isHidden = true
            let adjustFromRect = fromImageView.convert(fromImageView.bounds, to: containView)
            
            let toImageView = self.config.toImageView!
            toImageView.isHidden = true
            //Create content Blur View
            #if(arch(i386) || arch(x86_64) && os(iOS))
                print("因为性能比较低，影响展示效果，所以被拒绝")
            #else
                self.blurImage = fromView.blurScreenShot(3.0)
                maskContentView.image = fromView.blurScreenShot(3.0)
            #endif
            maskContentView.frame = containView.bounds
            containView.addSubview(self.maskContentView)
            
            let adjustToRect = toImageView.convert(toImageView.bounds, to: containView)
            
            imageView = UIImageView(frame:adjustFromRect)
            imageView.image = fromImageView.image
            containView.addSubview(imageView)
            
            //Set up shadow
            imageView.layer.shadowColor = UIColor.black.cgColor
            imageView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
            imageView.layer.shadowRadius = 10.0
            imageView.layer.shadowOpacity = 0.8
            
            //Animation phase 1, change transform and frame
            UIView.animate(withDuration: 0.5 / 1.6 * self.config.presentDuration, animations: {
                self.imageView.frame = adjustToRect
                self.imageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }){(finished) in
                //Animation phase 2,change transform to default,clear shadow
                UIView.animate(withDuration: 0.3 / 1.6 * self.config.presentDuration, animations: {
                    self.imageView.transform = CGAffineTransform.identity
                    self.imageView.layer.shadowOpacity = 0.0
                }){(finished) in
                    //Animation phase 3,start mask animation
                    containView.addSubview(toView)
                    containView.bringSubview(toFront: self.imageView)
                    let adjustFrame = self.imageView.convert(self.imageView.bounds, to: self.maskContentView)
                    toView.maskFrom(adjustFrame, duration: 0.8 / 1.6 * self.config.presentDuration, complete: {
                        self.maskContentView.removeFromSuperview()
                        self.imageView.removeFromSuperview()
                        self.maskContentView = nil
                        self.imageView = nil
                        transitionContext.completeTransition(true)
                        toImageView.isHidden = false
                        fromImageView.isHidden = false
                    })
                }
            }
        }else{
            #if (arch(i386) || arch(x86_64)) && os(iOS)
                print("因为性能不好，不显示遮挡的模糊栏")
            #else
                maskContentView.image = self.blurImage
            #endif
            maskContentView.frame = containView.bounds
            containView.addSubview(self.maskContentView)
            
            let fromImageView = self.config.fromImageView
            let toImageView = self.config.toImageView!
            fromImageView.isHidden = true
            toImageView.isHidden = true
            let adjustFromRect = fromImageView.convert(fromImageView.bounds, to: containView)
            let adjustToRect = toImageView.convert(toImageView.bounds, to: containView)
            imageView = UIImageView(frame: adjustToRect)
            imageView.image = fromImageView.image
            containView.addSubview(imageView)
            
            //Animation phase 1,animate mask
            containView.bringSubview(toFront: self.imageView)
            containView.sendSubview(toBack: maskContentView)
            let adjustFrame = self.imageView.convert(self.imageView.bounds, to: self.maskContentView)
            fromView.maskTo(adjustFrame, duration: 0.8 / 1.3 * self.config.dismissDuration,complete: {
                //Set up shadow
                self.imageView.layer.shadowColor = UIColor.black.cgColor
                self.imageView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
                self.imageView.layer.shadowRadius = 10.0
                self.imageView.layer.shadowOpacity = 0.8
                UIView.animate(withDuration: 0.5 / 1.3 * self.config.dismissDuration, animations: { 
                    self.imageView.frame = adjustFromRect
                }){ (finished) in
                    //Animation phase 2, change transform to default, clear shadow
                    self.maskContentView.removeFromSuperview()
                    self.imageView.removeFromSuperview()
                    self.maskContentView = nil
                    self.imageView = nil
                    self.config.toImageView = nil
                    containView.addSubview(toView)
                    transitionContext.completeTransition(true)
                    toImageView.isHidden = false
                    fromImageView.isHidden = false
                }
            })
            print("这里是销毁页面 返回 ")
            
        }
    }
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.transitionType == .present ? self.config.presentDuration : self.config.dismissDuration
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
