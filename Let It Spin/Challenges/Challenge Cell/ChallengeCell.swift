//
//  ChallengeCell.swift
//  Let It Spin
//
//  Created by Clara Anggraini on 01/05/21.
//

import UIKit

class ChallengeCell: UITableViewCell {

    @IBOutlet weak var challengeCellView: UIView!
    
    @IBOutlet weak var challengeTxtView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        challengeCellView.layer.cornerRadius = 15
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.clear
        
        selectedBackgroundView = backgroundView
        challengeTxtView.isUserInteractionEnabled = false
        challengeCellView.layer.borderColor = UIColor(named: "Red")?.cgColor
    }
    
}
