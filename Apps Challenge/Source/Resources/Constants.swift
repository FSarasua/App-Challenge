//
//  Constants.swift
//  Apps Challenge
//
//  Created by Francisco Javier Sarasua Galan on 21/04/2021.
//

import Foundation
import UIKit

struct Constants {
    static let confirm = "OK"
    
    struct URL {
        static let baseURL = "https://api.habitissimo.es/"
    }
    
    struct Module {
        
        struct BudgetList {
            static let title = "Presupuestos"
            static let estimatedHeightRow: CGFloat = 350.0
        }
        
        struct CreateBudget {
            static let requiredPlaceholder = "Requiere una categoría."
            static let chooseSubCatPlaceholder = "Elija una sub-categoría."
        }
    }
    
    struct Cell {
        
        struct Budget {
            static let phoneTitle = "Teléfono: "
            static let emailTitle = "E-mail: "
            static let descriptionTitle = "Descripción:\n"
        }
    }
    
    struct Constraints {
        static let hideBottomPickerValue: CGFloat = -250
        static let showBottomPickerValue: CGFloat = 0
        static let pickerToolbarHeight: CGFloat = 34.0
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
    
    struct Validation {
        static let title = "Validación Incorrecta"
        
        static let nameIsEmpty = "El campo Nombre es requerido.\n"
        
        static let phoneIsEmpty = "El campo Teléfono es requerido.\n"
        static let phoneFormat = "El campo Teléfono debe constar de: Sólo números y 9 dígitos.\n"
        
        static let emailIsEmpty = "El campo E-mail es requerido.\n"
        static let emailFormat = "Formato del campo E-mail no válido.\n"
        
        static let descriptionIsEmpty = "El campo Descripción es requerido.\n"
        
        static let locationIsEmpty = "El campo Ubicación es requerido.\n"
        static let locationNoExists = "La ubicación no existe. Seleccione una ubicación del listado.\n"
        
        static let categoryIsEmpty = "El campo Categoría es requerido.\n"
        
        static let subcategoryIsEmpty = "El campo Sub-Categoría es requerido.\n"
    }
    
    struct Error {
        
        
        static let serviceTitle = "Error de Servicio"
        static let jsonParserTitle = "Error JSON"
        static let defaultTitle = "Error"
    }
}
