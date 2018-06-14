//
//  TestTableViewCell.swift
//  Infoquest2K18
//
//  Created by Rohit Dulam on 27/02/18.
//  Copyright © 2018 rohit. All rights reserved.
//

import UIKit
import SDWebImage

class TestTableViewCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
