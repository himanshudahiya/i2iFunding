//
//  FieldValidation.swift
//  i2iFunding_1
//
//  Created by himanshu dahiya on 19/03/18.
//  Copyright © 2018 himanshu dahiya. All rights reserved.
//

import Foundation
import UIKit


struct CountResponse1: Decodable {
    let count: Int
    init(json: [String: Any]){
        count = json["count"] as? Int ?? 0
    }
}

struct FieldProperties {
    let FieldValue: String
    var FieldValid: Bool
    let JsonURLEnd: String
    let TextField: TextField
    let JsonURLStart: String

}
class FieldValidation {
    var jsonURL = "http://localhost:8080/api/v1/"
    var countValue = -1
    var fieldValid = false
    let rightImageView = UIImageView(frame: CGRect(x: -10,  y:0, width: 20, height: 20))
    var image: UIImage!
    func FieldValidationFunc(FieldProperties: FieldProperties, completion: @escaping (_ fieldValid: Bool) -> ()){
        
        let jsonurl = jsonURL + FieldProperties.JsonURLStart + FieldProperties.FieldValue + FieldProperties.JsonURLEnd
        print(jsonurl)
        guard let url = URL(string: jsonurl) else{
           return}
        let session = URLSession.shared
        
        session.dataTask(with: url) { (data, response, error) in
            guard let response = response else {return}
            
            print(response)
            guard let data = data else{ return}
            print(data)
            do {
                let count = try JSONDecoder().decode(CountResponse1.self, from: data)
                self.countValue = count.count
                print(self.countValue)
                if(self.countValue == 0){
                    self.image = UIImage(named: "bullet-icon")!
                    DispatchQueue.main.async {
                        self.rightImageView.image = self.image
                        let view = UIView(frame: CGRect(x:0,  y:0, width: 20, height: 20))
                        view.addSubview(self.rightImageView)
                        FieldProperties.TextField.rightView = view
                        
                    }
                    
                    self.fieldValid = true
                    print("fieldValid = ", self.fieldValid)
                }
                else{
                    self.image = UIImage(named: "error")!
                    DispatchQueue.main.async { 
                        self.rightImageView.image = self.image
                        let view = UIView(frame: CGRect(x:0,  y:0, width: 20, height: 20))
                        view.addSubview(self.rightImageView)
                        FieldProperties.TextField.rightView = view
                        
                        
                    }
                    self.fieldValid = false
                    print("fieldValid = ", self.fieldValid)
                    
                }
            }
            catch {
                print(error)
            }
            completion(self.fieldValid)
            }.resume()
        print("fieldValid ==== ", fieldValid)
    }
}

