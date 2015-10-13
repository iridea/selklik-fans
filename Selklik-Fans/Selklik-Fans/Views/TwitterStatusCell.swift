//
//  TwitterStatusCell.swift
//  Selklik-Fans
//
//  Created by Jamal N. Ahmad on 08/10/2015.
//  Copyright © 2015 Selklik. All rights reserved.
//

import UIKit

class TwitterStatusCell: UITableViewCell {


    @IBOutlet weak var accountNameButton: UIButton!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var postStatusLabel: UILabel!
    @IBOutlet weak var totalLikeLabel: UILabel!
    @IBOutlet weak var totalRetweetLabel: UILabel!
    //@IBOutlet weak var totalCommentButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        profilePictureImageView.layer.cornerRadius = profilePictureImageView.frame.width / 2
        profilePictureImageView.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
