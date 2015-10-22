//
//  AltTwitterStatusCell.swift
//  Selklik-Fans
//
//  Created by Jamal N. Ahmad on 22/10/2015.
//  Copyright © 2015 Selklik. All rights reserved.
//

import UIKit
import ActiveLabel

class AltTwitterStatusCell: UITableViewCell {



    @IBOutlet weak var screenNameLabel: UILabel!

    @IBOutlet weak var dateTimeLabel: UILabel!

    @IBOutlet weak var totalLikeLabel: UILabel!
    @IBOutlet weak var totalRetweetLabel: UILabel!
    @IBOutlet weak var statusActiveLabel:ActiveLabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
