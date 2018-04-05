
import UIKit

class EnterOTP: UIViewController {
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet weak var terms1: UIButton!
    @IBOutlet weak var terms2: UIButton!
    
    
    struct OTPResponse: Decodable {
        let valid: Bool
        init(json: [String: Any]){
            valid = json["valid"] as? Bool ?? false
        }
    }
    
    struct OTPSubmitResponse: Decodable {
        let session_id: String
        let csrf_token: String
        init(json: [String: Any]){
            session_id = json["session_id"] as? String ?? ""
            csrf_token = json["csrf_token"] as? String ?? ""
        }
    }
    
    var checkbox = UIImage(named: "bullet-icon")
    var uncheckbox = UIImage(named: "unchecked")
    
    var isTerms1Clicked:Bool!
    var isTerms2Clicked:Bool!
    
    var email: String!
    var mobile: String!
    var token: String!
    var firstName: String!
    var middleName: String!
    var lastName: String!
    var gender: String!
    var aadhar: String!
    var panNumber: String!
    var password: String!
    var password2: String!
    var mobileCode: String!
    
    var sessionID: String!
    var csrfToken: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isTerms1Clicked = false
        isTerms2Clicked = false
        // Do any additional setup after loading the view, typically from a nib.
        // 1. create a gesture recognizer (tap gesture)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(gesture:)))
        print("mobile = ", mobile)
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
    
    @IBOutlet weak var mobileOTP: TextField!
    var mobileOTPCorrect = false
    @IBAction func mobileOTPEditing(_ sender: Any) {
        let rightImageView = UIImageView(frame: CGRect(x: -10,  y:0, width: 20, height: 20))
        var image: UIImage!
        if mobileOTP.text?.count != 6{
            image = UIImage(named: "error")!
            rightImageView.image = image
            let view = UIView(frame: CGRect(x:0,  y:0, width: 20, height: 20))
            view.addSubview(rightImageView)
            mobileOTP.rightView = view
            mobileOTPCorrect = false
        }
        else {
            let jsonurl = "http://localhost:8080/api/v1/checkMobileOTP/" + mobile + "/" + mobileOTP.text! + "/?partner=false"
            
            guard let url = URL(string: jsonurl) else{return}
            let session = URLSession.shared
            
            session.dataTask(with: url) { (data, response, error) in
                guard let response = response else {return}
                
                print(response)
                guard let data = data else{ return}
                print(data)
                do {
                    let otpResponse = try JSONDecoder().decode(OTPResponse.self, from: data)
                    let otpResponseValue = otpResponse.valid
                    
                    if otpResponseValue == true{
                        image = UIImage(named: "bullet-icon")!
                        DispatchQueue.main.async { // Correct
                            
                            rightImageView.image = image
                            let view = UIView(frame: CGRect(x:0,  y:0, width: 20, height: 20))
                            view.addSubview(rightImageView)
                            self.mobileOTP.rightView = view
                            self.mobileOTPCorrect = true
                        }
                    }
                    else {
                        image = UIImage(named: "error")!
                        DispatchQueue.main.async { // Correct
                            rightImageView.image = image
                            let view = UIView(frame: CGRect(x:0,  y:0, width: 20, height: 20))
                            view.addSubview(rightImageView)
                            self.mobileOTP.rightView = view
                            self.mobileOTPCorrect = false
                        }
                    }
                }
                catch {
                    print(error)
                }
                }.resume()
           
        }
    }
    
