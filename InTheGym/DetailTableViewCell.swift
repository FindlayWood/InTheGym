//
//  DetailTableViewCell.swift
//  InTheGym
//
//  Created by Findlay Wood on 12/07/2019.
//  Copyright © 2019 FindlayWood. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {
    
    @IBOutlet var exerciseLabel:UILabel!
    @IBOutlet var weightLabel:UILabel!
    @IBOutlet var setsLabel:UILabel!
    @IBOutlet var repsLabel:UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
