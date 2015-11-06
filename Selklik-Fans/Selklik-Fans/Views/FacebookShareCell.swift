//
//  FacebookShareCell.swift
//  Selklik-Fans
//
//  Created by Jamal N. Ahmad on 04/11/2015.
//  Copyright © 2015 Selklik. All rights reserved.
//

import UIKit
import ActiveLabel

class FacebookShareCell: FacebookStatusCell {

    @IBOutlet weak var shareBackgroundView: UIView!
    @IBOutlet weak var shareContentPhoto: UIImageView!

    @IBOutlet weak var shareContentTitle: UILabel!
    @IBOutlet weak var shareContentText: ActiveLabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        shareBackgroundView.layer.cornerRadius = 7.0
        shareBackgroundView.clipsToBounds = true
        shareBackgroundView.layer.borderWidth = 1

        shareBackgroundView.layer.borderColor = UIColor.lightGrayColor().CGColor

         shareContentText.handleURLTap { url in UIApplication.sharedApplication().openURL(url) }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
