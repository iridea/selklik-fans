//
//  AltFacebookShareCell.swift
//  Selklik-Fans
//
//  Created by Jamal N. Ahmad on 30/10/2015.
//  Copyright © 2015 Selklik. All rights reserved.
//

import UIKit
import ActiveLabel

class AltFacebookShareCell: AltFacebookStatusCell {

    @IBOutlet weak var linkImageView: UIImageView!
    @IBOutlet weak var linkTitleButton: UIButton!
    @IBOutlet weak var linkPostContentLabel: ActiveLabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
