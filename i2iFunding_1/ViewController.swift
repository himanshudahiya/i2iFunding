//
//  ViewController.swift
//  i2iFunding_1
//
//  Created by himanshu dahiya on 24/01/18.
//  Copyright © 2018 himanshu dahiya. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var uiView: UIView!
    @IBOutlet var email: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var backgroundImage: UIImageView!
    
    //login segue function
    @IBAction func login(_ sender: Any) {
        if(emailCorrect==true){
            performSegue(withIdentifier: "login_correct", sender: self)
        }
    }
    // email validation
    var emailCorrect = false
    @IBAction func emailEditing(_ sender: Any) {
        let rightImageView = UIImageView(frame: CGRect(x: -10,  y:0, width: 20, height: 20))
        var image: UIImage
        if isValidEmail(testStr: email.text!) == true {
            image = UIImage(named: "bullet-icon")!
            emailCorrect = true
        }
        else {
            image = UIImage(named: "error")!
            emailCorrect = false
        }
        
        rightImageView.image = image
        let view = UIView(frame: CGRect(x:0,  y:0, width: 20, height: 20 ))
        view.addSubview(rightImageView)
        email.rightView = view
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view, typically from a nib.
        // 1. create a gesture recognizer (tap gesture)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(gesture:)))
        
        // 2. add the gesture recognizer to a view
        scrollView.addGestureRecognizer(tapGesture)
        
        
        
    }

    // to show and hide navigation controller
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
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
  
}

