//
//  CreateBudgetViewController.swift
//  Apps Challenge
//
//  Created by Francisco Javier Sarasua Galan on 18/04/2021.
//

import UIKit

class CreateBudgetViewController: UIViewController {
    
    enum PickerState {
        case category
        case subcategory
    }

    //MARK: - IBOutlet
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollViewContent: UIView!
    
    @IBOutlet weak var marginView: UIView!
    
    @IBOutlet weak var lbTitle: UILabel!
    
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var tfName: UITextField!
    
    @IBOutlet weak var lbPhone: UILabel!
    @IBOutlet weak var tfPhone: UITextField!
    
    @IBOutlet weak var lbEmail: UILabel!
    @IBOutlet weak var tfEmail: UITextField!
    
    @IBOutlet weak var lbDescription: UILabel!
    @IBOutlet weak var tfDescription: UITextField!
    
    @IBOutlet weak var lbLocation: UILabel!
    @IBOutlet weak var tfLocation: UITextField!
    
    @IBOutlet weak var tableViewLocation: UITableView!
    
    @IBOutlet weak var lbCategory: UILabel!
    @IBOutlet weak var tfCategory: UITextField!
    
    @IBOutlet weak var lbSubcategory: UILabel!
    @IBOutlet weak var tfSubcategory: UITextField!
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    //MARK: - Constraint
    @IBOutlet weak var heightTableView: NSLayoutConstraint!
    
    //MARK: - Variable
    var keyboardActive: Bool = false
    var pickerActive: Bool = false
    var selectedTextField = UITextField()
    
    let countries: [String] = ["España", "Francia", "Italia", "Alemania", "China"]
    var suppContries: [String] = []
    var tableData: [LocationCellModel] = []
    
    let numbers: [Int] = [0, 1, 2, 3]
    let decimals: [Int:[Double]] = [0:[0.1, 0.2, 0.3], 1:[1.1, 1.2, 1.3], 2:[2.1, 2.2, 2.3], 3:[3.1, 3.2, 3.3]]
    var pickerData: [String] = []
    var pickertState: PickerState = .category
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadData()
        self.loadStyle()
    }
    
    // MARK: - Private method
    private func loadData() {
        // Gesture Recognizer to hide keyboard
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
        
//         Notification Center to configure show / hide keyboard
        let notificationCenter = NotificationCenter.default

        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)

        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // Text Field Name
        self.tfName.delegate = self
        
        // Text Field Phone
        self.tfPhone.delegate = self
        
        // Text Field E-mail
        self.tfEmail.delegate = self
        
        // Text Field Description
        self.tfDescription.delegate = self
        
        // Text Field Location
        self.tfLocation.delegate = self
        self.tfLocation.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        
        // Text Field Category
        self.tfCategory.delegate = self
        self.tfCategory.inputView = self.pickerView
        
        // Text Field Sub-Category
        self.tfSubcategory.delegate = self
        self.tfSubcategory.inputView = self.pickerView
        
        // Table View
        self.tableViewLocation.dataSource = self
        self.tableViewLocation.delegate = self
        self.tableViewLocation.register(Constants.Nib.LocationCell, forCellReuseIdentifier: Constants.Identifier.LocationID)
        
        // Picker View
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
    }
    
    private func loadStyle() {
        
    }
    
    private func touchLocation() {
        self.tableViewLocation.isHidden = !self.tableViewLocation.isHidden || self.tableData.isEmpty
        self.editingChanged(self.selectedTextField)
    }
    
    private func touchCategories() {
        self.loadPickerData()
        self.pickerView.reloadAllComponents()
        self.scrollView.scrollToView(view: self.selectedTextField, animated: true)
    }
    
    private func loadPickerData() {
        
        if self.pickertState == .category {
            self.pickerData = self.numbers.map({ String($0) })
        } else {
            
            guard let text = self.tfCategory.text, let index = Int(text) else {
                return
            }
            self.pickerData = self.decimals[index]?.compactMap({ String($0) }) ?? []
        }
    }
    
    // TODO: Refactor table view logic.
    private func filterCountriesWith(text: String) {
        self.tableData.removeAll()
        
        if text.count != 0 {
            self.suppContries = self.countries.compactMap({ return $0.lowercased().starts(with: text.lowercased()) ? $0 : nil })
        } else {
            self.suppContries = self.countries
        }
    }
    
    private func loadTableData() {
        self.tableData = []
        
        for country in self.suppContries {
            let data = LocationCellModel()
            
            data.title = country
            
            if country == self.suppContries.first {
                data.isFirstItem = true
            }
            self.tableData.append(data)
        }
    }
    
    //MARK: - Actions
    @objc func editingChanged(_ textField: UITextField) {
        
        guard let text = textField.text else {
            return
        }
        self.filterCountriesWith(text: text)
        self.loadTableData()
        
        self.tableViewLocation.isHidden = self.tableData.isEmpty
        
        if !self.tableData.isEmpty {
            
            if tableData.count > 2 {
                self.heightTableView.constant = 135
            } else {
                self.heightTableView.constant = CGFloat(self.tableData.count * 45)
            }
            self.tableViewLocation.reloadData()
        }
    }
    
    @objc func dismissKeyboard() {
        self.tableViewLocation.isHidden = true
        self.view.endEditing(true)
    }
}

extension CreateBudgetViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        if touch.view!.isDescendant(of: self.tableViewLocation) {
            return false
        }
        
        return true
    }
}

extension UIScrollView {
    
    func scrollToView(view: UIView, animated: Bool) {

        if let origin = view.superview {
            let childStartPoint = origin.convert(view.frame.origin, to: self)
            self.scrollRectToVisible(CGRect(x: 0, y: childStartPoint.y, width: 1, height: self.frame.height), animated: animated)
        }
    }
}

extension CreateBudgetViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.selectedTextField = textField
        
        if textField == self.tfLocation {
            self.touchLocation()
        } else if textField == self.tfCategory || textField == self.tfSubcategory {
            self.pickertState = textField == self.tfCategory ? .category : .subcategory
            self.touchCategories()
        }
        
        if self.keyboardActive {
            self.scrollView.scrollToView(view: self.selectedTextField, animated: true)
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
               
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue, !self.keyboardActive else {
            return
        }
        self.keyboardActive = true
        self.scrollView.contentSize.height += keyboardSize.height
        self.scrollView.scrollToView(view: self.selectedTextField, animated: true)
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue, self.keyboardActive else {
            return
        }
        self.keyboardActive = false
        self.scrollView.contentSize.height -= keyboardSize.height
    }
}

extension CreateBudgetViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell: LocationTableViewCell = tableView.dequeueReusableCell(withIdentifier:  Constants.Identifier.LocationID) as? LocationTableViewCell else {
            return UITableViewCell()
        }
        cell.data = self.tableData[indexPath.row]
        cell.loadCell()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 44
    }
}

extension CreateBudgetViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = self.tableData[indexPath.row]
        
        self.tfLocation.text = data.title
        self.dismissKeyboard()
    }
}

extension CreateBudgetViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return self.pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let title = self.pickerData[row]
        
        return title
    }
}

extension CreateBudgetViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if self.pickertState == .category {
            self.tfCategory.text = self.pickerData[row]
            self.tfSubcategory.text?.removeAll()
        } else {
            self.tfSubcategory.text = self.pickerData[row]
        }
        self.dismissKeyboard()
    }
}
