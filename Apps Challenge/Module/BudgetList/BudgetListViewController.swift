//
//  BudgetListViewController.swift
//  Apps Challenge
//
//  Created by Francisco Javier Sarasua Galan on 17/04/2021.
//

import UIKit

class BudgetListViewController: UIViewController {

    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var imgBackground: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Lyfe Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadData()
        self.loadStyle()
    }
    
    //MARK: - Private Methods
    private func loadData() {
        // TableView        
        self.tableView.register(Constants.Nib.BudgetCell, forCellReuseIdentifier: Constants.Identifier.BudgetID)
        
        self.tableView.dataSource = self
        
        // NavigationBar
        self.title = Constants.Module.BudgetList.title
        self.createAddButton()
    }
    
    private func loadStyle() {
        self.transparentNavigationBar()
    }
    
    private func transparentNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    
    private func createAddButton() {
        let addButton = UIButton(type: .custom)
        
        addButton.setImage(Constants.Image.addImage, for: .normal)
        addButton.addTarget(self, action: #selector(goToCreateBudget), for: .touchUpInside)
        
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView:  addButton)
    }
    
    // MARK: - Actions
    @objc func goToCreateBudget() {
        self.navigationController?.pushViewController(CreateBudgetViewController(), animated: true)
    }
}

extension BudgetListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier:  Constants.Identifier.BudgetID) else {
            return UITableViewCell()
        }
        
        return cell
    }
}
