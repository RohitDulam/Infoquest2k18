//
//  NotificationsTableViewCell.swift
//  Infoquest2K18
//
//  Created by Rohit Dulam on 10/03/18.
//  Copyright © 2018 rohit. All rights reserved.
//

import UIKit

class NotificationsTableViewCell: UITableViewCell {

    @IBOutlet weak var head: UILabel!
    @IBOutlet weak var body: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var time: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
