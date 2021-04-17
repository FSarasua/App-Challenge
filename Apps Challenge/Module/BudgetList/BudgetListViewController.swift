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
        // TODO: Constants
        // TODO: UINib
        let budgetNib = UINib(nibName: "BudgetTableViewCell", bundle: nil)
        
        self.tableView.register(budgetNib, forCellReuseIdentifier: "BudgetCellID")
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        // TODO: Constants
        self.title = "Budget List"
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
