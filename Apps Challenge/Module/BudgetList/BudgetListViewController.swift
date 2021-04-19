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
    
    //MARK: - Private Method's
    
    private func loadData() {
        // TableView
        // TODO: Constants
        // TODO: UINib
        let budgetNib = UINib(nibName: "BudgetTableViewCell", bundle: nil)
        
        self.tableView.register(budgetNib, forCellReuseIdentifier: "BudgetCellID")
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        // NavigationBar
        // TODO: Constants
        self.title = "Presupuestos"
        self.createAddButton()
    }
    
    private func loadStyle() {
        self.transparentNavigationBar()
    }
    
    func transparentNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    
    func createAddButton() {
        let addButton = UIButton(type: .custom)
        // TODO: UIImage
        let image = UIImage(named: "plus1")
        
        addButton.setImage(image, for: .normal)
        addButton.addTarget(self, action: #selector(goToCreateBudget), for: .touchUpInside)
        
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView:  addButton)
    }
    
    @objc func goToCreateBudget() {
        self.navigationController?.pushViewController(CreateBudgetViewController(), animated: true)
    }
}

extension BudgetListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // TODO: Constants
        guard let cell = tableView.dequeueReusableCell(withIdentifier:  "BudgetCellID") else {
            return UITableViewCell()
        }
        
        return cell
    }
}

extension BudgetListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}
