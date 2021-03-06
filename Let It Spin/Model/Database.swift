//
//  Database.swift
//  Let It Spin
//
//  Created by Clara Anggraini on 01/05/21.
//

import Foundation
import UIKit

class Database{
    
    enum userDefaultsKey: String{
        case selectedSpinner = "selectedSpinner"
        case challenges = "challenges"
    }
    
    var spinners: [Spinner] = []
    var challenges: [String] = []
    let defaults = UserDefaults.standard
    static let shared = Database()
    
    init() {
        seedSpinners()
    }
    
    func seedSpinners(){
        spinners.append(Spinner(image: UIImage(named: "Christmas Tree")))
        spinners.append(Spinner(image: UIImage(named: "Snowman")))
        spinners.append(Spinner(image: UIImage(named: "Gingerman")))
        spinners.append(Spinner(image: UIImage(named: "Santa's Hat")))
        spinners.append(Spinner(image: UIImage(named: "Candy Cane")))
        spinners.append(Spinner(image: UIImage(named: "Stocking")))
    }
    
    func seedChallenges(){
        
        challenges.append("Sing All I Want For Christmas Is You by Mariah Carey")
        challenges.append("Laugh like a Santa Claus throughout the game")
        challenges.append("Say 5 good things about the person to your left")
        challenges.append("Wish 3 good things for the person to your right")
        let key: userDefaultsKey = .challenges
        defaults.set(challenges, forKey: key.rawValue)
        
    }
    
    func getSelectedSpinner() -> Int{
        let key: userDefaultsKey = .selectedSpinner
        let selectedSpinner = defaults.integer(forKey: key.rawValue)
        return selectedSpinner
    }
    
    func setSelectedSpinner(index: Int){
        let key: userDefaultsKey = .selectedSpinner
        defaults.set(index, forKey: key.rawValue)
    }
    
    func getSpinners() -> [Spinner]{
        return spinners
    }
    
    func getChallenges() -> [String]{
        let key: userDefaultsKey = .challenges
        guard let unwrappedChallenges = defaults.stringArray(forKey: key.rawValue) else { return [String]()}
        challenges = unwrappedChallenges
        return challenges
    }
    
    func insertChallenge(challenge: String){
        challenges.append(challenge)
        saveChallenges(challenges: challenges)
    }
    
    func deleteChallenges(selectedChallenges: [Int]){
        for i in (0..<selectedChallenges.count).reversed(){
            challenges.remove(at: selectedChallenges[i])
        }
        saveChallenges(challenges: challenges)
    }
    
    func saveChallenges(challenges: [String]){
        let key: userDefaultsKey = .challenges
        defaults.set(challenges, forKey: key.rawValue)
    }
}
