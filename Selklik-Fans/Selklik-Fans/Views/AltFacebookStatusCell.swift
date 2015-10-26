//
//  AltFacebookStatusCell.swift
//  Selklik-Fans
//
//  Created by Jamal N. Ahmad on 26/10/2015.
//  Copyright © 2015 Selklik. All rights reserved.
//

import UIKit
import ActiveLabel

class AltFacebookStatusCell: UITableViewCell {



    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var statusActiveLabel:ActiveLabel!
    @IBOutlet weak var totalLikeLabel: UILabel!
    @IBOutlet weak var totalCommentLabel: CommentButton!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
