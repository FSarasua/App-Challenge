//
//  ErrorManager.swift
//  Apps Challenge
//
//  Created by Francisco Javier Sarasua Galan on 11/05/2021.
//

import Foundation

struct ErrorManager {
    
    static let sharedInstance = ErrorManager()

    func parseToErrorModel(error: Error?, type: ErrorType) -> ErrorModel {
        let model = ErrorModel()
         
        model.title = Utils.getTitleError(type: type)
        model.type = type
        model.message = error?.localizedDescription ?? ""
        model.debugMessage = error.debugDescription
        
        if let afError = error?.asAFError {
            model.code = afError.responseCode ?? -1
        }
        
        return model
    }
}
