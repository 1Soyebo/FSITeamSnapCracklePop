//
//  File.swift
//  Loanus
//
//  Created by Ibukunoluwa Soyebo on 28/09/2020.
//

import Foundation
import UIKit
import PKHUD

class HelperClass {
    static let baseURL = "https://sandboxapi.fsi.ng"
    static let sandBoxKey = "df2ada6175b75a5190191de5a04b1bf6"
    
    
    static func displayErrorMessageAsAlert(viewcontroller:UIViewController, errorMessage:String){
        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
        viewcontroller.present(alert, animated: true, completion: ({
          HUD.hide()
        }))
        
    }
    
    static func validate(value: String) -> Bool {
        let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result = phoneTest.evaluate(with: value)
        return result
    }
}
