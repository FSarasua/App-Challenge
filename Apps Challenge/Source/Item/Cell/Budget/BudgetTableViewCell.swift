//
//  BudgetTableViewCell.swift
//  Apps Challenge
//
//  Created by Francisco Javier Sarasua Galan on 17/04/2021.
//

import UIKit

class BudgetTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlet
    @IBOutlet weak var viewCard: UIView!
    
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbPhone: UILabel!
    @IBOutlet weak var lbEmail: UILabel!
    @IBOutlet weak var lbDescription: UILabel!
    
    @IBOutlet var arrayAllLabel: [UILabel]!
    
    // MARK: - Variable
    var data: BudgetCellModel = BudgetCellModel()
    
    // MARK: - Lyfe Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func loadCell() {
        self.loadData()
        self.loadStyle()
    }
    
    // MARK: - Private Methods
    private func loadData() {
        self.lbName.text = self.data.name
        self.lbPhone.text = self.data.phone
        self.lbEmail.text = self.data.email
        self.lbDescription.text = self.data.description
    }
    
    private func loadStyle() {
        // All Label
        for label in self.arrayAllLabel {
            label.loadStyleBudgetList()
        }
        
        // View Card
        self.viewCard.layer.cornerRadius = 20.0
    }
}
