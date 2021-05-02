//
//  Constants.swift
//  Apps Challenge
//
//  Created by Francisco Javier Sarasua Galan on 21/04/2021.
//

import Foundation
import UIKit

struct Constants {
    
    struct URL {
        static let baseURL = "https://api.habitissimo.es/"
    }
    
    struct Module {
        
        struct BudgetList {
            static let title = "Presupuestos"
        }
        
        struct CreateBudget {
            static let requiredPlaceholder = "Requiere una categoría."
            static let chooseSubCatPlaceholder = "Elija una sub-categoría."
        }
    }
    
    struct Constraints {
        static let hideBottomPickerValue: CGFloat = -250
        static let showBottomPickerValue: CGFloat = 0
    }
    
    struct Nib {
        static let BudgetCell: UINib = UINib(nibName: "BudgetTableViewCell", bundle: nil)
        static let LocationCell: UINib = UINib(nibName: "LocationTableViewCell", bundle: nil)
    }
    
    struct Identifier {
        static let BudgetID = "BudgetCellID"
        static let LocationID = "LocationCellID"
    }
    
    struct Endpoint {
        static let location = "location/list"
        static let category = "category/list/"
    }
    
    struct Database {
        static let name = "Apps_Challenge"
    }
}
