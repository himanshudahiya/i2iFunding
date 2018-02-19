
import UIKit

class UserDetails: UIViewController {
    
    
    @IBOutlet var numDepend: [UIButton]!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var dependent1_age: TextField!
    @IBOutlet weak var dependent2_age: TextField!
    @IBOutlet weak var dependent3_age: TextField!
    @IBOutlet weak var dependentSelectionButton: UIButton!
    
    @IBOutlet weak var CurrAddStack: UIStackView!
    @IBOutlet var currAddFields: [UITextField]!
    
    
    
    @IBOutlet weak var currEqPermButton: UIButton!
    var checkbox = UIImage(named: "bullet-icon")
    var uncheckbox = UIImage(named: "unchecked")
    
    var isCurrEqPermClicked:Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         isCurrEqPermClicked = false
        // Do any additional setup after loading the view, typically from a nib.
        // 1. create a gesture recognizer (tap gesture)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(gesture:)))
        
        // 2. add the gesture recognizer to a view
        scrollView.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addObserver()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObserver()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // 3. this method is called when a tap is recognized
    @objc func handleTap(gesture: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func addObserver() {
        NotificationCenter.default.addObserver(forName: .UIKeyboardWillShow, object: nil, queue: nil){
            notification in
            self.keyboardWillShow(notification: notification)
        }
        NotificationCenter.default.addObserver(forName: .UIKeyboardWillHide, object: nil, queue: nil){
            notification in
            self.keyboardWillHide(notification: notification)
        }
    }
    
    func keyboardWillShow(notification: Notification){
        guard let userInfo = notification.userInfo,
            let frame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else{
                return
        }
        let contentInset = UIEdgeInsets(top: 0, left:0, bottom: frame.height, right: 0)
        scrollView.contentInset = contentInset
    }
    
    func keyboardWillHide(notification: Notification){
        scrollView.contentInset = UIEdgeInsets.zero
    }
    
    func removeObserver() {
        NotificationCenter.default.removeObserver(self)
    }
    
    // function to make drop down visible or hidden
    @IBAction func handleSelection(_ sender: UIButton) {
        numDepend.forEach { (button) in
            UIView.animate(withDuration: 0.3, animations: {
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            })
        }
    }
    
    enum nums: String{
        case zero = "0"
        case one = "1"
        case two = "2"
        case three = "3"
    }
    
    // function called when any button on dropdown is clicked
    @IBAction func numTapped(_ sender: UIButton) {
        guard let title = sender.currentTitle, let num = nums(rawValue: title) else {
            return
        }
        switch num {
        case .zero:
            print("0")
            dependent1_age.isHidden = true
            dependent2_age.isHidden = true
            dependent3_age.isHidden = true
        case .one:
            print("1")
            dependent1_age.isHidden = false
            dependent2_age.isHidden = true
            dependent3_age.isHidden = true
        case .two:
            print("2")
            dependent1_age.isHidden = false
            dependent2_age.isHidden = false
            dependent3_age.isHidden = true
        case .three:
            print("3")
            dependent1_age.isHidden = false
            dependent2_age.isHidden = false
            dependent3_age.isHidden = false
        }
        handleSelection(dependentSelectionButton)
    }
    
    
    
   
    @IBAction func onCheckCurrEqPerm(_ sender: Any) {
        
        if isCurrEqPermClicked == true{
            isCurrEqPermClicked = false
            print("show")
            self.currAddFields.forEach { (textField) in
                UIView.animate(withDuration: 0.3, animations: {
                    textField.isHidden = false
                    self.view.layoutIfNeeded()
                })
            }
        }
        else{
            isCurrEqPermClicked = true
            print("hide")
            self.currAddFields.forEach { (textField) in
                UIView.animate(withDuration: 0.3, animations: {
                    textField.isHidden = true
                    self.view.layoutIfNeeded()
                })
            }
        }
        
        if isCurrEqPermClicked == true{
            
            currEqPermButton.setImage(checkbox, for: UIControlState.normal)
        }
        else {
            currEqPermButton.setImage(uncheckbox, for: UIControlState.normal)
        }
    }
    
    
}



