//
//  AnimateSubviews.swift
//  Animation
//
//  Created by Eli Slade on 2017-06-10.
//  Copyright © 2017 Eli Slade. All rights reserved.
//

import UIKit

struct Animate {
    static func subviews(from: UIView, to: UIView, in containerView:UIView) -> (animate:() -> Void, finish: (Bool) -> Void)? {
        var pairs = [(from: UIView, to: UIView)]()
        
        for view in from.subviews {
            if view.tag != 0 {
                if let toV = to.viewWithTag(view.tag) {
                    pairs.append((view, toV))
                }
            }
        }
        
        if pairs.count == 0 { return nil }
        
        var tempViews = [(from: UIView, to: UIView)]()
        
        for pair in pairs {
            guard let from = extrapolate(pair.from, into: containerView) else { return nil }
            guard let to = extrapolate(pair.to, into: containerView) else { return nil }
            
            to.transform = calculateMatchTransform(from: from, to: to)
            to.alpha = 0
            
            pair.from.isHidden = true
            pair.to.isHidden = true
            
            tempViews.append((from, to))
        }
        
        return (
            animate: {
                for view in tempViews {
                    view.to.transform = CGAffineTransform.identity
                    view.to.alpha = 1
                    
                    view.from.transform = self.calculateMatchTransform(from: view.to, to: view.from)
                    view.from.alpha = 0
                }
            },
            finish: { finished in
                containerView.removeFromSuperview()
                for pair in pairs {
                    pair.from.isHidden = false
                    pair.to.isHidden = false
                }
            }
        )
    }

    private static func calculateMatchTransform(from: UIView, to: UIView) -> CGAffineTransform {
        let scaleX = from.frame.width / to.frame.width
        let scaleY = from.frame.height / to.frame.height
        let scale = CGAffineTransform(scaleX:scaleX , y: scaleY)
        
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
