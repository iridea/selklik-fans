//
//  Country+CoreDataProperties.swift
//  
//
//  Created by Jamal N. Ahmad on 19/10/2015.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Country {

    @NSManaged var id: String?
    @NSManaged var code: String?
    @NSManaged var name: String?
    @NSManaged var continent: String?
    @NSManaged var iconUrl: String?
    @NSManaged var totalArtist: NSNumber?

}
