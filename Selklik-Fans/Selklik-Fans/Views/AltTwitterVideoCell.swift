//
//  AltTwitterVideoCell.swift
//  Selklik-Fans
//
//  Created by Jamal N. Ahmad on 22/10/2015.
//  Copyright © 2015 Selklik. All rights reserved.
//

import UIKit

class AltTwitterVideoCell: AltTwitterStatusCell {

    @IBOutlet weak var postThumb: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}