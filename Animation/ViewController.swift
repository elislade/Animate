//
//  ViewController.swift
//  Animation
//
//  Created by Eli Slade on 2017-06-09.
//  Copyright © 2017 Eli Slade. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var viewA: UIView!
    @IBOutlet weak var viewB: UIView!
    
    @IBAction func TappedButton(_ sender: Any) {
        
        let containerView = UIView(frame: view.frame)
        view.addSubview(containerView)
        
        if let animObjs = Animate.subviews(from: viewA, to: viewB, in: containerView) {
            UIView.animate(
                withDuration: 1,
                delay: 0,
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 0.2,
                options: .curveEaseInOut,
                animations: animObjs.animations,
                completion: animObjs.completion
            )
        }
    }
}