    @IBOutlet weak var emailOTP: TextField!
    var emailOTPCorrect = false
    @IBAction func rmailOTPEditing(_ sender: Any) {
        let rightImageView = UIImageView(frame: CGRect(x: -10,  y:0, width: 20, height: 20))
        var image: UIImage!
        if emailOTP.text?.count != 6{
            image = UIImage(named: "error")!
            rightImageView.image = image
            let view = UIView(frame: CGRect(x:0,  y:0, width: 20, height: 20))
            view.addSubview(rightImageView)
            emailOTP.rightView = view
            emailOTPCorrect = false
        }
        else {
            let jsonurl = "http://localhost:8080/api/v1/checkEmailOTP/" + email + "/" + emailOTP.text! + "/?partner=false"
            
            guard let url = URL(string: jsonurl) else{return}
            let session = URLSession.shared
            
            session.dataTask(with: url) { (data, response, error) in
                guard let response = response else {return}
                
                print(response)
                guard let data = data else{ return}
                print(data)
                do {
                    let otpResponse = try JSONDecoder().decode(OTPResponse.self, from: data)
                    let otpResponseValue = otpResponse.valid
                    
                    if otpResponseValue == true{
                        image = UIImage(named: "bullet-icon")!
                        DispatchQueue.main.async { // Correct
                            
                            rightImageView.image = image
                            let view = UIView(frame: CGRect(x:0,  y:0, width: 20, height: 20))
                            view.addSubview(rightImageView)
                            self.emailOTP.rightView = view
                            self.emailOTPCorrect = true
                        }
                    }
                    else {
                        image = UIImage(named: "error")!
                        DispatchQueue.main.async { // Correct
                            rightImageView.image = image
                            let view = UIView(frame: CGRect(x:0,  y:0, width: 20, height: 20))
                            view.addSubview(rightImageView)
                            self.emailOTP.rightView = view
                            self.emailOTPCorrect = false
                        }
                    }
                }
                catch {
                    print(error)
                }
                }.resume()
            
        }
    }
    
    
    @IBOutlet weak var signUP: RoundedButton!
    @IBAction func signUPButton(_ sender: Any) {
        if mobileOTPCorrect && emailOTPCorrect && isTerms1Clicked && isTerms2Clicked{
            print("ok1")
            //            let params = ["aadhar": aadharCard.text!,
            //                          "emailID" : email.text!,
            //                          "emailOTP" : "",
            //                          "firstName": firstName.text!,
            //                          "gender" : genderSelected,
            //                          "lastName    ": lastName.text!,
            //                          "middleName" : middleName.text!,
            //                          "mobileOTP" : "",
            //                          "mobileNum" : mobile.text!,
            //                          "panNumber": panCard.text!,
            //                          "password" : password.text!,
            //                          "password2" : retypePassword.text!,
            //                          "type" : "borrower"]
            
            
            let params = [
                "mobileOTP": mobileOTP.text!,
                "emailOTP" : emailOTP.text!,
                "emailID": email,
                "user" : [
                    "firstName" : firstName,
                    "middleName": middleName,
                    "lastName": lastName,
                    "gender": gender,
                    "aadhar": aadhar,
                    "panNumber": panNumber,
                    "emailID": email,
                    "password": password,
                    "password2": password2,
                    "mobileCode": mobileCode,
                    "mobileNum": mobile,
                    "mobileOTP": mobileOTP.text!,
                    "emailOTP": emailOTP.text!,
                    "type": "borrower"
                ]
                ] as [String : Any]
            let postURL = "http://localhost:8080/api/v1/borrowerRegistration/submitBasic"
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
            print("httpBody = ", httpBody)
            request.httpBody = httpBody
            print("session starting")
            let session = URLSession.shared
            print("session created")
            print("request = " , request)
            session.dataTask(with: request) { (data, response, error) in
                print("ok2")
                if let response = response {
                    print(response)
                }
                if let data = data{
                    do{
                        print("trying json")
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        let otpSubmitResponse = try JSONDecoder().decode(OTPSubmitResponse.self, from: data)
                        print(json)
                        self.sessionID = otpSubmitResponse.session_id
                        self.csrfToken = otpSubmitResponse.csrf_token
                        
                        DispatchQueue.main.async {
                            let preferences = UserDefaults.standard
                            preferences.set(self.sessionID, forKey: "session_id")
                            preferences.set(self.csrfToken, forKey: "csrf_token")
                            preferences.synchronize()
                            self.performSegue(withIdentifier: "enterOTP", sender: self)
                        }
                        
                    } catch{
                        print(error)
                    }
                }
                }.resume()
            
        }
    }
    
}



