//
//  Utils.swift
//  Apps Challenge
//
//  Created by Francisco Javier Sarasua Galan on 11/05/2021.
//

import Foundation

class Utils {
    
    static func getValidationText(idTextField: TextFieldID) -> String {
        
        switch idTextField {
        case .name:
            return Constants.Validation.nameIsEmpty
            
        case .phone:
            return Constants.Validation.phoneIsEmpty
            
        case .email:
            return Constants.Validation.emailIsEmpty
            
        case .description:
            return Constants.Validation.descriptionIsEmpty
            
        case .location:
            return Constants.Validation.locationIsEmpty
            
        case .category:
            return Constants.Validation.categoryIsEmpty
            
        case .subcategory:
            return Constants.Validation.subcategoryIsEmpty
        }
    }
    
    static func getTitleError(type: ErrorType) -> String {
        switch type {
        case .service:
            return Constants.Error.serviceTitle
            
        case .JSONParser:
            return Constants.Error.jsonParserTitle
            
        default:
            return Constants.Error.defaultTitle
        }
    }
}
