//
//  PremiumPhotoCell.swift
//  Selklik-Fans
//
//  Created by Jamal N. Ahmad on 04/11/2015.
//  Copyright © 2015 Selklik. All rights reserved.
//

import UIKit
import ActiveLabel

class PremiumPhotoCell: UITableViewCell {

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
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
