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
    
    
    struct LoginResponse: Decodable {
        let csrf_token: String
        let session_id: String
        let message: String
        init(json: [String: Any]){
            csrf_token = json["csrf_token"] as? String ?? ""
            session_id = json["session_id"] as? String ?? ""
            message = json["message"] as? String ?? ""
        }
    }
    struct LoginResponse2: Decodable {
        let csrf_token: String
        let session_id: String
        let php_csrf_token: String
        let php_session_id: String
        init(json: [String: Any]){
            csrf_token = json["csrf_token"] as? String ?? ""
            session_id = json["session_id"] as? String ?? ""
            php_csrf_token = json["php_csrf_token"] as? String ?? ""
            php_session_id = json["php_session_id"] as? String ?? ""
        }
    }
    var session_id: String = ""
    var csrf_token: String = ""
    var message: String? = ""
    
    //login segue function
    @IBAction func login(_ sender: Any) {
        let params = [
            "usr_email": "himanshudahiya06@gmail.com", //email.text!,
            "usr_password": "Redowid@4" //password.text!,
            ]
        let postURL = "http://localhost:8080/api/v1/login"
        guard let url = URL(string: postURL) else{
            print("bad url")
            return}
        print("url = ", url)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue( "application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: params, options: []) else{
            print("bad http body")
            return}
        request.httpBody = httpBody
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            if let data = data{
                do{
                    print("trying json")
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    print(json ?? "")
                    
                    //let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.csrf_token = json!["csrf_token"] as! String
                        self.session_id = json!["session_id"] as! String
                        self.message = json!["message"] as? String
                        let preferences = UserDefaults.standard
                        preferences.set(self.session_id, forKey: "session_id")
                        preferences.set(self.csrf_token, forKey: "csrf_token")
                        preferences.synchronize()
                        if self.message == "Your account is not active"{
                            self.performSegue(withIdentifier: "notActiveAccount", sender: self)
                        }
                        else {
                            self.performSegue(withIdentifier: "login_correct", sender: self)
                        }
                    }
                    
                } catch{
                    print(error)
                }
            }
            }.resume()
        
        
    }
    // email validation
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

