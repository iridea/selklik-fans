//
//  SinglePost+CoreDataProperties.swift
//  Selklik-Fans
//
//  Created by Jamal N. Ahmad on 21/10/2015.
//  Copyright © 2015 Selklik. All rights reserved.
//

import Foundation
import CoreData

extension SinglePost {

    @NSManaged var artistId: String?
    @NSManaged var name: String?
    @NSManaged var screenName: String?
    @NSManaged var totalLike: NSNumber?
    @NSManaged var totalComment: NSNumber?
    @NSManaged var postId: String?
    @NSManaged var postLink: String?
    @NSManaged var postText: String?
    @NSManaged var postType: String?
    @NSManaged var socialMediaType: String?
    @NSManaged var timeStamp: NSDate?
    @NSManaged var photoStdHeight: NSNumber?
    @NSManaged var photoStdWidth: NSNumber?
    @NSManaged var photoStdUrl: String?
    @NSManaged var videoThumbStdHeight: NSNumber?
    @NSManaged var videoThumbStdWidth: NSNumber?
    @NSManaged var videoThumbStdUrl: String?
    @NSManaged var videoStdUrl: String?
    @NSManaged var fbContentLink: String?
    @NSManaged var fbContentLinkImageUrl: String?
    @NSManaged var fbContentLinkText: String?
    @NSManaged var fbContentLinkTitle: String?
    @NSManaged var fbTotalShare: NSNumber?
    @NSManaged var twIsRetweet: NSNumber?
    @NSManaged var twTotalRetweet: NSNumber?
    @NSManaged var twRetweetName: String?
    @NSManaged var twRetweetScreenName: String?
    
}
