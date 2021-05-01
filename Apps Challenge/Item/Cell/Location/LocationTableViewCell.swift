//
//  LocationTableViewCell.swift
//  Apps Challenge
//
//  Created by Francisco Javier Sarasua Galan on 21/04/2021.
//

import UIKit

class LocationTableViewCell: UITableViewCell {

    // MARK: - IBOutlet
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var lbTitle: UILabel!
    
    @IBOutlet weak var bottomViewBackground: NSLayoutConstraint!
    
    // MARK: - Variable
    var data: LocationCellModel = LocationCellModel()
        
    // MARK: - Lyfe Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.bottomViewBackground.constant = 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

    func loadCell() {
        self.loadData()
    }
    
    // MARK: - Private Methods
    private func loadData() {
        self.lbTitle.text = self.data.title
        
        if self.data.isLastItem {
            self.bottomViewBackground.constant = 0
        }
    }
}
