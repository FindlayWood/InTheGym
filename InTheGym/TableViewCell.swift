//
//  TableViewCell.swift
//  InTheGym
//
//  Created by Findlay Wood on 11/07/2019.
//  Copyright © 2019 FindlayWood. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet var main: UILabel!
    @IBOutlet var second: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
