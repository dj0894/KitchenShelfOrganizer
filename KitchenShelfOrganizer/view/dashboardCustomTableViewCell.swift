//
//  dashboardCustomTableViewCell.swift
//  KitchenShelfOrganizer
//
//  Created by Deepika Jha on 16/12/21.
//

import UIKit

class dashboardCustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var itemNameLbl: UILabel!
    @IBOutlet weak var noOfDaysToExpire: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
