//
//  BudgetListViewController.swift
//  Apps Challenge
//
//  Created by Francisco Javier Sarasua Galan on 17/04/2021.
//

import UIKit

protocol BudgetListViewProtocol {
    func results(model: BudgetListModel)
}

class BudgetListViewController: UIViewController {

    // MARK: - Components
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var imgBackground: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - VIPER
    var presenter: BudgetListPresenterProtocol?
    
    // MARK: - Variables
    var model = BudgetListModel()
    
    // MARK: - Lyfe Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadData()
        self.loadStyle()
    }
    
    //MARK: - Private Methods
    private func loadData() {
        // TableView        
        self.tableView.register(Constants.Nib.BudgetCell, forCellReuseIdentifier: Constants.Identifier.BudgetID)
        
        // NavigationBar
        self.title = Constants.Module.BudgetList.title
        self.createAddButton()
        
        // Load Table Data
        self.presenter?.loadDataTable()
    }
    
    private func loadStyle() {
        self.transparentNavigationBar()
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
    
    private func transparentNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    
    // MARK: - Actions
    @objc func goToCreateBudget() {
        self.navigationController?.pushViewController(CreateBudgetViewController(), animated: true)
    }
}

extension BudgetListViewController: BudgetListViewProtocol {
    
    func results(model: BudgetListModel) {
        self.model = model
        self.tableView.reloadData()
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
