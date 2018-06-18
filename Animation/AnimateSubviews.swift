//
//  AnimateSubviews.swift
//  Animation
//
//  Created by Eli Slade on 2017-06-10.
//  Copyright © 2017 Eli Slade. All rights reserved.
//

import UIKit

typealias AnimationCallback = (animations:() -> Void, completion: (Bool) -> Void)

extension UIView {
    func snap(into view:UIView) -> UIView?  {
        if let snap = self.snapshotView(afterScreenUpdates: true) {
            if let parent = view.superview {
                snap.frame = parent.convert(self.frame, to: view)
                view.addSubview(snap)
                return snap
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    func matchTransform(to toView: UIView) {
        let scaleX = self.frame.width / toView.frame.width
        let scaleY = self.frame.height / toView.frame.height
        let scale = CGAffineTransform(scaleX: scaleX , y: scaleY)
        
        let offSetX = toView.center.x - self.center.x
        let offSetY = toView.center.y - self.center.y
        let translate = CGAffineTransform(translationX: offSetX, y: offSetY)
        
        self.transform = scale.concatenating(translate)
    }
    
    func transitionBlock(to toView:UIView, withTags tags:[Int] = [1,2,3]) -> AnimationCallback? {
        
        var transitionViews = [(from:UIView, to:UIView)]()
        
        guard let parentView = self.superview else { return nil }
        let container = UIView(frame: parentView.bounds)
        parentView.addSubview(container)
        
        for tag in tags {
            if let from = self.viewWithTag(tag)?.snap(into: container), let to = toView.viewWithTag(tag)?.snap(into: container) {
                to.matchTransform(to: from)
                to.alpha = 0
                transitionViews.append((from, to))
            }
        }
        
        if transitionViews.count == 0 { return nil }
        
        self.alpha = 0
        toView.alpha = 0
        
        return (
            animations: {
                for pair in transitionViews {
                    pair.to.transform = .identity
                    pair.to.alpha = 1
                    pair.from.matchTransform(to: pair.to)
                    pair.from.alpha = 0
                }
            },
            completion: { finished in
                self.alpha = 0
                toView.alpha = 1
                
                container.removeFromSuperview()
            }
        )
    }
}
