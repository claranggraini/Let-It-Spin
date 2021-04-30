//
//  ViewController.swift
//  Let It Spin
//
//  Created by Clara Anggraini on 29/04/21.
//

import UIKit

class PlaySpinnerController: UIViewController {

    @IBOutlet weak var boardIV: UIImageView!
    @IBOutlet weak var boardLbl: UILabel!
    @IBOutlet weak var mainSpinnerIV: UIImageView!
    @IBOutlet weak var spinBtn: UIButton!
    
    var startTime: CFTimeInterval?, endTime: CFTimeInterval?
    
    @IBAction func spinBtnOnClicked(_ sender: Any) {
        spinBtn.alpha = 0.5
        spinBtn.isEnabled = false
        var displayLink = CADisplayLink(target: self, selector: #selector(stopSpin))
        displayLink.add(to: .main, forMode: .common)
        startTime = CACurrentMediaTime()
        endTime = startTime! + 4
        self.mainSpinnerIV.rotate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainSpinnerIV.image = UIImage(named: "Christmas Tree")
    }

    @objc func stopSpin(displaylink: CADisplayLink){

        guard
            let endTime = endTime,
            let startTime = startTime
           else {
             return
         }

        if CACurrentMediaTime() > endTime{
            mainSpinnerIV.stopRotating()
            displaylink.isPaused = true
            displaylink.invalidate()
            spinBtn.alpha = 1
            spinBtn.isEnabled = true
        }
    }
}

extension UIImageView{
    
    func rotate() {
        let rotation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = Double.random(in: 0.3..<0.4)
        rotation.isCumulative = true
        rotation.fillMode = .forwards
        rotation.isRemovedOnCompletion = false
        rotation.repeatCount = Float.greatestFiniteMagnitude
        self.layer.add(rotation, forKey: "rotationAnimation")
    }
    
    func stopRotating() {
        let transform = self.layer.presentation()!.transform
        self.layer.removeAllAnimations()
        self.layer.transform = transform
    }
}
