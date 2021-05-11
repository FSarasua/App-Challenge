//
//  Enums.swift
//  Apps Challenge
//
//  Created by Francisco Javier Sarasua Galan on 03/05/2021.
//

import Foundation

enum MoveTable {
    case open
    case close
}

enum PickerState {
    case category
    case subcategory
}

enum TextFieldID: String {
    case name
    case phone
    case email
    case description
    case location
    case category
    case subcategory
}

enum ErrorType: String {
    case service
    case JSONParser
    case none
}
