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
    static let version = "1.2/"
    static let artistFeedUrl = url + version + "artist_feed"
    static let loginUrl = url + version + "user_login"
    static let logoutUrl = url + version + "user_logout"
    static let userSettingUrl = url + version + "user_setting"

}

struct Setting {
    static let malaysia = "my"
    static let indonesia = "idn"
    static var deviceToken = ""
}


struct Title {
    static let loginFail = "Login Fail"
    static let logoutFail = "Logout Fail"
}

struct Message {
    static let loginFail = "Log in to system fail. Please check your email or password."
    static let logoutFail = "Something wrong with our server. Logout fail."
}



