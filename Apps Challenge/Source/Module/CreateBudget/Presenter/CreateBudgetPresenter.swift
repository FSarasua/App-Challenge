//
//  CreateBudgetPresenter.swift
//  Apps Challenge
//
//  Created by Francisco Javier Sarasua Galan on 03/05/2021.
//

import Foundation
import UIKit

protocol CreateBudgetPresenterProtocol: class {
    func loadData()
    func filterCurrentLocationsWith(text: String, update: Bool, animateTable: Bool)
    func loadPickerData(update: Bool)
    
    func showError(view: UIViewController, _ error: ErrorModel)
    
    func animateTable(action: MoveTable, animated: Bool)
    
    func select(textField: UITextField?)
    func textFieldDidBeginEditing()
    
    func changePickerState(state: PickerState)
    func saveOption(text: String?)
    
    func setKeyboardActive(_ value: Bool) -> Bool
    
    func scrollToPresentView()
    
    func validateFields(textFields: [UITextField])
    func showValidationError(view: UIViewController)
    
    func returnToBudgetList(navigation: UINavigationController)
}

protocol CreateBudgetInteractorOutputProtocol: class {
    func setLocationData(serverModel: [LocationServerModel])
    func setCategoryData(serverModel: [CategoryServerModel])
    func setSubcategoryData(serverModel: [SubcategoryServerModel], index: String)
    func setError(error: ErrorModel)
    
    func budgetCreated()
}

class CreateBudgetPresenter {
    weak var view: CreateBudgetViewProtocol?
    var interactor: CreateBudgetInteractorInputProtocol?
    var router: CreateBudgetRouterProtocol?
    
    // MARK: - Variables
    var pickerState: PickerState = .category
    var selectedIDCategory: String?
    var selectedTextField: UITextField?
    var currentTextLocation: String = ""
    var heightTable: CGFloat = 0.0
    var keyboardActive: Bool = false
    
    var validationMessage = ""
    
    var businessModel = CreateBudgetBusinessModel()
    var viewModel = CreateBudgetViewModel()
    var errorModel = ErrorModel()
    
    var endLocationRequest = false
    var endCategoryRequest = false
    
    // MARK: - Private Methods
    
    private func checkDidLoad() {
        
        if self.endLocationRequest && self.endCategoryRequest {
            self.filterCurrentLocationsWith(text: self.currentTextLocation, update: false, animateTable: false)
            self.loadPickerData(update: false)
            self.view?.setData(viewModel: self.viewModel)
            self.view?.stopLoader()
        }
    }
    
    private func checkCurrentCategoryID(idSelected: String) -> Bool {
        
        return self.selectedIDCategory != idSelected
    }
    
    private func loadSubcategoryData(idCategory: String) {
        self.selectedIDCategory = idCategory
        self.view?.startLoader()
        self.interactor?.getSubcategoryData(idCategory: idCategory)
    }
}

extension CreateBudgetPresenter: CreateBudgetPresenterProtocol {
    
    func loadData() {
        self.view?.startLoader()
        self.interactor?.getLocationData()
        self.interactor?.getCategoryData()
    }
    
    func filterCurrentLocationsWith(text: String, update: Bool, animateTable: Bool) {
        self.currentTextLocation = text
        
        if text.count != 0 {
            self.viewModel.tableData = self.businessModel.completeLocationCellModels.compactMap({ return $0.title.lowercased().starts(with: text.lowercased()) ? $0 : nil })
        } else {
            self.viewModel.tableData = self.businessModel.completeLocationCellModels
        }
        
        if update {
            self.view?.setData(viewModel: self.viewModel)
        }
        
        if animateTable {
            
            if self.viewModel.tableData.isEmpty {
                self.animateTable(action: .close, animated: false)
            } else {
                self.animateTable(action: .open, animated: false)
                self.view?.reloadTable(moveToStart: true)
            }
        }
    }
    
