//
//  LoanEligibility.swift
//  i2iFunding_1
//
//  Created by himanshu dahiya on 20/03/18.
//  Copyright © 2018 himanshu dahiya. All rights reserved.
//
import SearchTextField
import UIKit

class LoanEligibility: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate{
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loanTenure: UITextField!
    @IBOutlet weak var loanPurpose: TextField!
    @IBOutlet weak var dateOfBirth: TextField!
    var tenureValid = false
    var purposeValid = false
    var dobValid = false
    let dobPicker = UIDatePicker()
    let joiningDatePicker = UIDatePicker()
    let stayingDatePicker = UIDatePicker()
    let loanTenureField = ["", "3 Months", "6 Months", "9 Months", "12 Months", "15 Months", "18 Months", "21 Months", "24 Months"]
    let loanPurposeField = ["", "Education", "Self Marriage", "Relative's Marriage", "House Renovation", "Personal Loan Consolidation", "Consumer Loan", "Holiday/Travel", "Medical Expense", "Purchase of Vehicle", "Others", "Business Expansion"]
    
    let pickerViewTenure = UIPickerView()
    
    let pickerViewPurpose = UIPickerView()
    
    struct PinCodeResponse: Decodable {
        let pinID: Int
        let pinCode: Int
        let pinCity: String
        let pinState: String
        let pinStatus: Int
        init(json: [String: Any]){
            pinID = json["pin_id"] as? Int ?? 0
            pinCode = json["pin_code"] as? Int ?? 0
            pinCity = json["pin_city"] as? String ?? ""
            pinState = json["pin_state"] as? String ?? ""
            pinStatus = json["pin_status"] as? Int ?? 0
        }
    }
//    struct CompanyNameResponse: Decodable{
//        let company: [String]
//        init(){
//            company = json[]
//        }
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerViewTenure.delegate = self
        pickerViewPurpose.delegate = self
        
        loanTenure.inputView = pickerViewTenure
        loanPurpose.inputView = pickerViewPurpose
        
        // Do any additional setup after loading the view, typically from a nib.
        // 1. create a gesture recognizer (tap gesture)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(gesture:)))
        
