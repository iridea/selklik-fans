//
//  Constants.swift
//  Selklik-Fans
//
//  Created by Jamal N. Ahmad on 9/26/15.
//  Copyright © 2015 Selklik. All rights reserved.
//

import Foundation

struct API {
    static let url = "http://www.selklik.mobi/api/"
    static let version = "1.1/"
    static let artistFeedUrl = url + version + "artist_feed"
}

struct Setting {
    static let malaysia = "my"
    static let indonesia = "idn"
}


struct Title {
    static let loginFail = "Login Fail"
}

struct Message {
    static let loginFail = "Log in to system fail. Please check your email or password."
}