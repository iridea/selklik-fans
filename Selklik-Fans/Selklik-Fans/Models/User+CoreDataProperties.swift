//
//  User+CoreDataProperties.swift
//  
//
//  Created by Jamal N. Ahmad on 29/10/2015.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension User {

    @NSManaged var birthday: NSDate?
    @NSManaged var country: String?
    @NSManaged var firstName: String?
    @NSManaged var gender: String?
    @NSManaged var lastName: String?
    @NSManaged var email: String?
    @NSManaged var phone: String?
    @NSManaged var profileImage: NSData?
    @NSManaged var profileImageHeight: NSNumber?
    @NSManaged var profileImageUrl: String?
    @NSManaged var profileImageWidth: NSNumber?

}