    func loadPickerData(update: Bool = false) {
        var newData: [String]
        
        switch self.pickerState {
        case .category:
            newData = self.businessModel.categoryCellModels.map({ $0.title })
            break
        case .subcategory:
            newData = self.businessModel.subcategoryCellModels.map({ $0.title })
            break
        }
        self.viewModel.pickerData = newData
        
        if update {
            self.view?.setData(viewModel: self.viewModel)
            self.view?.reloadPicker()
            
            guard let textField = self.selectedTextField, let text = textField.text else { return }
            
            self.view?.loadPickerPosition(text: text)
        }
    }
    
    func showError(view: UIViewController, _ error: ErrorModel) {
        self.router?.showError(view: view, error)
    }
    
    func animateTable(action: MoveTable, animated: Bool) {
        
        switch action {
        case .open:
            self.heightTable = self.viewModel.tableData.count <= 2 ? CGFloat(self.viewModel.tableData.count * 45) : 135
            break
        case .close:
            
            if self.heightTable == 0.0 { return }
            
            self.heightTable = 0.0
            break
        }
        self.view?.changeHeightTable(value: self.heightTable, animated: animated)
    }
    
    func changePickerState(state: PickerState) {
        self.pickerState = state
    }
    
    func select(textField: UITextField?) {
        self.selectedTextField = textField
    }
    
    func saveOption(text: String?) {
        
        guard let text = text, text != "" else { return }
        
        switch self.pickerState {
        case .category:
            guard let category = self.businessModel.categoryCellModels.first(where: { $0.title == text }) else { return }
            
            self.view?.setCategoryText(text: text)
            
            if text != "" {
                self.view?.showSubcategorySection()
            }
            
            if self.checkCurrentCategoryID(idSelected: category.idCategory) {
                self.loadSubcategoryData(idCategory: category.idCategory)
                self.view?.setSubcategoryText(text: "")
            }
            break
        case .subcategory:
            self.view?.setSubcategoryText(text: text)
            break
        }
    }
    
    func setKeyboardActive(_ value: Bool) -> Bool {
        guard self.keyboardActive != value else { return false }
        
        self.keyboardActive = value
        
        return true
    }
    
    func textFieldDidBeginEditing() {
        
        guard let textField = self.selectedTextField, let text = textField.text else { return }
        
        switch textField.restorationIdentifier {
        case TextFieldID.location.rawValue:
            self.filterCurrentLocationsWith(text: text, update: true, animateTable: true)
            break
        case TextFieldID.category.rawValue:
            self.animateTable(action: .close, animated: false)
            
            self.changePickerState(state: .category)
            self.loadPickerData(update: true)
            break
        case TextFieldID.subcategory.rawValue:
            self.animateTable(action: .close, animated: false)
            
            self.changePickerState(state: .subcategory)
            self.loadPickerData(update: true)
            break
        default:
            self.animateTable(action: .close, animated: false)
            break
        }
        self.scrollToPresentView()
    }
    
    func scrollToPresentView() {
        
        guard let textField = self.selectedTextField, self.keyboardActive else { return }
        
        switch textField.restorationIdentifier {
        case TextFieldID.location.rawValue:
            self.view?.scrollToPresentTableView(hasToolBar: false, animated: true)
            break
        case TextFieldID.category.rawValue:
            self.view?.scrollToPresentView(view: textField, hasToolBar: true, animated: true)
            break
        case TextFieldID.subcategory.rawValue:
            self.view?.scrollToPresentView(view: textField, hasToolBar: true, animated: true)
            break
        default:
            self.view?.scrollToPresentView(view: textField, hasToolBar: false, animated: true)
            break
        }
    }
    