        // 2. add the gesture recognizer to a view
        scrollView.addGestureRecognizer(tapGesture)
        createDOBPicker()
        createJoiningDatePicker()
        createStayingDatePicker()
    }
    //function for picker view
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickerViewTenure{
            return loanTenureField.count
        }
        else {
            return loanPurposeField.count
        }
    }
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pickerViewTenure{
            return loanTenureField[row]
        }
        else {
            return loanPurposeField[row]
        }
    }
    // When user selects an option, this function will set the text of the text field to reflect
    // the selected option.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pickerViewTenure{
            if(row != 0){
                tenureValid = true
            } else {tenureValid = false}
            loanTenure.text = loanTenureField[row]
        }
        else {
            if(row != 0){
                purposeValid = true
            } else {purposeValid = false}
            loanPurpose.text = loanPurposeField[row]
        }
    }

    // date of birth picker
    func createDOBPicker(){
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneButton], animated: true)
        
        dateOfBirth.inputAccessoryView = toolbar
        dateOfBirth.inputView = dobPicker
    }

    @objc func donePressed(){
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let date = formatter.string(from: dobPicker.date)
        dateOfBirth.text = date
        dobValid = true
        self.view.endEditing(true)
    }
    
    
    // joining date picker
    func createJoiningDatePicker(){
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneJDPressed))
        toolbar.setItems([doneButton], animated: true)
        
        joiningDate.inputAccessoryView = toolbar
        joiningDate.inputView = joiningDatePicker
    }
    
    @objc func doneJDPressed(){
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let date = formatter.string(from: joiningDatePicker.date)
        joiningDate.text = date
        joiningDateValid = true
        self.view.endEditing(true)
    }
    
    // staying date picker
    func createStayingDatePicker(){
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneSDPressed))
        toolbar.setItems([doneButton], animated: true)
        
        stayingSince.inputAccessoryView = toolbar
        stayingSince.inputView = joiningDatePicker
    }
    
    @objc func doneSDPressed(){
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let date = formatter.string(from: stayingDatePicker.date)
        stayingSince.text = date
        stayingDateValid = true
        self.view.endEditing(true)
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
    @IBOutlet weak var employmentTypeButton: UIButton!
    var employmentTypeButtonSelected = false
    @IBOutlet var employmentType: [UIButton]!
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
        case one = "Self Employed"
        case two = "Salaried"
        case three = "Employment Type"
    }
    // business options
    @IBOutlet weak var businessEstYear: TextField!
    var businessEstYearValid = false
    @IBOutlet weak var businessType: TextField!
    var businessTypeValid = false
    @IBOutlet weak var businessGrossAT: TextField!
    var businessGrossATValid = false
    @IBOutlet weak var businessGrossAP: TextField!
    var businessGrossAPValid = false
    
    // self employed options
    @IBOutlet weak var totalProfExp: TextField!
    var totalProfExpValid = false
    @IBOutlet weak var professionType: TextField!
    var professionTypeValid = false
    @IBOutlet weak var selfGrossAT: TextField!
    var selfGrossATValid = false
    @IBOutlet weak var selfGrossAP: TextField!
    var selfGrossAPValid = false
    
    // salaried options
    @IBOutlet weak var companyName: SearchTextField!
    var companyNameValid = false
    @IBOutlet weak var monthlySalary: TextField!
    var monthlySalaryValid = false
    @IBOutlet weak var salaryMode: UIStackView!
    var salaryModeValid = false
    @IBOutlet weak var joiningDate: TextField!
    var joiningDateValid = false
    @IBOutlet weak var salariedLabel: UILabel!
    @IBOutlet weak var workExpStack: UIStackView!
    @IBOutlet weak var workExpYears: TextField!
    var workExpYearsValid = false
    @IBOutlet weak var workExpMonths: TextField!
    var workExpMonthsValid = false
    
    @IBAction func employmentTypesTapped(_ sender: UIButton) {
        guard let title = sender.currentTitle, let num = nums(rawValue: title) else {
            return
        }
        switch num {
        case .zero:
            print("0")
            businessType.isHidden = false
            businessEstYear.isHidden = false
            businessGrossAT.isHidden = false
            businessGrossAP.isHidden = false
            totalProfExp.isHidden = true
            professionType.isHidden = true
            selfGrossAT.isHidden = true
            selfGrossAP.isHidden = true
            companyName.isHidden = true
            monthlySalary.isHidden = true
            salaryMode.isHidden = true
            joiningDate.isHidden = true
            salariedLabel.isHidden = true
            workExpStack.isHidden = true
            employmentTypeButtonSelected = true
        case .one:
            print("1")
            businessType.isHidden = true
            businessEstYear.isHidden = true
            businessGrossAT.isHidden = true
            businessGrossAP.isHidden = true
            totalProfExp.isHidden = false
            professionType.isHidden = false
            selfGrossAT.isHidden = false
            selfGrossAP.isHidden = false
            companyName.isHidden = true
            monthlySalary.isHidden = true
            salaryMode.isHidden = true
            joiningDate.isHidden = true
            salariedLabel.isHidden = true
            workExpStack.isHidden = true
            employmentTypeButtonSelected = true
        case .two:
            print("2")
            businessType.isHidden = true
            businessEstYear.isHidden = true
            businessGrossAT.isHidden = true
            businessGrossAP.isHidden = true
            totalProfExp.isHidden = true
            professionType.isHidden = true
            selfGrossAT.isHidden = true
            selfGrossAP.isHidden = true
            companyName.isHidden = false
            monthlySalary.isHidden = false
            salaryMode.isHidden = false
            joiningDate.isHidden = false
            salariedLabel.isHidden = false
            workExpStack.isHidden = false
            employmentTypeButtonSelected = true
        case .three:
            businessType.isHidden = true
            businessEstYear.isHidden = true
            businessGrossAT.isHidden = true
            businessGrossAP.isHidden = true
            totalProfExp.isHidden = true
            professionType.isHidden = true
            selfGrossAT.isHidden = true
            selfGrossAP.isHidden = true
            companyName.isHidden = true
            monthlySalary.isHidden = true
            salaryMode.isHidden = true
            joiningDate.isHidden = true
            salariedLabel.isHidden = true
            workExpStack.isHidden = true
            employmentTypeButtonSelected = false
        }
        handleSelection(employmentTypeButton)
    }
    
    // validation functions
    
    // loan amount
    @IBOutlet weak var loanAmount: TextField!
    var loanAmountValid = false
    @IBAction func loanAmountEditing(_ sender: Any) {
        let loanAmountValue:Int? = Int(loanAmount.text!)
        let rightImageView = UIImageView(frame: CGRect(x: -10,  y:0, width: 20, height: 20))
        var image: UIImage
        
        if loanAmountValue!%5000 == 0 && loanAmountValue!>=25000 && loanAmountValue!<=300000 {
            image = UIImage(named: "bullet-icon")!
            loanAmountValid = true
        }
        else {
            image = UIImage(named: "error")!
            loanAmountValid = false
        }
        
        rightImageView.image = image
        let view = UIView(frame: CGRect(x:0,  y:0, width: 20, height: 20 ))
        view.addSubview(rightImageView)
        loanAmount.rightView = view
    }
    
    // description of loan
    @IBOutlet weak var loanDescription: TextField!
    var loanDescriptionValid = false
    @IBAction func loanDescriptionEditing(_ sender: Any) {
        let rightImageView = UIImageView(frame: CGRect(x: -10,  y:0, width: 20, height: 20))
        var image: UIImage
        
        if (loanDescription.text!.count) >= 1 {
            image = UIImage(named: "bullet-icon")!
            loanDescriptionValid = true
        }
        else {
            image = UIImage(named: "error")!
            loanDescriptionValid = false
        }
        
        rightImageView.image = image
        let view = UIView(frame: CGRect(x:0,  y:0, width: 20, height: 20 ))
        view.addSubview(rightImageView)
        loanDescription.rightView = view
    }
    
    // marital status
    var maritalStatusValid = false
    var maritalStatus = ""
    @IBOutlet weak var singleButton: DLRadioButton!
    @IBOutlet weak var marriedButton: DLRadioButton!
    @IBAction func maritalStatusSelected(_ sender: DLRadioButton) {
        if sender.tag == 1{
            maritalStatus = "Single"
            maritalStatusValid = true
        }
        else if sender.tag == 2{
            maritalStatus = "Married"
            maritalStatusValid = true
        }
        else {
            maritalStatus = ""
            maritalStatusValid = false
        }
    }
    
    //pin code && city
    @IBOutlet weak var pinCode: TextField!
    var pinCodeValid = false
    
    @IBOutlet weak var city: TextField!
    var cityValid = false
    @IBAction func pinCodeEditing(_ sender: Any) {
        let rightImageView = UIImageView(frame: CGRect(x: -10,  y:0, width: 20, height: 20))
        var image: UIImage!
        
        if (pinCode.text!.count) == 6 {
            //https://api.i2ifunding.com/api/v1/pincodeSearch/140001/
            let jsonurl = "https://api.i2ifunding.com/api/v1/pincodeSearch/" + pinCode.text!
            
            guard let url = URL(string: jsonurl) else{return}
            let session = URLSession.shared
            
            session.dataTask(with: url) { (data, response, error) in
                guard let response = response else {return}
                
                print(response)
                guard let data = data else{ return}
                print(data)
                do {
                    let pinResponse = try JSONDecoder().decode(PinCodeResponse.self, from: data)
                    let cityValue = pinResponse.pinCity
                        image = UIImage(named: "bullet-icon")!
                        DispatchQueue.main.async { // Correct
                            self.city.text = cityValue
                            self.cityValid = true
                            
                            rightImageView.image = image
                            let view = UIView(frame: CGRect(x:0,  y:0, width: 20, height: 20))
                            view.addSubview(rightImageView)
                            self.pinCode.rightView = view
                            self.city.rightView = view
                            self.pinCodeValid = true
                        }
                    
                }
                catch {
                    print(error)
                }
                }.resume()
        }
        else {
            image = UIImage(named: "error")!
            pinCodeValid = false
            rightImageView.image = image
            let view = UIView(frame: CGRect(x:0,  y:0, width: 20, height: 20 ))
            view.addSubview(rightImageView)
            pinCode.rightView = view
            cityValid = false
            city.text = ""
            city.rightView = view
            
        }
    }
    
    // business est year
    @IBAction func businessEstYearEditing(_ sender: Any) {
        let rightImageView = UIImageView(frame: CGRect(x: -10,  y:0, width: 20, height: 20))
        var image: UIImage
        
        if (businessEstYear.text!.count) == 4 {
            image = UIImage(named: "bullet-icon")!
            businessEstYearValid = true
        }
        else {
            image = UIImage(named: "error")!
            businessEstYearValid = false
        }
        
        rightImageView.image = image
        let view = UIView(frame: CGRect(x:0,  y:0, width: 20, height: 20 ))
        view.addSubview(rightImageView)
        businessEstYear.rightView = view
    }
    
    // business type
    @IBAction func businessTypeEditing(_ sender: Any) {
        let rightImageView = UIImageView(frame: CGRect(x: -10,  y:0, width: 20, height: 20))
        var image: UIImage
        
        if (businessType.text!.count) >= 1 {
            image = UIImage(named: "bullet-icon")!
            businessTypeValid = true
        }
        else {
            image = UIImage(named: "error")!
            businessTypeValid = false
        }
        
        rightImageView.image = image
        let view = UIView(frame: CGRect(x:0,  y:0, width: 20, height: 20 ))
        view.addSubview(rightImageView)
        businessType.rightView = view
    }
    
    // business gross AT
    @IBAction func businessGrossATEditing(_ sender: Any) {
        let rightImageView = UIImageView(frame: CGRect(x: -10,  y:0, width: 20, height: 20))
        var image: UIImage
        
        if (businessGrossAT.text!.count) >= 1 {
            image = UIImage(named: "bullet-icon")!
            businessGrossATValid = true
        }
        else {
            image = UIImage(named: "error")!
            businessGrossATValid = false
        }
        
        rightImageView.image = image
        let view = UIView(frame: CGRect(x:0,  y:0, width: 20, height: 20 ))
        view.addSubview(rightImageView)
        businessGrossAT.rightView = view
    }
    
    // business gross AP
    @IBAction func businessGrossAPEditing(_ sender: Any) {
        let rightImageView = UIImageView(frame: CGRect(x: -10,  y:0, width: 20, height: 20))
        var image: UIImage
        
        if (businessGrossAP.text!.count) >= 1 {
            image = UIImage(named: "bullet-icon")!
            businessGrossAPValid = true
        }
        else {
            image = UIImage(named: "error")!
            businessGrossAPValid = false
        }
        
        rightImageView.image = image
        let view = UIView(frame: CGRect(x:0,  y:0, width: 20, height: 20 ))
        view.addSubview(rightImageView)
        businessGrossAP.rightView = view
    }
    
    // total proff exp
    @IBAction func totalProfExpEditing(_ sender: Any) {
        let rightImageView = UIImageView(frame: CGRect(x: -10,  y:0, width: 20, height: 20))
        var image: UIImage
        
        if (totalProfExp.text!.count) >= 1 {
            image = UIImage(named: "bullet-icon")!
            totalProfExpValid = true
        }
        else {
            image = UIImage(named: "error")!
            totalProfExpValid = false
        }
        
        rightImageView.image = image
        let view = UIView(frame: CGRect(x:0,  y:0, width: 20, height: 20 ))
        view.addSubview(rightImageView)
        totalProfExp.rightView = view
    }
    
    //profession type
    @IBAction func professionTypeEditing(_ sender: Any) {
        let rightImageView = UIImageView(frame: CGRect(x: -10,  y:0, width: 20, height: 20))
        var image: UIImage
        
        if (professionType.text!.count) >= 1 {
            image = UIImage(named: "bullet-icon")!
            professionTypeValid = true
        }
        else {
            image = UIImage(named: "error")!
            professionTypeValid = false
        }
        
        rightImageView.image = image
        let view = UIView(frame: CGRect(x:0,  y:0, width: 20, height: 20 ))
        view.addSubview(rightImageView)
        professionType.rightView = view
    }
    
    // self gross AT
    @IBAction func selfGrossATEditing(_ sender: Any) {
        let rightImageView = UIImageView(frame: CGRect(x: -10,  y:0, width: 20, height: 20))
        var image: UIImage
        
        if (selfGrossAT.text!.count) >= 1 {
            image = UIImage(named: "bullet-icon")!
            selfGrossATValid = true
        }
        else {
            image = UIImage(named: "error")!
            selfGrossATValid = false
        }
        
        rightImageView.image = image
        let view = UIView(frame: CGRect(x:0,  y:0, width: 20, height: 20 ))
        view.addSubview(rightImageView)
        selfGrossAT.rightView = view
    }
    
    // self gross AP
    @IBAction func selfGrossAPEditing(_ sender: Any) {
        let rightImageView = UIImageView(frame: CGRect(x: -10,  y:0, width: 20, height: 20))
        var image: UIImage
        
        if (selfGrossAP.text!.count) >= 1 {
            image = UIImage(named: "bullet-icon")!
            selfGrossAPValid = true
        }
        else {
            image = UIImage(named: "error")!
            selfGrossAPValid = false
        }
        
        rightImageView.image = image
        let view = UIView(frame: CGRect(x:0,  y:0, width: 20, height: 20 ))
        view.addSubview(rightImageView)
        selfGrossAP.rightView = view
    }

    //https://api.i2ifunding.com/api/v1/companySearch/a
    //company name
    
    @IBAction func companyNameEditing(_ sender: Any) {
        let rightImageView = UIImageView(frame: CGRect(x: -10,  y:0, width: 20, height: 20))
        var image: UIImage!
        
        if (companyName.text!.count) >= 1 {
            rightImageView.image = image
            let view = UIView(frame: CGRect(x:0,  y:0, width: 20, height: 20))
            image = UIImage(named: "bullet-icon")!
            view.addSubview(rightImageView)
            self.companyName.rightView = view
            self.companyNameValid = true
//            let jsonurl = "https://api.i2ifunding.com/api/v1/companySearch/" + companyName.text
//
//            guard let url = URL(string: jsonurl) else{return}
//            let session = URLSession.shared
//
//            session.dataTask(with: url) { (data, response, error) in
//                guard let response = response else {return}
//
//                print(response)
//                guard let data = data else{ return}
//                print(data)
//                do {
//                    //let pinResponse = try JSONSerialization.jsonObject(with: date, options: )
//                    if let json = (try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0))) as? [[String : AnyObject]] {
//                        print(json.count) // Should be 2, based on your sample json above
//                    }
//                    DispatchQueue.main.async { // Correct
//
//                    }
//
//                }
//                catch {
//                    print(error)
//                }
//                }.resume()
        }
        else {
            image = UIImage(named: "error")!
            pinCodeValid = false
            rightImageView.image = image
            let view = UIView(frame: CGRect(x:0,  y:0, width: 20, height: 20 ))
            view.addSubview(rightImageView)
            pinCode.rightView = view
            cityValid = false
            city.text = ""
            city.rightView = view
            
        }
    }
    
    // monthly salary
    @IBAction func monthlySalaryEditing(_ sender: Any) {
        let rightImageView = UIImageView(frame: CGRect(x: -10,  y:0, width: 20, height: 20))
        var image: UIImage
        
        if (monthlySalary.text!.count) >= 1 {
            image = UIImage(named: "bullet-icon")!
            monthlySalaryValid = true
        }
        else {
            image = UIImage(named: "error")!
            monthlySalaryValid = false
        }
        
        rightImageView.image = image
        let view = UIView(frame: CGRect(x:0,  y:0, width: 20, height: 20 ))
        view.addSubview(rightImageView)
        monthlySalary.rightView = view
    }
    
    // salary mode
    @IBOutlet weak var salaryModeButton: UIButton!
    var salaryModeButtonSelected = false
    var salarayMode = ""
    @IBOutlet var salaryModes: [UIButton]!
    @IBAction func handleSalaryMode(_ sender: UIButton) {
        salaryModes.forEach { (button) in
            UIView.animate(withDuration: 0.3, animations: {
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            })
        }
    }
    
    enum salary: String{
        case zero = "Salary Mode"
        case one = "Cash"
        case two = "Cheque"
        case three = "Credit to Bank Account"
    }
    @IBAction func salaryTypesTapped(_ sender: UIButton) {
        guard let title = sender.currentTitle, let num = nums(rawValue: title) else {
            return
        }
        switch num {
        case .zero:
            salaryModeButtonSelected = false
            salarayMode = ""
        case .one:
            salaryModeButtonSelected = true
            salarayMode = title
        case .two:
            salaryModeButtonSelected = true
            salarayMode = title
        case .three:
            salaryModeButtonSelected = true
            salarayMode = title
        }
        handleSalaryMode(salaryModeButton)
    }
    
    // work exp years
    @IBAction func workExpYearsEditing(_ sender: Any) {
        let rightImageView = UIImageView(frame: CGRect(x: -10,  y:0, width: 20, height: 20))
        var image: UIImage
        
        if (workExpYears.text!.count) >= 1 {
            image = UIImage(named: "bullet-icon")!
            workExpYearsValid = true
        }
        else if (workExpYears.text!.count) > 2 {
            image = UIImage(named: "error")!
            workExpYearsValid = false
        }
        else {
            image = UIImage(named: "error")!
            workExpYearsValid = false
        }
        rightImageView.image = image
        let view = UIView(frame: CGRect(x:0,  y:0, width: 20, height: 20 ))
        view.addSubview(rightImageView)
        workExpYears.rightView = view
    }
    
    // work exp months
    @IBAction func workExpMonthsEditing(_ sender: Any) {
        let rightImageView = UIImageView(frame: CGRect(x: -10,  y:0, width: 20, height: 20))
        var image: UIImage
        let workExpMonthsInt = Int(workExpMonths.text!)
        if (workExpMonths.text!.count) >= 1 && (workExpMonthsInt) == 12{
            image = UIImage(named: "bullet-icon")!
            workExpMonthsValid = true
        }
        else {
            image = UIImage(named: "error")!
            workExpMonthsValid = false
        }
        rightImageView.image = image
        let view = UIView(frame: CGRect(x:0,  y:0, width: 20, height: 20 ))
        view.addSubview(rightImageView)
        workExpMonths.rightView = view
    }
    
    // residence type
    @IBOutlet weak var residenceTypeButton: UIButton!
    var residenceTypeButtonSelected = false
    var residenceType = ""
    @IBOutlet var residenceTypeButtons: [UIButton]!
    @IBAction func handleResidenceType(_ sender: UIButton) {
        residenceTypeButtons.forEach { (button) in
            UIView.animate(withDuration: 0.3, animations: {
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            })
        }
    }
    
    enum residence: String{
        case zero = "Residence Type"
        case one = "Rented"
        case two = "Own"
        case three = "Parental"
    }
    
    @IBOutlet weak var rentedLabel: UILabel!
    @IBOutlet weak var rentedLabelRadios: UIStackView!
    @IBOutlet weak var monthlyRent: TextField!
    @IBOutlet weak var stayingSince: TextField!
    var stayingDateValid = false
    
    @IBAction func residenceTypesTapped(_ sender: UIButton) {
        guard let title = sender.currentTitle, let num = nums(rawValue: title) else {
            return
        }
        switch num {
        case .zero:
            residenceTypeButtonSelected = false
            residenceType = ""
            rentedLabel.isHidden = true
            rentedLabelRadios.isHidden = true
            monthlyRent.isHidden = true
            stayingSince.isHidden = true
        case .one:
            salaryModeButtonSelected = true
            salarayMode = title
            rentedLabel.isHidden = false
            rentedLabelRadios.isHidden = false
            monthlyRent.isHidden = false
            stayingSince.isHidden = false
        case .two:
            salaryModeButtonSelected = true
            salarayMode = title
            rentedLabel.isHidden = true
            rentedLabelRadios.isHidden = true
            monthlyRent.isHidden = true
            stayingSince.isHidden = true
        case .three:
            salaryModeButtonSelected = true
            salarayMode = title
            rentedLabel.isHidden = true
            rentedLabelRadios.isHidden = true
            monthlyRent.isHidden = true
            stayingSince.isHidden = true
        }
        handleResidenceType(residenceTypeButton)
    }
    // rented guaranter buttons
    var rentedGuaranterValid = false
    var canProvideGuaranter = ""
    @IBOutlet weak var guaranterYesButton: DLRadioButton!
    @IBOutlet weak var guaranterNoButton: DLRadioButton!
    @IBAction func guaranterSelected(_ sender: DLRadioButton) {
        if sender.tag == 1{
            canProvideGuaranter = "Yes"
            rentedGuaranterValid = true
        }
        else if sender.tag == 2{
            canProvideGuaranter = "No"
            rentedGuaranterValid = true
        }
        else {
            canProvideGuaranter = ""
            rentedGuaranterValid = false
        }
    }
    
    // monthly rent
    var monthlyRentValid = false
    @IBAction func monthlyRentEditing(_ sender: Any) {
        let rightImageView = UIImageView(frame: CGRect(x: -10,  y:0, width: 20, height: 20))
        var image: UIImage
        
        if (monthlyRent.text!.count) >= 1 {
            image = UIImage(named: "bullet-icon")!
            monthlyRentValid = true
        }
        else {
            image = UIImage(named: "error")!
            monthlyRentValid = false
        }
        rightImageView.image = image
        let view = UIView(frame: CGRect(x:0,  y:0, width: 20, height: 20 ))
        view.addSubview(rightImageView)
        monthlyRent.rightView = view
    }
    
    // any other Income
    @IBOutlet weak var anyOtherIncome: TextField!
    var anyOtherIncomeValid = false
    @IBAction func anyOtherIncomeEditing(_ sender: Any) {
        let rightImageView = UIImageView(frame: CGRect(x: -10,  y:0, width: 20, height: 20))
        var image: UIImage
        
        if (anyOtherIncome.text!.count) >= 1 {
            image = UIImage(named: "bullet-icon")!
            anyOtherIncomeValid = true
        }
        else {
            image = UIImage(named: "error")!
            anyOtherIncomeValid = false
        }
        
        rightImageView.image = image
        let view = UIView(frame: CGRect(x:0,  y:0, width: 20, height: 20 ))
        view.addSubview(rightImageView)
        anyOtherIncome.rightView = view
    }
    
    // any other loan running
    var anyOtherLoanValid = false
    var anyOtherLoan = ""
    @IBOutlet weak var otherLoanYesButton: DLRadioButton!
    @IBOutlet weak var otherLoanNoButton: DLRadioButton!
    @IBOutlet weak var otherLoanValue: TextField!
    var otherLoanValueValid = false
    @IBAction func otherLoanSelected(_ sender: DLRadioButton) {
        if sender.tag == 1{
            anyOtherLoan = "Yes"
            anyOtherLoanValid = true
            otherLoanValue.isHidden = false
        }
        else if sender.tag == 2{
            anyOtherLoan = "No"
            anyOtherLoanValid = true
            otherLoanValue.isHidden = true
            otherLoanValueValid = true
        }
        else {
            anyOtherLoan = ""
            anyOtherLoanValid = false
            otherLoanValue.isHidden = true
            otherLoanValueValid = false
        }
    }
    
    // other loan value
    @IBAction func anyOtherLoanEditing(_ sender: Any) {
        let rightImageView = UIImageView(frame: CGRect(x: -10,  y:0, width: 20, height: 20))
        var image: UIImage
        
        if (otherLoanValue.text!.count) >= 1 {
            image = UIImage(named: "bullet-icon")!
            otherLoanValueValid = true
        }
        else {
            image = UIImage(named: "error")!
            otherLoanValueValid = false
        }
        
        rightImageView.image = image
        let view = UIView(frame: CGRect(x:0,  y:0, width: 20, height: 20 ))
        view.addSubview(rightImageView)
        otherLoanValue.rightView = view
    }
    
    // any credit card running
    var anyCreditCardValid = false
    var anyCreditCard = ""
    @IBOutlet weak var creditYesButton: DLRadioButton!
    @IBOutlet weak var creditNoButton: DLRadioButton!
    @IBOutlet weak var creditOutstandingValue: TextField!
    var creditOutstandingValueValid = false
    @IBAction func creditCardSelected(_ sender: DLRadioButton) {
        if sender.tag == 1{
            anyCreditCard = "Yes"
            anyCreditCardValid = true
            creditOutstandingValue.isHidden = false
        }
        else if sender.tag == 2{
            anyCreditCard = "No"
            anyCreditCardValid = true
            creditOutstandingValue.isHidden = true
            creditOutstandingValueValid = true
        }
        else {
            anyCreditCard = ""
            anyCreditCardValid = false
            creditOutstandingValue.isHidden = true
            creditOutstandingValueValid = false
        }
    }
    
    // other loan value
    @IBAction func creditOutstandingEditing(_ sender: Any) {
        let rightImageView = UIImageView(frame: CGRect(x: -10,  y:0, width: 20, height: 20))
        var image: UIImage
        
        if (creditOutstandingValue.text!.count) >= 1 {
            image = UIImage(named: "bullet-icon")!
            creditOutstandingValueValid = true
        }
        else {
            image = UIImage(named: "error")!
            creditOutstandingValueValid = false
        }
        
        rightImageView.image = image
        let view = UIView(frame: CGRect(x:0,  y:0, width: 20, height: 20 ))
        view.addSubview(rightImageView)
        creditOutstandingValue.rightView = view
    }
    
    // CIBIL score
    let CIBILScoreValid = true
    @IBOutlet weak var CIBILScore: TextField!
    
    
    // perform segue
}

