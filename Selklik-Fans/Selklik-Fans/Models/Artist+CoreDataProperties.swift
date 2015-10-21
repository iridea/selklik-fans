//
//  Artist+CoreDataProperties.swift
//  
//
//  Created by Jamal N. Ahmad on 20/10/2015.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Artist {

    @NSManaged var hasInstagram: NSNumber?
    @NSManaged var hasFacebook: NSNumber?
    @NSManaged var hasPremium: NSNumber?
    @NSManaged var hasTwitter: NSNumber?
    @NSManaged var isFollow: NSNumber?
    @NSManaged var continent: String?
    @NSManaged var artistId: String?
    @NSManaged var artistImageUrl: String?
    @NSManaged var notification: NSNumber?
    @NSManaged var countryCode: String?
    @NSManaged var artistGender: String?
    @NSManaged var international: String?
    @NSManaged var artistName: String?

}
