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
    
    @IBOutlet weak var durationSlider: UISlider!
    @IBOutlet weak var velocitySlider: UISlider!
    @IBOutlet weak var dampingSlider: UISlider!
    @IBOutlet weak var durationValueLabel: UILabel!
    @IBOutlet weak var velocityValueLabel: UILabel!
    @IBOutlet weak var dampingValueLabel: UILabel!

    @IBOutlet weak var runAnimationButton: UIButton!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet var fromView: UIView!
    @IBOutlet var toView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        containerView.addSubview(fromView)
        containerView.addSubview(toView)
        containerView.cornerRadius(10)
        
        runAnimationButton.cornerRadius(10)
        updateAnimationValue(self)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        fromView.frame = containerView.bounds
        toView.frame = containerView.bounds
    }
    
    func roundF(_ value:Float, toPlace place:Float = 100) -> Float {
        return Float(round(place*value)/place)
    }
    
    @IBAction func updateAnimationValue(_ sender: Any) {
        durationValueLabel.text = "(\(roundF(durationSlider.value)))"
        velocityValueLabel.text = "(\(roundF(velocitySlider.value)))"
        dampingValueLabel.text = "(\(roundF(dampingSlider.value)))"
    }
    
    @IBAction func runAnimation(_ sender: Any) {
        if let block = Animate.subviews(from: fromView, to: toView, in: containerView) {
            UIView.animate(
                withDuration: TimeInterval(durationSlider.value),
                delay: 0,
                usingSpringWithDamping: CGFloat(dampingSlider.value),
                initialSpringVelocity: CGFloat(velocitySlider.value),
                options: .curveEaseInOut,
                animations: block.animations,
                completion: block.completion
            )
        }
    }
}
