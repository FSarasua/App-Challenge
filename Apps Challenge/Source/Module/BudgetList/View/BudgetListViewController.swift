//
//  BudgetListViewController.swift
//  Apps Challenge
//
//  Created by Francisco Javier Sarasua Galan on 17/04/2021.
//

import UIKit

protocol BudgetListViewProtocol: class {
    func setData(viewModel: BudgetListViewModel)
    func emptyView(isHidden: Bool)
}

class BudgetListViewController: UIViewController {

    // MARK: - Components
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var imgBackground: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var viewEmpty: UIView!
    @IBOutlet weak var lbEmptyMessage: UILabel!
    
    // MARK: - VIPER
    var presenter: BudgetListPresenterProtocol?
    
    // MARK: - Variables
    var model = BudgetListViewModel()
    
    // MARK: - Lyfe Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureView()
        self.loadData()
        self.loadStyle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.presenter?.reloadData()
    }
    
    //MARK: - Private Methods
    private func configureView() {
        // TableView
        self.tableView.register(Constants.Nib.BudgetCell, forCellReuseIdentifier: Constants.Identifier.BudgetID)
        
        // NavigationBar
        self.createAddButton()
        self.createRemoveButton()
    }
    
    private func loadData() {
        self.presenter?.loadData()
        
        // NavigationBar
        self.title = Constants.Module.BudgetList.title
    }
    
    private func loadStyle() {
        // Navigation bar
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)]
        self.setTransparencyNavigationBar()
        
        // View Empty
        self.viewEmpty.isHidden = true

    }
    
    private func createAddButton() {
        let addButton = UIButton(type: .custom)
        
        addButton.setImage(#imageLiteral(resourceName: "addImage"), for: .normal)
        addButton.addTarget(self, action: #selector(goToCreateBudget), for: .touchUpInside)
        
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView:  addButton)
    }
    
    private func createRemoveButton() {
        let removeButton = UIButton(type: .custom)
        
        removeButton.addTarget(self, action: #selector(goToCreateBudget), for: .touchUpInside)
        
        let barButton = UIBarButtonItem(image: .remove, style: .done, target: self, action: #selector(removeDataTable))
        
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    private func setTransparencyNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    
    // MARK: - Actions
    @objc func goToCreateBudget() {
        
        guard let navigation = self.navigationController else { return }
        
        self.presenter?.goToCreateBudget(navigation: navigation)
    }
    
    @objc func removeDataTable() {
        self.presenter?.removeDataTable()
    }
}

extension BudgetListViewController: BudgetListViewProtocol {
    
    func setData(viewModel: BudgetListViewModel) {
        self.model = viewModel
        self.tableView.reloadData()
    }
    
    func emptyView(isHidden: Bool) {
        self.viewEmpty.isHidden = isHidden
    }
}

extension BudgetListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.model.cellModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell: BudgetTableViewCell = tableView.dequeueReusableCell(withIdentifier:  Constants.Identifier.BudgetID) as? BudgetTableViewCell else {
            return UITableViewCell()
        }
        cell.data = self.model.cellModels[indexPath.row]
        
        cell.loadCell()
        
        return cell
    }
}

extension BudgetListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return Constants.Module.BudgetList.estimatedHeightRow
    }
}
