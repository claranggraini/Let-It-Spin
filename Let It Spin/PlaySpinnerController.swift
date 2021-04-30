//
//  ViewController.swift
//  Let It Spin
//
//  Created by Clara Anggraini on 29/04/21.
//

import UIKit

class PlaySpinnerController: UIViewController, SpinnerControllerDelegate{

    @IBOutlet weak var boardIV: UIImageView!
    @IBOutlet weak var boardLbl: UILabel!
    @IBOutlet weak var mainSpinnerIV: UIImageView!
    @IBOutlet weak var spinBtn: UIButton!
    
    var startTime: CFTimeInterval?, endTime: CFTimeInterval?
    
    @IBAction func spinBtnOnClicked(_ sender: Any) {
        spinBtn.alpha = 0.5
        spinBtn.isEnabled = false
        let displayLink = CADisplayLink(target: self, selector: #selector(stopSpin))
        displayLink.add(to: .main, forMode: .common)
        startTime = CACurrentMediaTime()
        endTime = startTime! + 4
        self.mainSpinnerIV.startRotating()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let saveMenu = UIMenu(title: "", children: [
            UIAction(title: "Change Spinner", image: UIImage(systemName: "arrow.triangle.2.circlepath")) { action in
                
                self.performSegue(withIdentifier: "SpinnerSegue", sender: self)
                
                },
            UIAction(title: "Sound") { action in
                    //Rename Menu Child Selected
                },
        ])
        
        
        let item = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), menu: saveMenu)
        item.tintColor = UIColor(named: "Cream")
        self.navigationItem.rightBarButtonItem = item
        
        
        mainSpinnerIV.image = UIImage(named: "Christmas Tree")
        spinBtn.layer.cornerRadius = 40
        
    }
    
    @objc func stopSpin(displaylink: CADisplayLink){

        guard let endTime = endTime
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
    
    func didChangeSpinner(spinner: Spinner) {
        mainSpinnerIV.image = spinner.image
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! SpinnerController
        vc.delegate = self
    }
    
}

extension UIImageView{
    
    func startRotating() {
        let rotation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = Double.random(in: 0.3..<0.4)
        rotation.isCumulative = true
        rotation.fillMode = .forwards
        rotation.repeatCount = Float.greatestFiniteMagnitude
        self.layer.add(rotation, forKey: "rotationAnimation")
    }
    
    func stopRotating() {
        let transform = self.layer.presentation()!.transform
        self.layer.removeAllAnimations()
        self.layer.transform = transform
    }
}

