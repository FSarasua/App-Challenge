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
    }
    
    struct Constraints {
        static let hideBottomPickerValue: CGFloat = -250
        static let showBottomPickerValue: CGFloat = 0
    }
    
    struct Nib {
        static let BudgetCell: UINib = UINib(nibName: "BudgetTableViewCell", bundle: nil)
    }
    
    struct Identifier {
        static let BudgetID = "BudgetCellID"
    }
    
    struct Image {
        static let addImage = UIImage(named: "addImage")
    }
    
    struct Endpoint {
        static let location = "location/list"
        static let category = "category/list/"
    }
}
