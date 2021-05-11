//
//  CreateBudgetViewController.swift
//  Apps Challenge
//
//  Created by Francisco Javier Sarasua Galan on 18/04/2021.
//

import UIKit

protocol CreateBudgetViewProtocol: class {
    func setData(viewModel: CreateBudgetViewModel)
    func showError(_ error: ErrorModel)
    func changeHeightTable(value: CGFloat, animated: Bool)
    func reloadTable(moveToStart: Bool)
    func reloadPicker()
    func loadPickerPosition(text: String)
    func setCategoryText(text: String)
    func setSubcategoryText(text: String)
    func showSubcategorySection()
    func scrollToPresentView(view: UIView, hasToolBar: Bool, animated: Bool)
    func scrollToPresentTableView(hasToolBar: Bool, animated: Bool)
    
    func startLoader()
    func stopLoader()
    
    func showValidationError()
    func returnToBudgetList()
}

class CreateBudgetViewController: UIViewController {

    //MARK: - Components
    @IBOutlet weak var lbTitle: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollViewContent: UIView!
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
    
    @IBOutlet weak var backgroundActivityIndicatorView: UIView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    @IBOutlet var arrayAllTextFields: [UITextField]!
    
    let pickerView: UIPickerView = UIPickerView(frame: CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height / UIDevice.keyboardMultiplier)))
    
    //MARK: - Constraint
    @IBOutlet weak var heightTableView: NSLayoutConstraint!
    
    // MARK: - VIPER
    var presenter: CreateBudgetPresenterProtocol?
    
    //MARK: - Variable
    var keyboardActive: Bool = false
    var selectedTextField = UITextField()
    let viewReferenceToScroll = UIView()
    
    var model = CreateBudgetViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureView()
        self.loadData()
        self.loadStyle()
    }
    
    // MARK: - Private method
    
    private func configureView() {
        self.addGestureRecognizer()
        self.observeKeyboardTransition()
        
        // Navigation Bar
        self.createAddBarButton()
        
        // Table View
        self.tableViewLocation.register(Constants.Nib.LocationCell, forCellReuseIdentifier: Constants.Identifier.LocationID)
        
        // View Reference to Scroll
        self.viewReferenceToScroll.frame = CGRect(x: self.tableViewLocation.frame.origin.x, y: self.tableViewLocation.frame.origin.y, width: self.tableViewLocation.frame.size.width, height: 135.0)
        self.viewReferenceToScroll.backgroundColor = .clear
        self.scrollView.insertSubview(self.viewReferenceToScroll, at: 0)
        
        // Picker View
        self.createToolbarPickerView()
        
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        
        // Text Field Category
        self.tfCategory.inputView = self.pickerView
        
        // Text Field Sub-Category
        self.tfSubcategory.inputView = self.pickerView
    }
    
    private func loadData() {
        self.presenter?.loadData()
        
        // Text Field Name
        self.tfName.restorationIdentifier = TextFieldID.name.rawValue
        
        // Text Field Phone
        self.tfPhone.restorationIdentifier = TextFieldID.phone.rawValue
        
        // Text Field E-mail
        self.tfEmail.restorationIdentifier = TextFieldID.email.rawValue
        
        // Text Field Description
        self.tfDescription.restorationIdentifier = TextFieldID.description.rawValue
        
        // Text Field Location
        self.tfLocation.restorationIdentifier = TextFieldID.location.rawValue
        
        // Text Field Category
        self.tfCategory.restorationIdentifier = TextFieldID.category.rawValue
        
        // Text Field Sub-Category
        self.tfSubcategory.restorationIdentifier = TextFieldID.subcategory.rawValue
        self.tfSubcategory.placeholder = Constants.Module.CreateBudget.requiredPlaceholder
        
        // Constraints
        self.heightTableView.constant = 0.0
    }
    
    private func loadStyle() {
        
        // All Text Fields
        self.arrayAllTextFields.forEach({ $0.loadStyleCreateBudget() })
        
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
    
    private func addGestureRecognizer() {
        // Gesture Recognizer. Hide keyboard.
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        tap.delegate = self
        
        self.view.addGestureRecognizer(tap)
    }
    
    private func observeKeyboardTransition() {
        // Notification Center to control show / hide keyboard.
        let notificationCenter = NotificationCenter.default

        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)

        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func createToolbarPickerView() {
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
        self.tfCategory.inputAccessoryView = toolBar
        
        // Text Field Sub-Category
        self.tfSubcategory.inputAccessoryView = toolBar
        }
    
    private func createAddBarButton() {
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(tapDone))
        
        doneBarButton.tintColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
        
        self.navigationItem.rightBarButtonItem = doneBarButton
    }
    
    private func scrollToStart() {
        self.tableViewLocation.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: false)
    }
    
    //MARK: - Actions
    @IBAction func editingChanged(_ textField: UITextField) {
        
        guard let text = textField.text else { return }
        self.presenter?.filterCurrentLocationsWith(text: text, update: true, animateTable: true)
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
        self.presenter?.animateTable(action: .close, animated: false)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        guard self.presenter?.setKeyboardActive(true) == true else { return }
        
        self.scrollView.contentSize.height += (UIScreen.main.bounds.size.height / UIDevice.keyboardMultiplier)
        
        self.presenter?.scrollToPresentView()
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        
        guard self.presenter?.setKeyboardActive(false) == true else { return }
        
        self.scrollView.contentSize.height -= (UIScreen.main.bounds.size.height / UIDevice.keyboardMultiplier)
    }
    
    @objc func tapDonePicker() {
        let selectedTitle = self.pickerView(self.pickerView, titleForRow: self.pickerView.selectedRow(inComponent: 0), forComponent: 0)
                                   
        self.presenter?.saveOption(text: selectedTitle)
        
        self.dismissKeyboard()
    }
    
    @objc func tapDone() {
        self.presenter?.validateFields(textFields: self.arrayAllTextFields)
    }
}

