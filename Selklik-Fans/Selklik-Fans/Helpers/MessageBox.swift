//
//  MessageBox.swift
//  Selklik-Fans
//
//  Created by Jamal N. Ahmad on 28/10/2015.
//  Copyright © 2015 Selklik. All rights reserved.
//

import SCLAlertView

class MessageBox {

    func showRegisterSuccessfulMessage(title: String, message:String, buttonTitle:String, style:SCLAlertViewStyle, duration:NSTimeInterval, colorStyle: UInt, buttonTextColor:UInt){
        SCLAlertView().showTitle(
            title, // Title of view
            subTitle: message, // String of view
            duration: duration, // Duration to show before closing automatically, default: 0.0
            completeText: buttonTitle, // Optional button value, default: ""
            style: style, // Styles - see below.
            colorStyle: colorStyle,
            colorTextButton: buttonTextColor
        )
    }
    
}