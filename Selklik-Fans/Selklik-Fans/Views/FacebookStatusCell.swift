//
//  FacebookStatusCell.swift
//  Selklik-Fans
//
//  Created by Jamal N. Ahmad on 12/10/2015.
//  Copyright © 2015 Selklik. All rights reserved.
//

import UIKit

class FacebookStatusCell: UITableViewCell {

    @IBOutlet weak var accountNameButton: UIButton!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var postStatusLabel: UILabel!
    @IBOutlet weak var totalLikeLabel: UILabel!
    @IBOutlet weak var totalCommentButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
