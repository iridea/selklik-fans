//
//  UIButtonExtend.swift
//  Selklik-Fans
//
//  Created by Jamal N. Ahmad on 29/10/2015.
//  Copyright © 2015 Selklik. All rights reserved.
//

import UIKit

class ArtistNameButton : UIButton {

    var id: String = "" {
        willSet(newValue) {
            self.id = newValue
        }
    }

    var countryCode: String = "" {
        willSet(newValue) {
            self.countryCode = newValue
        }
    }

    var imageUrl: String = "" {
        willSet(newValue) {
            self.imageUrl = newValue
        }
    }

    var name: String = "" {
        willSet(newValue) {
            self.name = newValue
        }
    }
}