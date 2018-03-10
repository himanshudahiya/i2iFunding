
import UIKit

class EmploymentDetails: UIViewController {
    

    @IBOutlet var employmentType: [UIButton]!
    @IBOutlet weak var employmentTypeButton: UIButton!
    
    
    //business selected options
    @IBOutlet weak var businessName: TextField!
    @IBOutlet weak var businessEstYear: TextField!
    @IBOutlet weak var businessWebsite: TextField!
    @IBOutlet weak var tanNumber: TextField!
    @IBOutlet weak var panNumber: TextField!
    @IBOutlet weak var businessEmailID: TextField!
    
    //self Employed selected options
    @IBOutlet weak var emailID: TextField!
    @IBOutlet weak var website: TextField!
    @IBOutlet weak var totalProfessionalExp: TextField!
    
    
    @IBOutlet var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        // 1. create a gesture recognizer (tap gesture)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(gesture:)))
        
        // 2. add the gesture recognizer to a view
        scrollView.addGestureRecognizer(tapGesture)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        addObserver()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
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
    
    @IBAction func unwindFromEducationForm( _sender: UIStoryboardSegue){
        
    }
    
    
    
    // function to make drop down visible or hidden
    @IBAction func handleSelection(_ sender: UIButton) {
        employmentType.forEach { (button) in
            UIView.animate(withDuration: 0.3, animations: {
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            })
        }
    }
    
    enum nums: String{
        case zero = "Business"
        case one = "Company"
        case two = "Self Employed"
        
    }
    
    // function called when any button on dropdown is clicked
    @IBAction func numTapped(_ sender: UIButton) {
        guard let title = sender.currentTitle, let num = nums(rawValue: title) else {
            return
        }
        switch num {
        case .zero:
            print("0")
            businessName.isHidden = false
            businessEmailID.isHidden = false
            businessEstYear.isHidden = false
            businessWebsite.isHidden = false
            tanNumber.isHidden = false
            panNumber.isHidden = false
            website.isHidden = true
            totalProfessionalExp.isHidden = true
            emailID.isHidden = true
            
        case .one:
            print("1")
            businessName.isHidden = true
            businessEmailID.isHidden = true
            businessEstYear.isHidden = true
            businessWebsite.isHidden = true
            tanNumber.isHidden = true
            panNumber.isHidden = true
            website.isHidden = true
            totalProfessionalExp.isHidden = true
            emailID.isHidden = true
            
        case .two:
            print("2")
            businessName.isHidden = true
            businessEmailID.isHidden = true
            businessEstYear.isHidden = true
            businessWebsite.isHidden = true
            tanNumber.isHidden = true
            panNumber.isHidden = true
            website.isHidden = false
            totalProfessionalExp.isHidden = false
            emailID.isHidden = false
        }
        handleSelection(employmentTypeButton)
    }
    
    
    
}


