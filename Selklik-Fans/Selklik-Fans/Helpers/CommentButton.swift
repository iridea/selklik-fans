//
//  CommentButton.swift
//  Selklik-Fans
//
//  Created by Jamal N. Ahmad on 26/10/2015.
//  Copyright © 2015 Selklik. All rights reserved.
//

import UIKit

class CommentButton : UIButton {

    var country: String = "" {
        willSet(newValue) {
            self.country = newValue
        }
    }

    var postId: String = "" {
        willSet(newValue) {
            self.postId = newValue
        }
    }

    var socialMedia: String = "" {
        willSet(newValue) {
            self.socialMedia = newValue
        }
    }
}
