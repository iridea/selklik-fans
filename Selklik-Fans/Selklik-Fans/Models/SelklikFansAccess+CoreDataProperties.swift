//
//  SelklikFansAccess+CoreDataProperties.swift
//  
//
//  Created by Jamal N. Ahmad on 9/27/15.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension SelklikFansAccess {

    @NSManaged var token: String?
    @NSManaged var tokenCreateTimestamp: NSDate?

}
