//
//  RegisteredEventsTableViewCell.swift
//  Infoquest2K18
//
//  Created by Rohit Dulam on 04/03/18.
//  Copyright © 2018 rohit. All rights reserved.
//

import UIKit

class RegisteredEventsTableViewCell: UITableViewCell {

    @IBOutlet weak var eventname: UILabel!
    @IBOutlet weak var eventdetails: UILabel!
    @IBOutlet weak var players: UILabel!
    @IBOutlet weak var status: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
