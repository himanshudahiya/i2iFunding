
import UIKit

class EnterOTP: UIViewController {
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet weak var terms1: UIButton!
    @IBOutlet weak var terms2: UIButton!
    
    var checkbox = UIImage(named: "bullet-icon")
    var uncheckbox = UIImage(named: "unchecked")
    
    var isTerms1Clicked:Bool!
    var isTerms2Clicked:Bool!
    override func viewDidLoad() {
        super.viewDidLoad()
        isTerms1Clicked = false
        isTerms2Clicked = false
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
    
    // checkbox button click actions
    @IBAction func onCheckTerms1(_ sender: Any) {
        if isTerms1Clicked == true{
            isTerms1Clicked = false
        }
        else{
            isTerms1Clicked = true
        }
        
        if isTerms1Clicked == true{
           
            terms1.setImage(checkbox, for: UIControlState.normal)
        }
        else {
            terms1.setImage(uncheckbox, for: UIControlState.normal)
        }
    }
   
    @IBAction func onCheckTerms2(_ sender: Any) {
        if isTerms2Clicked == true{
            isTerms2Clicked = false
        }
        else{
            isTerms2Clicked = true
        }
        
        if isTerms2Clicked == true{
            
            terms2.setImage(checkbox, for: UIControlState.normal)
        }
        else {
            terms2.setImage(uncheckbox, for: UIControlState.normal)
        }
    }
    
    
}



