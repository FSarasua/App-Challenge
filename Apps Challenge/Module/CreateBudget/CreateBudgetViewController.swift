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
        
        // Gesture Recognizer to hide keyboard.
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
        
        // Notification Center to control show / hide keyboard.
        let notificationCenter = NotificationCenter.default

        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)

        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // Navigation Bar
        self.createAddBarButton()
        
        // Table View
        self.tableViewLocation.register(Constants.Nib.LocationCell, forCellReuseIdentifier: Constants.Identifier.LocationID)
        
        // Picker View
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        
        // Toolbar Picker View.
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.pickerView.frame.width, height: 44.0))
        
        toolBar.autoresizingMask = .flexibleHeight
        toolBar.barStyle = .default
        toolBar.isTranslucent = false
        toolBar.isUserInteractionEnabled = true
        toolBar.tintColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
        toolBar.barTintColor = .systemGray5

        let btnDone = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(tapDonePicker))
        let btnSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let btnCancel = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(dismissKeyboard))

        toolBar.items = [btnCancel, btnSpace, btnDone]
        
        // Text Field Category
        self.tfCategory.inputView = self.pickerView
        self.tfCategory.inputAccessoryView = toolBar
        
        // Text Field Sub-Category
        self.tfSubcategory.placeholder = Constants.Module.CreateBudget.requiredPlaceholder
        self.tfSubcategory.inputView = self.pickerView
        self.tfSubcategory.inputAccessoryView = toolBar
        
        // Constraints
        self.heightTableView.constant = 0.0
    }
    
    private func loadStyle() {
        
        // Label Sub-Category
        self.lbSubcategory.isUserInteractionEnabled = false
        self.lbSubcategory.alpha = 0.6
        
        // Text Field Sub-Category
        self.tfSubcategory.isUserInteractionEnabled = false
        self.tfSubcategory.alpha = 0.6
        
        // Table View
        self.tableViewLocation.layer.borderWidth = 2.0
        self.tableViewLocation.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    
    private func createAddBarButton() {
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(tapDone))
        
        doneBarButton.tintColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
        
        self.navigationItem.rightBarButtonItem = doneBarButton
    }
    
    private func touchLocation() {
        self.editingChanged(self.selectedTextField)
    }
    
    // TODO: Refactor.
    private func touchCategories() {
        self.loadPickerData()
        self.pickerView.reloadAllComponents()
        
        let text = self.selectedTextField.text ?? ""
        let index = self.pickerData.firstIndex(of: text) ?? 0
        self.pickerView.selectRow(index, inComponent: 0, animated: false)
    }
    
    // TODO: Refactor Structure. Presenter.
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
    
    // TODO: Refactor Structure. Presenter.
    private func filterCountriesWith(text: String) {
        self.tableData.removeAll()
        
        if text.count != 0 {
            self.suppContries = self.countries.compactMap({ return $0.lowercased().starts(with: text.lowercased()) ? $0 : nil })
        } else {
            self.suppContries = self.countries
        }
    }
    
    // TODO: Refactor Structure. Presenter.
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
    
    // TODO: Refactor.
    private func loadTableHeight(value: CGFloat? = nil) {
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
    @IBAction func editingChanged(_ textField: UITextField) {
        
        guard let text = textField.text else {
            return
        }
        self.filterCountriesWith(text: text)
        self.loadTableData()
        
        if self.tableData.isEmpty {
            self.loadTableHeight(value: 0.0)
        } else {
            self.loadTableHeight()
            self.tableViewLocation.reloadData()
            self.tableViewLocation.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: false)
        }
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
        self.loadTableHeight(value: 0.0)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if !self.keyboardActive {
            self.keyboardActive = true
            self.scrollView.contentSize.height += (UIScreen.main.bounds.size.height / 2.59)
            
            switch self.selectedTextField {
            case self.tfLocation:
                guard let spaceViewToPresent = self.tableViewLocation else { return }
                
                let tableViewTotal = CGRect(x: self.tableViewLocation.frame.origin.x, y: self.tableViewLocation.frame.origin.y, width: self.tableViewLocation.frame.size.width, height: 135.0)
                spaceViewToPresent.frame = tableViewTotal
                
                self.scrollView.scrollToPresentView(view: spaceViewToPresent, hasToolBar: false, animated: true)
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
            self.scrollView.contentSize.height -= (UIScreen.main.bounds.size.height / 2.59)
        }
    }
    
    @objc func tapDonePicker() {
        self.dismissKeyboard()
        
        guard let text = self.pickerView(self.pickerView, titleForRow: self.pickerView.selectedRow(inComponent: 0), forComponent: 0) else {

            return
        }
        
        if self.pickertState == .category {
            self.tfCategory.text = text
            
            if self.tfCategory.text != "" {
                self.lbSubcategory.isUserInteractionEnabled = true
                self.lbSubcategory.alpha = 1.0
                
                self.tfSubcategory.isUserInteractionEnabled = true
                self.tfSubcategory.alpha = 1.0
                self.tfSubcategory.placeholder = Constants.Module.CreateBudget.chooseSubCatPlaceholder
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
            let startPointY = origin.convert(view.frame.origin, to: self).y
            let keyboardHeight = (UIScreen.main.bounds.size.height / 2.59) + (hasToolBar ? 34.0 : 0)
            let marginBottom: CGFloat = 16.0
            let restFrameY = self.frame.height - keyboardHeight
            
            var newY = startPointY + view.frame.height + marginBottom - restFrameY
            
            if newY < 0 {
                newY = 0.0
            }
            
            UIView.animate(withDuration: 0.6) {
                self.contentOffset = CGPoint(x: self.contentOffset.x, y: newY)
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
            self.loadTableHeight(value: 0.0)
            self.tfCategory.becomeFirstResponder()
        }
        
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.selectedTextField = textField
        
        switch textField {
        case self.tfLocation:
            self.touchLocation()
            
            guard let spaceViewToPresent = self.tableViewLocation else { return }
            
            spaceViewToPresent.frame = CGRect(x: self.tableViewLocation.frame.origin.x, y: self.tableViewLocation.frame.origin.y, width: self.tableViewLocation.frame.size.width, height: 135.0)
            
            _ = self.keyboardActive ? self.scrollView.scrollToPresentView(view: spaceViewToPresent, hasToolBar: false, animated: true) : nil
            break
        case self.tfCategory, self.tfSubcategory:
            _ = self.heightTableView.constant > 0.0 ? self.loadTableHeight(value: 0.0) : nil
            
            self.pickertState = textField == self.tfCategory ? .category : .subcategory
            
            self.touchCategories()
            
            _ = self.keyboardActive ? self.scrollView.scrollToPresentView(view: textField, hasToolBar: true, animated: true) : nil
            break
        default:
            _ = self.heightTableView.constant > 0.0 ? self.loadTableHeight(value: 0.0) : nil
            _ = self.keyboardActive ? self.scrollView.scrollToPresentView(view: textField, hasToolBar: false, animated: true) : nil
            
            break
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
