//
//  Image.swift
//  Selklik-Fans
//
//  Created by Jamal N. Ahmad on 14/10/2015.
//  Copyright © 2015 Selklik. All rights reserved.
//

import Foundation

class Photo {
    func resize (image image:UIImage, sizeChange:CGSize, imageScale: CGFloat)-> UIImage{

        let hasAlpha = true
        let scale = imageScale // Use scale factor of main screen

        UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
        image.drawInRect(CGRect(origin: CGPointZero, size: sizeChange))

        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage
    }

    func placeholderImage(width width:CGFloat, height:CGFloat, imageScale: CGFloat) -> UIImage{
        let placeHolderImageSize = CGSize(width: width, height: height)
        return resize(image: UIImage(named: "placeholder")!, sizeChange: placeHolderImageSize, imageScale: imageScale)
    }

}