//
//  Post+CoreDataProperties.swift
//  
//
//  Created by Jamal N. Ahmad on 21/10/2015.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Post {

    @NSManaged var artistId: String?
    @NSManaged var country: String?
    @NSManaged var fbContentLink: String?
    @NSManaged var fbContentLinkImageUrl: String?
    @NSManaged var fbContentLinkText: String?
    @NSManaged var fbContentLinkTitle: String?
    @NSManaged var fbTotalShare: NSNumber?
    @NSManaged var name: String?
    @NSManaged var photoImage: NSData?
    @NSManaged var photoStdHeight: NSNumber?
    @NSManaged var photoStdUrl: String?
    @NSManaged var photoStdWidth: NSNumber?
    @NSManaged var postId: String?
    @NSManaged var postLink: String?
    @NSManaged var postText: String?
    @NSManaged var postType: String?
    @NSManaged var profileImage: NSData?
    @NSManaged var profileImageUrl: String?
    @NSManaged var screenName: String?
    @NSManaged var socialMediaType: String?
    @NSManaged var timeStamp: NSDate?
    @NSManaged var totalComment: NSNumber?
    @NSManaged var totalLike: NSNumber?
    @NSManaged var twIsRetweet: NSNumber?
    @NSManaged var twRetweetName: String?
    @NSManaged var twRetweetScreenName: String?
    @NSManaged var twTotalRetweet: NSNumber?
    @NSManaged var videoStdUrl: String?
    @NSManaged var videoThumbStdHeight: NSNumber?
    @NSManaged var videoThumbStdUrl: String?
    @NSManaged var videoThumbStdWidth: NSNumber?

}
