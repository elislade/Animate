//
//  AnimateSubviews.swift
//  Animation
//
//  Created by Eli Slade on 2017-06-10.
//  Copyright © 2017 Eli Slade. All rights reserved.
//

import UIKit

struct Animate {
    typealias AnimationCallback = (animations:() -> Void, completion: (Bool) -> Void)
    
    static func subviews(from: UIView, to: UIView, in containerView:UIView) -> AnimationCallback? {
        var originalPairs = [(from: UIView, to: UIView)]()
        
        for view in from.subviews {
            if view.tag != 0 {
                if let toV = to.viewWithTag(view.tag) {
                    originalPairs.append((view, toV))
                }
            }
        }
        
        if originalPairs.count == 0 { return nil }
        
        var tempPairs = [(from: UIView, to: UIView)]()
        
        for pair in originalPairs {
            guard let from = extrapolate(pair.from, into: containerView) else { return nil }
            guard let to = extrapolate(pair.to, into: containerView) else { return nil }
            
            to.transform = calculateMatchTransform(from: from, to: to)
            to.alpha = 0
            
            pair.from.isHidden = true
            pair.to.isHidden = true
            
            tempPairs.append((from, to))
        }
        
        return (
            animations: {
                for pair in tempPairs {
                    pair.to.transform = CGAffineTransform.identity
                    pair.to.alpha = 1
                    
                    pair.from.transform = self.calculateMatchTransform(from: pair.to, to: pair.from)
                    pair.from.alpha = 0
                }
            },
            completion: { finished in
                containerView.removeFromSuperview()
                for pair in originalPairs {
                    pair.from.isHidden = false
                    pair.to.isHidden = false
                }
            }
        )
    }

    private static func calculateMatchTransform(from: UIView, to: UIView) -> CGAffineTransform {
        let scaleX = from.frame.width / to.frame.width
        let scaleY = from.frame.height / to.frame.height
        let scale = CGAffineTransform(scaleX: scaleX , y: scaleY)
        
        let offSetX = from.center.x - to.center.x
        let offSetY = from.center.y - to.center.y
        let translate = CGAffineTransform(translationX: offSetX, y: offSetY)
        
        return scale.concatenating(translate)
    }

    private static func extrapolate(_ view: UIView, into container: UIView) -> UIView? {
        if let snap = view.snapshotView(afterScreenUpdates: false) {
            if let parent = view.superview {
                snap.frame = parent.convert(view.frame, to: container)
                container.addSubview(snap)
                return snap
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
}
