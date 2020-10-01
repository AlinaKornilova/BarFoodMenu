//
//  FavoriteTableViewCell.swift
//  BarFoodMenu
//
//  Created by Baby on 29.09.2020.
//  Copyright © 2020 bar. All rights reserved.
//

import UIKit
import Cosmos

class FeedbackTableViewCell: UITableViewCell {
    
    @IBOutlet weak var feedbackUserPhoto: UIImageView!
    @IBOutlet weak var feedbackStar: CosmosView!
    @IBOutlet weak var feedbackUserName: UILabel!
    @IBOutlet weak var feedbackDate: UILabel!
    @IBOutlet weak var feedbackContent: UILabel!
    @IBOutlet weak var cellGroup: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
