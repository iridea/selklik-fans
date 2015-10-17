//
//  ArtistListCell.swift
//  Selklik-Fans
//
//  Created by Jamal N. Ahmad on 16/10/2015.
//  Copyright © 2015 Selklik. All rights reserved.
//

import UIKit

class ArtistListCell: UITableViewCell {


    @IBOutlet weak var isFollowedLabel: UILabel!
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var facebookIcon: UIImageView!
    @IBOutlet weak var twitterIcon: UIImageView!
    @IBOutlet weak var instagramIcon: UIImageView!


    override func awakeFromNib() {
        super.awakeFromNib()
        profilePhoto.layer.cornerRadius = profilePhoto.frame.width / 2
        profilePhoto.clipsToBounds = true

        let selectedView = UIView(frame: CGRect.zero)
        selectedView.backgroundColor = UIColor.clearColor()
        selectedBackgroundView = selectedView
        self.tintColor = UIColor(red: 63/255, green: 174/255, blue: 67/255, alpha: 1.0)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
