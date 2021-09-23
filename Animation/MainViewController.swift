//
//  MainViewController.swift
//  Animation
//
//  Created by Eli Slade on 2018-06-16.
//  Copyright © 2018 Eli Slade. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override var prefersStatusBarHidden: Bool { return true }
    
    @IBOutlet weak var durationLabel: UILabel!
    
    @IBOutlet weak var massSlider: UISlider!
    @IBOutlet weak var stiffnessSlider: UISlider!
    @IBOutlet weak var dampingSlider: UISlider!
    
    @IBOutlet weak var massValueLabel: UILabel!
    @IBOutlet weak var stiffnessValueLabel: UILabel!
    @IBOutlet weak var dampingValueLabel: UILabel!

    @IBOutlet weak var runAnimationButton: UIButton!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet var viewA: UIView!
    @IBOutlet var viewB: UIView!
    
    
    var spring: UISpringTimingParameters {
        UISpringTimingParameters(
            mass: CGFloat(massSlider.value),
            stiffness: CGFloat(stiffnessSlider.value),
            damping: CGFloat(dampingSlider.value),
            initialVelocity: .zero
        )
    }
    
    var animator: UIViewPropertyAnimator {
        UIViewPropertyAnimator(duration: 0, timingParameters: spring)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        containerView.addSubview(viewA)
        containerView.addSubview(viewB)
        viewB.alpha = 0
        
        updateAnimationValue(self)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewA.frame = containerView.bounds
        viewB.frame = containerView.bounds
    }
    
    var isEnabled: Bool = true {
        didSet {
            massSlider.isEnabled = isEnabled
            stiffnessSlider.isEnabled = isEnabled
            dampingSlider.isEnabled = isEnabled
            runAnimationButton.isEnabled = isEnabled
        }
    }
    
    @IBAction func updateAnimationValue(_ sender: Any) {
        massValueLabel.text = "(\(decimal(massSlider.value)))"
        stiffnessValueLabel.text = "(\(decimal(stiffnessSlider.value)))"
        dampingValueLabel.text = "(\(decimal(dampingSlider.value)))"
        durationLabel.text = "Duration \(decimal(animator.duration))s"
    }
    
    @IBAction func runAnimation(_ sender: Any) {
        isEnabled = false
        
        let fromView: UIView = viewA.alpha == 0 ? viewB : viewA
        let toView: UIView = viewA.alpha == 0 ? viewA : viewB
        
        if let block = fromView.transitionBlock(to: toView) {
            animator.addCompletion({ pos in
                block.completion(true)
                self.isEnabled = true
            })
            
            animator.addAnimations(block.animations)
            animator.startAnimation()
        }
    }
}

func decimal<F: BinaryFloatingPoint>(_ float: F, toPlace place: F = 100) -> F {
    return round(place * float) / place
}
