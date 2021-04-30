//
//  Spinner.swift
//  Let It Spin
//
//  Created by Clara Anggraini on 29/04/21.
//

import Foundation
import UIKit

struct Spinner {
    var image: UIImage?

    static func getData()->[Spinner]{
        var spinners: [Spinner]=[]
        
        spinners.append(Spinner(image: UIImage(named: "Christmas Tree")))
        spinners.append(Spinner(image: UIImage(named: "Snowman")))
        spinners.append(Spinner(image: UIImage(named: "Gingerman")))
        spinners.append(Spinner(image: UIImage(named: "Santa's Hat")))
        spinners.append(Spinner(image: UIImage(named: "Candy Cane")))
        spinners.append(Spinner(image: UIImage(named: "Stocking")))
        
        return spinners
    }
}


