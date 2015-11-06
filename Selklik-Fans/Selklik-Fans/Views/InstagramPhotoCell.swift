//
//  InstagramPhotoCell.swift
//  Selklik-Fans
//
//  Created by Jamal N. Ahmad on 15/10/2015.
//  Copyright © 2015 Selklik. All rights reserved.
//

import UIKit
import ActiveLabel

class InstagramPhotoCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!

    @IBOutlet weak var accountNameButton: ArtistNameButton!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var statusActiveLabel:ActiveLabel!
    @IBOutlet weak var postPhoto: UIImageView!
    @IBOutlet weak var totalLikeLabel: UILabel!
    @IBOutlet weak var totalCommentButton: CommentButton!
   
    let gestureRecognizer = PostImageTapGestureRecognizer()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        statusActiveLabel.mentionEnabled = false
        statusActiveLabel.hashtagColor = UIColor(red: 64/255, green: 153/255, blue: 252/255, alpha: 1.0)
        statusActiveLabel.URLColor = UIColor(red: 1/255, green: 102/255, blue: 22/255, alpha: 1.0)

        statusActiveLabel.handleURLTap { url in UIApplication.sharedApplication().openURL(url) }
        statusActiveLabel.handleHashtagTap {
            hashtag in UIApplication.sharedApplication().openURL((NSURL(string: "https://instagram.com/explore/tags/\(hashtag)"))!) }
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
