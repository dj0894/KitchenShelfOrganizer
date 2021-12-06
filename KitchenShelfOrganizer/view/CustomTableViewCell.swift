//
//  CustomTableViewCell.swift
//  KitchenShelfOrganizer
//
//  Created by Deepika Jha on 05/12/21.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
  
    @IBOutlet weak var expiryDateLbl: UILabel!
    @IBOutlet weak var purchaseDateLbl: UILabel!
    @IBOutlet weak var itemNameLbl: UILabel!
    
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
