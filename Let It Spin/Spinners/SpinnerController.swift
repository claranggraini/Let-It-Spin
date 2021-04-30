//
//  SpinnerController.swift
//  Let It Spin
//
//  Created by Clara Anggraini on 29/04/21.
//

import UIKit

protocol SpinnerControllerDelegate: class {
    func didChangeSpinner(spinner: Spinner)
}

class SpinnerController: UIViewController {

    @IBOutlet weak var spinnerCV: UICollectionView!
    var prevSpinner: SpinnerCell?
    var index = 0
    weak var delegate: SpinnerControllerDelegate?
    let spinnerCellId = "SpinnerCell"
    let spinners = Spinner.getData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nibCell = UINib(nibName: spinnerCellId, bundle: nil)
        spinnerCV.register(nibCell, forCellWithReuseIdentifier: spinnerCellId)
        spinnerCV.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5){ [self] in
            prevSpinner = spinnerCV.cellForItem(at: IndexPath.init(row: 0, section: 0)) as! SpinnerCell
            spinnerCV.reloadData()
        }
                                           
        
    }
    
}

extension SpinnerController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        Spinner.getData().count
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = spinnerCV.dequeueReusableCell(withReuseIdentifier: spinnerCellId, for: indexPath) as! SpinnerCell
        
        if indexPath.row == index{
            cell.layer.borderColor = UIColor(named: "Red")?.cgColor
            cell.layer.borderWidth = 10
        }else{
            cell.layer.borderWidth = 0
        }
        cell.layer.cornerRadius = 16
        cell.spinnerIV?.image = spinners[indexPath.row].image
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 160, height: 188)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didChangeSpinner(spinner: spinners[indexPath.row])
        index = indexPath.row
        spinnerCV.reloadData()
    }
}

