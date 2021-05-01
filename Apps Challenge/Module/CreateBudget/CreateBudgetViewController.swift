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

    //MARK: - Components
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
    
    let pickerView: UIPickerView = UIPickerView(frame: CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height / 2.59)))
    
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
        
//      Notification Center to configure show / hide keyboard
        let notificationCenter = NotificationCenter.default

        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)

        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // Toolbar Picker View
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.pickerView.frame.width, height: 44.0))
        
        toolBar.autoresizingMask = .flexibleHeight
        toolBar.barStyle = .default
        toolBar.isTranslucent = false
        toolBar.isUserInteractionEnabled = true
        toolBar.tintColor = .systemBlue
        toolBar.barTintColor = .systemGray5

        let btnDone = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(tapDonePicker))
        let btnSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let btnCancel = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(dismissKeyboard))

        toolBar.items = [btnCancel, btnSpace, btnDone]
        
        // Navigation Bar
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(tapDone))
        
        doneBarButton.tintColor = .systemBlue
        
        self.navigationItem.rightBarButtonItem = doneBarButton

        // Picker View
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        
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
        self.tfCategory.inputAccessoryView = toolBar
        
        // Label Sub-Category
        self.lbSubcategory.isHidden = true
        
        // Text Field Sub-Category
        self.tfSubcategory.delegate = self
        self.tfSubcategory.inputView = self.pickerView
        self.tfSubcategory.inputAccessoryView = toolBar
        self.tfSubcategory.isHidden = true
        
        // Table View
        self.tableViewLocation.dataSource = self
        self.tableViewLocation.delegate = self
        self.tableViewLocation.register(Constants.Nib.LocationCell, forCellReuseIdentifier: Constants.Identifier.LocationID)
        
        // Constraints
        self.heightTableView.constant = 0.0
    }
    
    private func loadStyle() {
        self.tableViewLocation.layer.borderWidth = 2.0
        self.tableViewLocation.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    
    private func touchLocation() {
        self.editingChanged(self.selectedTextField)
    }
    
    private func touchCategories() {
        self.loadPickerData()
        self.pickerView.reloadAllComponents()
        
        let text = self.selectedTextField.text ?? ""
        let index = self.pickerData.firstIndex(of: text) ?? 0
        self.pickerView.selectRow(index, inComponent: 0, animated: false)
    }
    
    private func loadPickerData() {
        
        if self.pickertState == .category {
            self.pickerData = self.numbers.map({ String($0) })
        } else {
            
            guard let text = self.tfCategory.text, let index = Int(text) else {
                self.pickerData = []
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
            
            if country == self.suppContries.last {
                data.isLastItem = true
            }
            self.tableData.append(data)
        }
    }
    
    private func loadTableHeight(with value: CGFloat? = nil) {
        var newHeight: CGFloat = 135.0
        
        if let height = value {
            newHeight = height
        } else if tableData.count <= 2 {
            newHeight = CGFloat(self.tableData.count * 45)
        }
        self.heightTableView.constant = newHeight
        
        UIView.animate(withDuration: 0) {
            self.view.layoutIfNeeded()
        }
    }
    
    //MARK: - Actions
    @objc func editingChanged(_ textField: UITextField) {
        
        guard let text = textField.text else {
            return
        }
        self.filterCountriesWith(text: text)
        self.loadTableData()
        
        if self.tableData.isEmpty {
            self.loadTableHeight(with: 0.0)
        } else {
            self.loadTableHeight()
            self.tableViewLocation.reloadData()
            self.tableViewLocation.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: false)
        }
    }
    
    @objc func dismissKeyboard() {
        self.loadTableHeight(with: 0.0)
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if !self.keyboardActive {
            self.keyboardActive = true
            self.scrollView.contentSize.height += UIScreen.main.bounds.size.height / 2.59
            
            switch self.selectedTextField {
            case self.tfLocation:
                self.scrollView.scrollToPresentView(view: self.tableViewLocation, hasToolBar: false, animated: true)
                break
            case self.tfCategory, self.tfSubcategory:
                self.scrollView.scrollToPresentView(view: self.selectedTextField, hasToolBar: true, animated: true)
                break
            default:
                self.scrollView.scrollToPresentView(view: self.selectedTextField, hasToolBar: false, animated: true)
                break
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        
        if self.keyboardActive {
            self.keyboardActive = false
            self.scrollView.contentSize.height -= UIScreen.main.bounds.size.height / 2.59
        }
    }
    
    @objc func tapDonePicker() {
        self.dismissKeyboard()
        
        guard let text = self.pickerView(self.pickerView, titleForRow: self.pickerView.selectedRow(inComponent: 0), forComponent: 0) else {

            return
        }
        
        if self.pickertState == .category {
            self.tfCategory.text = text
            
            if self.tfSubcategory.isHidden && self.tfCategory.text != "" {
                self.lbSubcategory.isHidden = false
                self.tfSubcategory.isHidden = false
            } else {
                self.tfSubcategory.text?.removeAll()
            }
        } else {
            self.tfSubcategory.text = text
        }
    }
    
    @objc func tapDone() {
        // Save the new budget
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
    
    func scrollToPresentView(view: UIView, hasToolBar: Bool, animated: Bool) {

        if let origin = view.superview {
            var newYPosition = CGPoint(x: 0, y: 0)
            let startPointY = origin.convert(view.frame.origin, to: self).y
            var keyboardHeight = UIScreen.main.bounds.size.height / 2.59
            keyboardHeight += hasToolBar ? 44.0 : 0
            let extraMargin: CGFloat = 16.0
            
            let restFrameY = self.frame.height - keyboardHeight
            
            if startPointY + view.frame.height + extraMargin > restFrameY {
                newYPosition = CGPoint(x: self.contentOffset.x, y: startPointY + view.frame.height + extraMargin - restFrameY )
            }
            
            UIView.animate(withDuration: 0.6) {
                self.contentOffset = newYPosition
                self.layoutIfNeeded()
            }
        }
    }
}

extension CreateBudgetViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == self.tfName {
            self.tfPhone.becomeFirstResponder()
        } else if textField == self.tfPhone {
            self.tfEmail.becomeFirstResponder()
        } else if textField == self.tfEmail {
            self.tfDescription.becomeFirstResponder()
        } else if textField == self.tfDescription {
            self.tfLocation.becomeFirstResponder()
        } else if textField == self.tfLocation {
            self.loadTableHeight(with: 0.0)
            self.tfCategory.becomeFirstResponder()
        }
        
        // TODO: Those components hasn't "intro" key to return. We have to control this by other way.
//        else if textField == self.tfCategory {
//            self.tfSubcategory.becomeFirstResponder()
//        } else if textField == self.tfSubcategory {
//            self.view.endEditing(true)
//        }
        
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.selectedTextField = textField
        
        if textField == self.tfLocation {
            self.touchLocation()
        } else {
            self.loadTableHeight(with: 0.0)
            
            if textField == self.tfCategory || textField == self.tfSubcategory {
                self.pickertState = textField == self.tfCategory ? .category : .subcategory
                self.touchCategories()
            }
        }
        
        if self.keyboardActive {
            
            switch textField {
            case self.tfLocation:
                self.scrollView.scrollToPresentView(view: self.tableViewLocation, hasToolBar: false, animated: true)
                break
            case self.tfCategory, self.tfSubcategory:
                self.scrollView.scrollToPresentView(view: textField, hasToolBar: true, animated: true)
                break
            default:
                self.scrollView.scrollToPresentView(view: textField, hasToolBar: false, animated: true)
                break
            }
        }
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
        
    }
}
