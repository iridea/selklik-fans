//
//  PremiumPost+CoreDataProperties.swift
//  
//
//  Created by Jamal N. Ahmad on 16/11/2015.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension PremiumPost {

    @NSManaged var artistId: String?
    @NSManaged var country: String?
    @NSManaged var name: String?
    @NSManaged var photoStdHeight: NSNumber?
    @NSManaged var photoStdUrl: String?
    @NSManaged var photoStdWidth: NSNumber?
    @NSManaged var postId: String?
    @NSManaged var postText: String?
    @NSManaged var postType: String?
    @NSManaged var prChargeType: NSNumber?
    @NSManaged var prLikeStatus: NSNumber?
    @NSManaged var profileImageUrl: String?
    @NSManaged var prPurchaseStatus: NSNumber?
    @NSManaged var screenName: String?
    @NSManaged var socialMediaType: String?
    @NSManaged var timeStamp: NSDate?
    @NSManaged var totalComment: NSNumber?
    @NSManaged var totalLike: NSNumber?
    @NSManaged var videoStdUrl: String?
    @NSManaged var videoThumbStdHeight: NSNumber?
    @NSManaged var videoThumbStdUrl: String?
    @NSManaged var videoThumbStdWidth: NSNumber?

}
