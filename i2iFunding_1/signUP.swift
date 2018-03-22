
import UIKit

struct SendOTPResponse: Decodable {
    let otpSent: Bool
    let token: String
    init(json: [String: Any]){
        otpSent = json["otpSent"] as? Bool ?? false
        token = json["token"] as? String ?? ""
    }
}


class signUP: UIViewController {
    
    
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
    
    // fields varification
    
    //first name
    @IBOutlet weak var firstName: TextField!
    var firstNameCorrect = false
    @IBAction func firstNameEditing(_ sender: Any) {
        let rightImageView = UIImageView(frame: CGRect(x: -10,  y:0, width: 20, height: 20))
        var image: UIImage
        if isValidName(testStr: firstName.text!) == true {
            image = UIImage(named: "bullet-icon")!
            firstNameCorrect = true
        }
        else {
            image = UIImage(named: "error")!
            firstNameCorrect = false
        }
        
        rightImageView.image = image
        let view = UIView(frame: CGRect(x:0,  y:0, width: 20, height: 20 ))
        view.addSubview(rightImageView)
        firstName.rightView = view
    }
    
    //middle name
    @IBOutlet weak var middleName: TextField!
    var middleNameCorrect = false
    @IBAction func middleNameEditing(_ sender: Any) {
        let rightImageView = UIImageView(frame: CGRect(x: -10,  y:0, width: 20, height: 20))
        var image: UIImage
        if isValidName(testStr: middleName.text!) == true {
            image = UIImage(named: "bullet-icon")!
            middleNameCorrect = true
        }
        else {
            image = UIImage(named: "error")!
            middleNameCorrect = false
        }
        
        rightImageView.image = image
        let view = UIView(frame: CGRect(x:0,  y:0, width: 20, height: 20 ))
        view.addSubview(rightImageView)
        middleName.rightView = view
    }
    
    //last name
    @IBOutlet weak var lastName: TextField!
    var lastNameCorrect = false
    @IBAction func lastNameEditing(_ sender: Any) {
        let rightImageView = UIImageView(frame: CGRect(x: -10,  y:0, width: 20, height: 20))
        var image: UIImage
        if isValidName(testStr: lastName.text!) == true {
            image = UIImage(named: "bullet-icon")!
            lastNameCorrect = true
        }
        else {
            image = UIImage(named: "error")!
            lastNameCorrect = false
        }
        
        rightImageView.image = image
        let view = UIView(frame: CGRect(x:0,  y:0, width: 20, height: 20 ))
        view.addSubview(rightImageView)
        lastName.rightView = view
    }
    // valid name regex func
    func isValidName(testStr:String) -> Bool {
        let firstNameRegex = "^[A-Z].[A-Za-z].*"
        
        let firstNameTest = NSPredicate(format:"SELF MATCHES %@", firstNameRegex)
        return firstNameTest.evaluate(with: testStr)
    }
    
    // aadhar card no varification
    
    @IBOutlet weak var aadharCard: TextField!
    var aadharCardCoorect = false
    @IBAction func aadharCardEditing(_ sender: Any) {
        let rightImageView = UIImageView(frame: CGRect(x: -10,  y:0, width: 20, height: 20))
        var image: UIImage!
        if aadharCard.text?.count != 12{
            image = UIImage(named: "error")!
            rightImageView.image = image
            let view = UIView(frame: CGRect(x:0,  y:0, width: 20, height: 20))
            view.addSubview(rightImageView)
            aadharCard.rightView = view
            aadharCardCoorect = false
        }
        else {
            
            let fieldProperties = FieldProperties(FieldValue: aadharCard.text!, FieldValid: aadharCardCoorect, JsonURLEnd: "/?partner=false", TextField: aadharCard, JsonURLStart: "checkAadhar/")
            
            let fieldValidation = FieldValidation()
            fieldValidation.FieldValidationFunc(FieldProperties: fieldProperties, completion: {
                success in
                print(success)
                self.aadharCardCoorect = success
            })
        }
        
        
    }
    
    
    // pan card validation
    @IBOutlet weak var panCard: TextField!
    var panCardCorrect = false
    