    func validateFields(textFields: [UITextField]) {
        var areFieldsValid = true
        self.validationMessage = ""
        
        var name = "", email = "", definition = "", location = "", subcategory = ""
        var phone: Int32 = -1
        
        var fieldValid: Bool
        var fieldMessage: String
        
        for textField in textFields {
            fieldValid = true
            fieldMessage = ""
            
            switch textField.restorationIdentifier {
            case TextFieldID.name.rawValue:
                (fieldValid, fieldMessage, name) = ValidationManager.sharedInstance.isEmpty(text: textField.text, idTextField: .name)
                break
            case TextFieldID.phone.rawValue:
                (fieldValid, fieldMessage, _) = ValidationManager.sharedInstance.isEmpty(text: textField.text, idTextField: .phone)
                
                if !fieldValid { break }
                
                (fieldValid, fieldMessage, phone) = ValidationManager.sharedInstance.validatePhoneNumber(text: textField.text)
                break
            case TextFieldID.email.rawValue:
                (fieldValid, fieldMessage, _) = ValidationManager.sharedInstance.isEmpty(text: textField.text, idTextField: .email)
                
                if !fieldValid { break }
                
                (fieldValid, fieldMessage, email) = ValidationManager.sharedInstance.validateEmail(textField.text)
                break
                
            case TextFieldID.description.rawValue:
                (fieldValid, fieldMessage, definition) = ValidationManager.sharedInstance.isEmpty(text: textField.text, idTextField: .description)
                break
                
            case TextFieldID.location.rawValue:
                (fieldValid, fieldMessage, location) = ValidationManager.sharedInstance.isEmpty(text: textField.text, idTextField: .location)
                
                if !fieldValid { break }
                
                (fieldValid, fieldMessage, location) = ValidationManager.sharedInstance.validateLocation(text: textField.text, locations: self.viewModel.tableData.map({$0.title}))
                break
                
            case TextFieldID.category.rawValue:
                (fieldValid, fieldMessage, _) = ValidationManager.sharedInstance.isEmpty(text: textField.text, idTextField: .category)
                break
                
            case TextFieldID.subcategory.rawValue:
                (fieldValid, fieldMessage, subcategory) = ValidationManager.sharedInstance.isEmpty(text: textField.text, idTextField: .subcategory)
                break
            default:
                break
            }
            areFieldsValid = areFieldsValid ? fieldValid : false
            self.validationMessage += fieldMessage
        }
        
        if areFieldsValid {
            self.interactor?.createNewBudget(name: name, phone: phone, email: email, definition: definition, location: location, subcategory: subcategory)
        } else {
            self.view?.showValidationError()
        }
    }
    
    func showValidationError(view: UIViewController) {
        self.router?.showErrorValidation(view: view, message: self.validationMessage)
    }
    
    func returnToBudgetList(navigation: UINavigationController) {
        self.router?.returnToBudgetList(navigation: navigation)
    }
}

extension CreateBudgetPresenter: CreateBudgetInteractorOutputProtocol {
    
    func setLocationData(serverModel: [LocationServerModel]) {
        var arrayLocationCellModels = [LocationCellModel]()
        var isLastItem: Bool
        
        for location in serverModel {
            isLastItem = location.idLocation == serverModel.last?.idLocation
            arrayLocationCellModels.append(LocationCellModel(serverModel: location, isLastItem: isLastItem))
        }
        self.businessModel.completeLocationCellModels = arrayLocationCellModels
        
        self.endLocationRequest = true
        self.checkDidLoad()
    }
    
    func setCategoryData(serverModel: [CategoryServerModel]) {
        var arrayCategoryCellModels = [CategoryPickerModel]()
        
        for category in serverModel {
            arrayCategoryCellModels.append(CategoryPickerModel(serverModel: category))
        }
        self.businessModel.categoryCellModels = arrayCategoryCellModels
        
        self.endCategoryRequest = true
        self.checkDidLoad()
    }
    
    func setSubcategoryData(serverModel: [SubcategoryServerModel], index: String) {
        var arraySubcategoryCellModels = [SubcategoryPickerModel]()
        
        for subcategory in serverModel {
            arraySubcategoryCellModels.append(SubcategoryPickerModel(serverModel: subcategory))
        }
        self.businessModel.subcategoryCellModels = arraySubcategoryCellModels
        self.view?.stopLoader()
    }
    
    func setError(error: ErrorModel) {
        self.errorModel = error
        self.view?.showError(error)
        self.view?.stopLoader()
    }
    
    func budgetCreated() {
        self.view?.returnToBudgetList()
    }
}
