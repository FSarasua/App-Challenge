//
//  ErrorModel.swift
//  Apps Challenge
//
//  Created by Francisco Javier Sarasua Galan on 11/05/2021.
//

import Foundation

class ErrorModel {
    
    var title: String
    var message: String
    var debugMessage: String
    var code: Int
    var type: ErrorType
    
    init() {
        self.title = ""
        self.message = ""
        self.debugMessage = ""
        self.code = -1
        self.type = .none
    }
    
    internal init(title: String? = nil, message: String? = nil, debugMessage: String? = nil, code: Int? = nil, type: ErrorType) {
        
        self.title = title ?? ""
        self.message = message  ?? ""
        self.debugMessage = debugMessage ?? ""
        self.code = code ?? -1
        self.type = type
    }
}
