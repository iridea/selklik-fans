//
//  FacebookPhotoCell.swift
//  Selklik-Fans
//
//  Created by Jamal N. Ahmad on 09/10/2015.
//  Copyright © 2015 Selklik. All rights reserved.
//

import UIKit

class FacebookPhotoCell: FacebookStatusCell {

    @IBOutlet weak var postPhoto: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
