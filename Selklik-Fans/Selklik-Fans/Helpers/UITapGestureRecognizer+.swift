//
//  UIImageView+.swift
//  Selklik-Fans
//
//  Created by Jamal N. Ahmad on 17/10/2015.
//  Copyright © 2015 Selklik. All rights reserved.
//

import UIKit

class PostImageTapGestureRecognizer : UITapGestureRecognizer {

    var imageUrl: String = "" {
        willSet(newValue) {
            self.imageUrl = newValue
        }
    }
}