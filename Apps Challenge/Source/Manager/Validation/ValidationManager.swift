//
//  ValidationManager.swift
//  Apps Challenge
//
//  Created by Francisco Javier Sarasua Galan on 11/05/2021.
//

import Foundation

struct ValidationManager {
    
    static let sharedInstance = ValidationManager()
    
    func isEmpty(text: String?, idTextField: TextFieldID) -> (Bool, String, String) {
        
        guard let text = text else { return (false, "", "") }
        
        if text.count == 0 {
            
            return (false, Utils.getValidationText(idTextField: idTextField), "")
        }
        
        return (true, "", text)
    }

    func validatePhoneNumber(text: String?) -> (Bool, String, Int32) {
        
        guard let text = text else { return (false, Constants.Validation.phoneIsEmpty, -1) }
        
        let phone = Int32(text) ?? -1
        
        if phone == -1 || text.count != 9 {
            return (false, Constants.Validation.phoneFormat, phone)
        }
        
        return (true, "", phone)
    }
    
    func validateEmail(_ text: String?) -> (Bool, String, String) {
        
        guard let email = text else { return (false, Constants.Validation.emailFormat, "") }
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        if !emailPred.evaluate(with: text) {
            return (false, Constants.Validation.emailFormat, "")
        }
        
        return (true, "", email)
    }
    
    func validateLocation(text: String?, locations: [String]) -> (Bool, String, String) {
        
        guard let location = text else { return (false, Constants.Validation.locationIsEmpty, "") }
        
        if !locations.contains(location) {
            return (false, Constants.Validation.locationNoExists, "")
        }
        
        return (true, "", location)
    }
}
