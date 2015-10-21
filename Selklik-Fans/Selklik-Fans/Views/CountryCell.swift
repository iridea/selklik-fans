//
//  CountryTableViewCell.swift
//  Selklik-Fans
//
//  Created by Jamal N. Ahmad on 19/10/2015.
//  Copyright © 2015 Selklik. All rights reserved.
//

import UIKit

class CountryCell: UITableViewCell {

    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var totalArtistLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        flagImageView.layer.cornerRadius = 7
        flagImageView.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