extension CreateBudgetViewController: CreateBudgetViewProtocol {

    func setData(viewModel: CreateBudgetViewModel) {
        self.model = viewModel
    }
    
    func showError(_ error: ErrorModel) {
        self.presenter?.showError(view: self, error)
    }
    
    func changeHeightTable(value: CGFloat, animated: Bool) {
        self.heightTableView.constant = value
        
        if animated {
            UIView.animate(withDuration: 0) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func reloadTable(moveToStart: Bool) {
        self.tableViewLocation.reloadData()
        
        if moveToStart {
            self.scrollToStart()
        }
    }
    
    func reloadPicker() {
        self.pickerView.reloadAllComponents()
    }
    
    func loadPickerPosition(text: String) {
        let index = self.model.pickerData.firstIndex(of: text) ?? 0
        
        self.pickerView.selectRow(index, inComponent: 0, animated: false)
    }
    
    func setCategoryText(text: String) {
        self.tfCategory.text = text
    }
    
    func setSubcategoryText(text: String) {
        self.tfSubcategory.text = text
    }
    
    func showSubcategorySection() {
        self.lbSubcategory.isUserInteractionEnabled = true
        self.lbSubcategory.alpha = 1.0
        
        self.tfSubcategory.isUserInteractionEnabled = true
        self.tfSubcategory.alpha = 1.0
        self.tfSubcategory.placeholder = Constants.Module.CreateBudget.chooseSubCatPlaceholder
    }
    
    func scrollToPresentView(view: UIView, hasToolBar: Bool, animated: Bool) {
        self.scrollView.scrollTo(view: view, hasToolBar: hasToolBar, animated: animated)
    }
    
    func scrollToPresentTableView(hasToolBar: Bool, animated: Bool) {
        self.scrollToPresentView(view: self.viewReferenceToScroll, hasToolBar: hasToolBar, animated: animated)
    }
    
    func startLoader() {
        self.backgroundActivityIndicatorView.isHidden = false
        self.activityIndicatorView.startAnimating()
    }
    
    func stopLoader() {
        self.backgroundActivityIndicatorView.isHidden = true
        self.activityIndicatorView.stopAnimating()
    }
    
    func showValidationError() {
        self.presenter?.showValidationError(view: self)
    }
    
    func returnToBudgetList() {
        guard let navigation = self.navigationController else { return }
        
        self.presenter?.returnToBudgetList(navigation: navigation)
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
            self.presenter?.animateTable(action: .close, animated: false)
            self.tfCategory.becomeFirstResponder()
        }
        
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.presenter?.select(textField: textField)
        self.presenter?.textFieldDidBeginEditing()
    }
}

extension CreateBudgetViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.model.tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell: LocationTableViewCell = tableView.dequeueReusableCell(withIdentifier:  Constants.Identifier.LocationID) as? LocationTableViewCell else {
            return UITableViewCell()
        }
        cell.data = self.model.tableData[indexPath.row]
        cell.loadCell()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 44
    }
}

extension CreateBudgetViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = self.model.tableData[indexPath.row]
        
        self.tfLocation.text = data.title
        self.dismissKeyboard()
    }
}

extension CreateBudgetViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return self.model.pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let title = self.model.pickerData[row]
        
        return title
    }
}

extension CreateBudgetViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
}
