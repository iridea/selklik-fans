//
//  Comment+CoreDataProperties.swift
//  
//
//  Created by Jamal N. Ahmad on 26/10/2015.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Comment {

    @NSManaged var name: String?
    @NSManaged var screenName: String?
    @NSManaged var timeStamp: NSDate?
    @NSManaged var postId: String?
    @NSManaged var profileImageUrl: String?
    @NSManaged var comment: String?

}
