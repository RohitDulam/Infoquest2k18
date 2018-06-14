//
//  DescTableViewCell.swift
//  Infoquest2K18
//
//  Created by Rohit Dulam on 28/02/18.
//  Copyright © 2018 rohit. All rights reserved.
//

import UIKit

class DescTableViewCell: UITableViewCell {
    @IBOutlet weak var hd: UILabel!
    @IBOutlet weak var stuff: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
