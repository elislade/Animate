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
    @IBOutlet var viewA: UIView!
    @IBOutlet var viewB: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        containerView.addSubview(viewA)
        containerView.addSubview(viewB)
        containerView.cornerRadius(10)
        viewB.alpha = 0
        
        runAnimationButton.cornerRadius(10)
        updateAnimationValue(self)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewA.frame = containerView.bounds
        viewB.frame = containerView.bounds
    }
    
    var isEnabled:Bool = true {
        didSet {
            durationSlider.isEnabled = isEnabled
            velocitySlider.isEnabled = isEnabled
            dampingSlider.isEnabled = isEnabled
            runAnimationButton.isEnabled = isEnabled
        }
    }
    
    @IBAction func updateAnimationValue(_ sender: Any) {
        durationValueLabel.text = "(\(decimal(durationSlider.value)))"
        velocityValueLabel.text = "(\(decimal(velocitySlider.value)))"
        dampingValueLabel.text = "(\(decimal(dampingSlider.value)))"
    }
    
    @IBAction func runAnimation(_ sender: Any) {
        isEnabled = false
        
        let fromView:UIView = viewA.alpha == 0 ? viewB : viewA
        let toView:UIView = viewA.alpha == 0 ? viewA : viewB
        
        if let block = fromView.transitionBlock(to: toView) {
            UIView.animate(
                withDuration: TimeInterval(durationSlider.value),
                delay: 0,
                usingSpringWithDamping: CGFloat(dampingSlider.value),
                initialSpringVelocity: CGFloat(velocitySlider.value),
                animations: block.animations,
                completion: { fin in
                    if fin {
                        block.completion(fin)
                        self.isEnabled = true
                    }
                }
            )
        }
    }
}

func decimal(_ float:Float, toPlace place:Float = 100) -> Float {
    return round(place*float) / place
}