    @IBAction func panCardEditing(_ sender: Any) {
        let rightImageView = UIImageView(frame: CGRect(x: -10,  y:0, width: 20, height: 20))
        var image: UIImage!
        if isValidPanCard(testStr: panCard.text!) == false {
            print(panCard.text as Any)
            image = UIImage(named: "error")!
            rightImageView.image = image
            let view = UIView(frame: CGRect(x:0,  y:0, width: 20, height: 20))
            view.addSubview(rightImageView)
            panCard.rightView = view
            panCardCorrect = false
        }
        else {
            let fieldProperties = FieldProperties(FieldValue: panCard.text!, FieldValid: panCardCorrect, JsonURLEnd: "i2i_users||usr_pan/", TextField: panCard, JsonURLStart: "checkPan/")
            
            let fieldValidation = FieldValidation()
            fieldValidation.FieldValidationFunc(FieldProperties: fieldProperties, completion: {
                success in
                print(success)
                self.panCardCorrect = success
            })
            }
        
        
    }
    // pan card pattern validation func
    func isValidPanCard(testStr:String) -> Bool {
        let panCardRegex = "^[A-Z]{5}[0-9]{4}[A-Z]$"
        
        let panCardTest = NSPredicate(format:"SELF MATCHES %@", panCardRegex)
        return panCardTest.evaluate(with: testStr)
    }
    
    
    // email validation
    @IBOutlet weak var email: TextField!
    var emailCorrect = false
    @IBAction func emailEditing(_ sender: Any) {
        let rightImageView = UIImageView(frame: CGRect(x: -10,  y:0, width: 20, height: 20))
        var image: UIImage!
        if(isValidEmail(testStr: email.text!) == true) {
            let fieldProperties = FieldProperties(FieldValue: email.text!, FieldValid: emailCorrect, JsonURLEnd: "/i2i_users||usr_email", TextField: email, JsonURLStart: "checkEmail/")
            
            let fieldValidation = FieldValidation()
            fieldValidation.FieldValidationFunc(FieldProperties: fieldProperties, completion:{ success in
                print(success)
                self.emailCorrect = success
            })
        }
        else {
            image = UIImage(named: "error")!
            rightImageView.image = image
            let view = UIView(frame: CGRect(x:0,  y:0, width: 20, height: 20))
            view.addSubview(rightImageView)
            email.rightView = view
            emailCorrect = false
        }
    }
    //email validation
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    
    // password validation
    @IBOutlet weak var password: TextField!
    var passwordCorrect = false
    @IBAction func passwordEditing(_ sender: Any) {
        let rightImageView = UIImageView(frame: CGRect(x: -10,  y:0, width: 20, height: 20))
        var image: UIImage
        if isValidPassword(testStr: password.text!) == true {
            image = UIImage(named: "bullet-icon")!
            passwordCorrect = true
        }
        else {
            image = UIImage(named: "error")!
            passwordCorrect = false
        }
        
        rightImageView.image = image
        let view = UIView(frame: CGRect(x:0,  y:0, width: 20, height: 20 ))
        view.addSubview(rightImageView)
        password.rightView = view
    }
    // is valid password
    func isValidPassword(testStr:String) -> Bool {
        let panCardRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{8,14}"
        let panCardTest = NSPredicate(format:"SELF MATCHES %@", panCardRegex)
        return panCardTest.evaluate(with: testStr)
    }
    
    
    @IBOutlet weak var retypePassword: TextField!
    var retypePasswordCorrect = false
    @IBAction func retypePasswordEditing(_ sender: Any) {
        let rightImageView = UIImageView(frame: CGRect(x: -10,  y:0, width: 20, height: 20))
        var image: UIImage
        if retypePassword.text! == password.text!{
            image = UIImage(named: "bullet-icon")!
            retypePasswordCorrect = true
        }
        else {
            image = UIImage(named: "error")!
            retypePasswordCorrect = false
        }
        
        rightImageView.image = image
        let view = UIView(frame: CGRect(x:0,  y:0, width: 20, height: 20 ))
        view.addSubview(rightImageView)
        retypePassword.rightView = view
    }
    
