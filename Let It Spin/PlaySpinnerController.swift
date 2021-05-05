//
//  ViewController.swift
//  Let It Spin
//
//  Created by Clara Anggraini on 29/04/21.
//

import UIKit
import AVFoundation

class PlaySpinnerController: UIViewController, SpinnerControllerDelegate{

    @IBOutlet weak var boardIV: UIImageView!
    @IBOutlet weak var boardLbl: UILabel!
    @IBOutlet weak var mainSpinnerIV: UIImageView!
    @IBOutlet weak var spinBtn: UIButton!
    
    var startTime: CFTimeInterval?, endTime: CFTimeInterval?
    var challenges = Database.shared.getChallenges()
    var spinners = Database.shared.getSpinners()
    let savedSpinner = Database.shared.getSelectedSpinner()
    var saveMenu = UIMenu()
    
    
    @IBAction func spinBtnOnClicked(_ sender: Any) {
        boardLbl.text = ""
        let displayLink = CADisplayLink(target: self, selector: #selector(stopSpin))
        displayLink.add(to: .main, forMode: .common)
        displayLink.preferredFramesPerSecond = 5
        spinBtn.alpha = 0.5
        spinBtn.isEnabled = false
        
        startTime = CACurrentMediaTime()
        endTime = startTime! + Double.random(in: 4.0..<5.0)
        self.mainSpinnerIV.startRotating()
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMenuWithMute()
        if challenges.isEmpty{
            Database.shared.seedChallenges()
            challenges = Database.shared.getChallenges()
        }
        
        setUpSettings()
        
        boardLbl.adjustsFontSizeToFitWidth = true
        boardLbl.minimumScaleFactor = 0.2
        
        mainSpinnerIV.image = spinners[savedSpinner].image
        spinBtn.layer.cornerRadius = 40
        MusicPlayer.shared.startBackgroundMusic()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        challenges = Database.shared.getChallenges()
    }
    
    func setUpSettings() {
        let item = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), menu: saveMenu)
        item.tintColor = UIColor(named: "Cream")
        self.navigationItem.rightBarButtonItem = nil
        self.navigationItem.rightBarButtonItem = item
    }
    
    func setupMenuWithSound() {
        saveMenu = UIMenu(title: "", children: [
            UIAction(title: "Challenges", image: UIImage(systemName: "scroll")){ action in
               
                self.performSegue(withIdentifier: "ChallengeSegue", sender: self)
                
            },
            UIAction(title: "Change Spinner", image: UIImage(systemName: "arrow.triangle.2.circlepath")) { action in
                
                self.performSegue(withIdentifier: "SpinnerSegue", sender: self)
                
            },
            UIAction(title: "Sound On", image: UIImage(systemName: "speaker.wave.2")){ action in
                
                MusicPlayer.shared.startBackgroundMusic()
                self.setupMenuWithMute()
            },
        ])
        setUpSettings()
    }
    
    func setupMenuWithMute(){
        saveMenu = UIMenu(title: "", children: [
            UIAction(title: "Challenges", image: UIImage(systemName: "scroll")){ action in
               
                self.performSegue(withIdentifier: "ChallengeSegue", sender: self)
                
            },
            UIAction(title: "Change Spinner", image: UIImage(systemName: "arrow.triangle.2.circlepath")) { action in
                
                self.performSegue(withIdentifier: "SpinnerSegue", sender: self)
                
            },
            UIAction(title: "Sound Off", image: UIImage(systemName: "speaker.slash")){ action in
                
                MusicPlayer.shared.stopBackgroundMusic()
                self.setupMenuWithSound()
            },
        ])
        setUpSettings()
    }
    
    @objc func stopSpin(displaylink: CADisplayLink){

        guard let endTime = endTime
        else {
             return
         }

        if CACurrentMediaTime() > endTime{
            
            if (challenges.isEmpty && !Database.shared.getChallenges().isEmpty){
                challenges = Database.shared.getChallenges()
            }
            
            let random = randomChallenge()
            boardLbl.text = challenges[random]
            challenges.remove(at: random)

            displaylink.isPaused = true
            displaylink.invalidate()
            displaylink.remove(from: .main, forMode: .common)
            spinBtn.alpha = 1
            spinBtn.isEnabled = true
        }
    }
    
    func didChangeSpinner(spinner: Spinner) {
        mainSpinnerIV.image = spinner.image
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "SpinnerSegue"){
            let vc = segue.destination as! SpinnerController
            vc.delegate = self
        }
        
    }
    
    func randomChallenge() -> Int{
        if challenges.isEmpty {
            return Int()
        }
        return Int.random(in: 0..<challenges.count)
    }
    
}

extension UIImageView{
    
    func startRotating() {
        let rotation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration =  Double.random(in: 0.3..<0.4)
        rotation.isCumulative = true
        rotation.fillMode = .forwards
        rotation.isRemovedOnCompletion = false
        rotation.repeatCount = Float.random(in: 12.5..<13.7)
        self.layer.add(rotation, forKey: "rotationAnimation")
        
    }
    
    
}

