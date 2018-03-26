//
//  RegistrationFeePayment.swift
//  i2iFunding_1
//
//  Created by himanshu dahiya on 23/03/18.
//  Copyright © 2018 himanshu dahiya. All rights reserved.
//

import UIKit

class RegistrationFeePayment: UIViewController{
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
    
    @IBAction func PayNowButton(_ sender: Any) {
        let paymentParam = PayUModelPaymentParams()
        let hashes = PayUModelHashes()
        // Set the hashes here
        paymentParam.key = "gtKFFx"
        paymentParam.transactionID = "txnID20170220"
        paymentParam.amount = "10"
        paymentParam.productInfo = "iPhone"
        paymentParam.surl = "https://payu.herokuapp.com/success"
        paymentParam.furl = "https://payu.herokuapp.com/failure"
        paymentParam.firstName = "Baalak"
        paymentParam.email = "Baalak@gmail.com"
        paymentParam.udf1 = ""
        paymentParam.udf2 = ""
        paymentParam.udf3 = ""
        paymentParam.udf4 = ""
        paymentParam.udf5 = ""
        paymentParam.hashes = hashes
        // Set this property if you want to get the stored cards:
        paymentParam.userCredentials = "gtKFFx:Baalak@gmail.com"
        // Set the environment according to merchant key ENVIRONMENT_PRODUCTION for Production &
        // ENVIRONMENT_TEST for test environment:
        paymentParam.environment = ENVIRONMENT_TEST
        
        
        let webServiceResponse = PayUWebServiceResponse()
        webServiceResponse.getPayUPaymentRelatedDetail(forMobileSDK: paymentParam, withCompletionBlock: {(_ paymentRelatedDetails: PayUModelPaymentRelatedDetail, _ errorMessage: String, _ extraParam: Any) -> Void in
            if errorMessage == "" {
                let stryBrd = UIStoryboard(name: "PUUIMainStoryBoard", bundle: nil)
                let paymentOptionVC = stryBrd.instantiateViewController(withIdentifier: VC_IDENTIFIER_PAYMENT_OPTION) as? PUUIPaymentOptionVC
                paymentOptionVC?.paymentParam = paymentParam
                paymentOptionVC?.paymentRelatedDetail = paymentRelatedDetails
                self.navigationController?.pushViewController(paymentOptionVC!, animated: true)
            }
            else {
                // error occurred while creating the request
            }
            } as! completionBlockForPayUPaymentRelatedDetail)
        
        NotificationCenter.default.addObserver(self, selector: Selector(("responseReceived:")), name: NSNotification.Name(rawValue: kPUUINotiPaymentResponse), object: nil)
        
    }
    func responseReceived(_ notification: Notification?) {
        let strConvertedRespone = "\(String(describing: notification?.object))"
        print("Response Received \(strConvertedRespone)")
    }

}
