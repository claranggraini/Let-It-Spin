//
//  ChallengesController.swift
//  Let It Spin
//
//  Created by Clara Anggraini on 01/05/21.
//

import UIKit

class ChallengesController: UIViewController {

    var challenges = Database.shared.getChallenges()
//    let size = challenges.count-1
    var longPressGesture:UILongPressGestureRecognizer? = nil
    var selectedChallenges:[Int] = []
    let challengeCellId = "ChallengeCell"
    @IBOutlet weak var challengesTV: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        navigationItem.title = "Challenges"
        setupLongPressGesture()
        challengesTV.backgroundColor = UIColor(named: "Green")
        challengesTV.separatorColor = UIColor.clear
        challengesTV.allowsMultipleSelection = false
        challengesTV.allowsSelection = false
        challengesTV.allowsSelectionDuringEditing = false
        
        let nibCell = UINib(nibName: challengeCellId, bundle: nil)
        challengesTV.register(nibCell, forCellReuseIdentifier: challengeCellId)
        challengesTV.reloadData()
        let item = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(setupView))
        navigationItem.rightBarButtonItem = item
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            
            return
        }
        
        self.challengesTV.contentInset.bottom = keyboardSize.height + 25
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.challengesTV.contentInset.bottom = 0
        self.view.endEditing(true)
    }
    
    @objc func setupView(){
        challenges.append("")
        challengesTV.reloadData()
         
        guard let unwrappedGesture = longPressGesture else{ return}
        unwrappedGesture.isEnabled = false
        
        navigationItem.rightBarButtonItem = nil
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector( doneEditing))
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc func doneEditing(){
       
        let cell = challengesTV.cellForRow(at: IndexPath(row: 0, section: challenges.count-1)) as! ChallengeCell
        
        if cell.challengeTxtView.text == ""{
            challenges.remove(at: challenges.count-1)
            
        }else{
            Database.shared.insertChallenge(challenge: cell.challengeTxtView.text)
            challenges = Database.shared.getChallenges()
        }
        
        
        cell.challengeTxtView.isEditable = false
        guard let unwrappedGesture = longPressGesture else{ return}
        unwrappedGesture.isEnabled = true
        challengesTV.reloadData()
        let item = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(setupView))
        navigationItem.rightBarButtonItem = item
    }
    
}
extension ChallengesController: UITableViewDelegate, UITableViewDataSource ,UITextViewDelegate, UIGestureRecognizerDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return challenges.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = challengesTV.dequeueReusableCell(withIdentifier: challengeCellId, for: indexPath) as! ChallengeCell
        
        cell.challengeTxtView.text = challenges[indexPath.section]
        if cell.challengeTxtView.text.count > 67{
            
            cell.challengeTxtView.centerYAnchor.constraint(equalTo: cell.challengeTxtView.centerYAnchor).isActive = false
            cell.challengeTxtView.frame = CGRect(x: 0, y: 0, width: 264, height: 134)
            cell.challengeTxtView.resizeFont()
        }
        
        if cell.challengeTxtView.text == ""{
            cell.challengeTxtView.tintColor = UIColor.black
            cell.challengeTxtView.isEditable = true
            cell.challengeTxtView.becomeFirstResponder()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = view.backgroundColor
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! ChallengeCell
        
        if cell.challengeCellView.layer.borderWidth.isEqual(to: 10.0){
            
            cell.challengeCellView.layer.borderWidth = 0
            deleteSelectedChallenge(index: indexPath.section)
            
            if selectedChallenges.isEmpty{
                navigationItem.rightBarButtonItem = nil
                navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(setupView))
                challengesTV.allowsSelection = false
            }
        }else{
            selectedChallenges.append(indexPath.section)
            print("selected challenges: \(indexPath.section)")
            cell.challengeCellView.layer.borderWidth = 10.0
        }
    }
    
    func deleteSelectedChallenge(index: Int){
        for i in 0..<selectedChallenges.count{
            if selectedChallenges[i] == index{
                selectedChallenges.remove(at: i)
                
                return
            }
        }
    }
    
    func setupLongPressGesture() {
        
       longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress))
        guard let unwrappedGesture = longPressGesture else{ return}
        unwrappedGesture.minimumPressDuration = 1.0
        unwrappedGesture.delegate = self
        self.challengesTV.addGestureRecognizer(unwrappedGesture)
    }

    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer){
        if gestureRecognizer.state == .began {
            
            let barItem = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(deleteChallenges))
            navigationItem.rightBarButtonItem = nil
            navigationItem.rightBarButtonItem = barItem

            challengesTV.isUserInteractionEnabled = true
            challengesTV.allowsMultipleSelection = true
            
            
            let touchPoint = gestureRecognizer.location(in: self.challengesTV)
            if let indexPath = challengesTV.indexPathForRow(at: touchPoint) {
                selectCellFromPoint(point: touchPoint)
            }
        }
    }
    
    func selectCellFromPoint(point:CGPoint) {
        if let indexPath = challengesTV.indexPathForRow(at: point) {
            
            let cell = challengesTV.cellForRow(at: indexPath) as! ChallengeCell
            selectedChallenges.append(indexPath.section)
            cell.challengeCellView.layer.borderWidth = 10
            cell.challengeCellView.layer.borderColor = UIColor(named: "Red")?.cgColor
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
//        textView.resizeFont()
    }
    
    @objc func deleteChallenges(){
        selectedChallenges.sort()
        
        for i in (0..<selectedChallenges.count).reversed(){
            challenges.remove(at: selectedChallenges[i])
        }
        selectedChallenges.removeAll()
        
        challengesTV.reloadData()
        navigationItem.rightBarButtonItem = nil
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(setupView))
        challengesTV.allowsSelection = false
        clearSelection()
    }
    func clearSelection(){
        let listCell = challengesTV.visibleCells as! [ChallengeCell]
        for cell in listCell{
            cell.challengeCellView.layer.borderWidth = 0
        }
    }

}


extension UITextView {

    func resizeFont() {
        if (self.text.isEmpty || self.bounds.size.equalTo(CGSize.zero)) {
            return;
        }
                
        let textViewSize = self.frame.size
        let fixedWidth = textViewSize.width
        let expectSize = self.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat(MAXFLOAT)))
        
        var expectFont = self.font
        if (expectSize.height > textViewSize.height) {
                
            while (self.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat(MAXFLOAT))).height > textViewSize.height) {
                expectFont = self.font!.withSize(self.font!.pointSize - 1)
                self.font = expectFont
            }
        }
    }
    
}