    @IBOutlet weak var mobile: TextField!
    var mobileCorrect = false
    @IBAction func mobileEditing(_ sender: Any) {
        //var countValue = -1
        let rightImageView = UIImageView(frame: CGRect(x: -10,  y:0, width: 20, height: 20))
        var image: UIImage!
        if mobile.text?.count != 10{
            image = UIImage(named: "error")!
            rightImageView.image = image
            let view = UIView(frame: CGRect(x:0,  y:0, width: 20, height: 20))
            view.addSubview(rightImageView)
            mobile.rightView = view
            mobileCorrect = false
        }
        else {
            let fieldProperties = FieldProperties(FieldValue: mobile.text!, FieldValid: mobileCorrect, JsonURLEnd: "/?partner=false", TextField: mobile, JsonURLStart: "checkPhoneNumber/")
            
            let fieldValidation = FieldValidation()
            fieldValidation.FieldValidationFunc(FieldProperties: fieldProperties, completion: {
                fieldValid in
                print(fieldValid)
                self.mobileCorrect = fieldValid
            })
            //mobileCorrect = success
            print("mobileCorrect", mobileCorrect)
        }
        
    }
    
    var genderSelected = ""
    var isGenderSelected = false
    @IBOutlet weak var maleButton: DLRadioButton!
    @IBOutlet weak var femaleButton: DLRadioButton!
    @IBAction func genderSelectedType(_ sender: DLRadioButton) {
        if sender.tag == 1{
            genderSelected = "M"
            isGenderSelected = true
        }
        else if sender.tag == 2{
            genderSelected = "F"
            isGenderSelected = true
        }
        else {
            genderSelected = ""
            isGenderSelected = false
        }
    }
    
    // send otp pressed
    @IBOutlet weak var sendOTP: RoundedButton!
    var otpSent = false
    var token = ""
    @IBAction func sendOTPFunc(_ sender: Any) {
        if middleName.text == ""{
            middleNameCorrect = true
        }
        panCardCorrect = true
        emailCorrect = true
        print("ok0")
        
        print(firstNameCorrect, middleNameCorrect, lastNameCorrect, aadharCardCoorect, panCardCorrect, emailCorrect, passwordCorrect, retypePassword, mobileCorrect)
//        if firstNameCorrect && middleNameCorrect && lastNameCorrect && aadharCardCoorect && panCardCorrect && emailCorrect && passwordCorrect  && retypePasswordCorrect && mobileCorrect && isGenderSelected {
        if true{
            print("ok1")
//            let params = ["aadhar": aadharCard.text!,
//                          "emailID" : email.text!,
//                          "emailOTP" : "",
//                          "firstName": firstName.text!,
//                          "gender" : genderSelected,
//                          "lastName    ": lastName.text!,
//                          "middleName" : middleName.text!,
//                          "mobileOTP" : "",
//                          "panNumber": panCard.text!,
//                          "password" : password.text!,
//                          "password2" : retypePassword.text!,
//                          "type" : "borrower"]
            
            let params = [
                "firstName": "Himanshu",
                "middleName" : "",
                "lastName": "Dahiya",
                "gender" : "M",
                "aadhar" : "929391929192",
                "panNumber": "JAJSJ9292J",
                "emailID" : "himanshudahiya06@gmail.com",
                "password" : "Redowid@4",
                "password2" : "Redowid@4",
                "emailOTP" : "",
                "mobileOTP" : "",
                "type" : "borrower"]
            let postURL = "https://api.i2ifunding.com/api/v1/borrowerRegistration/basic/?institution=false"
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
                        let sentOTPResponse = try JSONDecoder().decode(SendOTPResponse.self, from: data)
                        self.otpSent = sentOTPResponse.otpSent
                        self.token = sentOTPResponse.token
                        print(json)
                        
                        self.performSegue(withIdentifier: "sendOTP", sender: self)
                    } catch{
                        print(error)
                    }
                }
            }.resume()
           
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? EnterOTP{
            destination.email = self.email.text
            destination.mobile = self.mobile.text
            destination.token = self.token
        }
    }
    
}

