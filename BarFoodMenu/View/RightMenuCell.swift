//
//  RigheMenuCell.swift
//  FAPanels
//
//  Created by Fahid Attique on 10/07/2017.
//  Copyright © 2017 Fahid Attique. All rights reserved.
//

import UIKit

class RightMenuCell: UITableViewCell {

    
    @IBOutlet var menuOption: UIImageView!    
    @IBOutlet weak var menuTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
