//
//  UserInfo.swift
//  Selklik-Fans
//
//  Created by Jamal N. Ahmad on 09/10/2015.
//  Copyright © 2015 Selklik. All rights reserved.
//

import Foundation
import CoreData

class UserInfo {

    
    func getNotificationSettingFromCoreData(managedContext: NSManagedObjectContext) -> NSNumber {

        print("managedContext: \(managedContext)")
        
        var notificationStatus:NSNumber!
        let accessFetch = NSFetchRequest(entityName: "AppSetting")

        do  {
            let result = try managedContext.executeFetchRequest(accessFetch) as? [AppSetting]

            if let settings = result {

                //if old token exist in core data, delete it
                if settings.count > 0 {
                    notificationStatus  = settings[0].pushNotification!
                }
                else{
                    //insert into coredata new value of notificationStatus
                    notificationStatus = 1
                    var newSetting:AppSetting!
                    let settingEntity = NSEntityDescription.entityForName("AppSetting", inManagedObjectContext: managedContext)
                    newSetting = AppSetting(entity:settingEntity!, insertIntoManagedObjectContext: managedContext)
                    newSetting.pushNotification = notificationStatus
                    try managedContext.save()
                }
            }
        }catch let fetchError as NSError {
            print("Error: \(fetchError.localizedDescription)")
        }
        
        return notificationStatus
    }


    func getTokenFromCoreData(managedContext: NSManagedObjectContext) -> String {

        var userToken:String!
        let accessFetch = NSFetchRequest(entityName: "Access")
        do  {
            let result = try managedContext.executeFetchRequest(accessFetch) as? [SelklikFansAccess]

            if let loginUser = result {

                //if old token exist in core data, delete it
                if loginUser.count > 0 {
                    userToken  = loginUser[0].token

                }

            }
        }
        catch let fetchError as NSError {
            print("dogFetch error: \(fetchError.localizedDescription)")
        }

        return userToken
    }

    func removeUserAccessFromCoreData(managedContext: NSManagedObjectContext){

        let fetchPosts = NSFetchRequest(entityName: "Access")

        do  {
            let fetchedEntities = try managedContext.executeFetchRequest(fetchPosts) as? [SelklikFansAccess]

            for entity in fetchedEntities! {
                managedContext.deleteObject(entity)
            }

        }
        catch let fetchError as NSError {
            print("Fetch Post for delete error: \(fetchError.localizedDescription)")
        }

        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save: \(error)")
        }
    }


    func clearAllCountryFromCoreData(managedContext: NSManagedObjectContext) {

        let fetchPosts = NSFetchRequest(entityName: "Country")

        do  {
            let fetchedEntities = try managedContext.executeFetchRequest(fetchPosts) as? [Country]

            for entity in fetchedEntities! {
                managedContext.deleteObject(entity)
            }

        }
        catch let fetchError as NSError {
            print("Fetch Post for delete error: \(fetchError.localizedDescription)")
        }

        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save: \(error)")
        }
    }

    func clearArtistFromCoreData(managedContext: NSManagedObjectContext) {

        let fetchPosts = NSFetchRequest(entityName: "Artist")

        do  {
            let fetchedEntities = try managedContext.executeFetchRequest(fetchPosts) as? [Artist]

            for entity in fetchedEntities! {
                managedContext.deleteObject(entity)
            }

        }
        catch let fetchError as NSError {
            print("Fetch Post for delete error: \(fetchError.localizedDescription)")
        }

        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save: \(error)")
        }
    }

    func clearSingleArtistFeedFromCoreData(managedContext: NSManagedObjectContext) {

        let fetchPosts = NSFetchRequest(entityName: "PostSingle")

        do  {
            let fetchedEntities = try managedContext.executeFetchRequest(fetchPosts) as? [PostSingle]

            for entity in fetchedEntities! {
                managedContext.deleteObject(entity)
            }

        }
        catch let fetchError as NSError {
            print("Fetch Post for delete error: \(fetchError.localizedDescription)")
        }

        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save: \(error)")
        }
    }

    func clearCommentFromCoreData(managedContext: NSManagedObjectContext) {

        let fetchPosts = NSFetchRequest(entityName: "Comment")

        do  {
            let fetchedEntities = try managedContext.executeFetchRequest(fetchPosts) as? [Comment]

            for entity in fetchedEntities! {
                managedContext.deleteObject(entity)
            }

        }
        catch let fetchError as NSError {
            print("Fetch Post for delete error: \(fetchError.localizedDescription)")
        }

        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save: \(error)")
        }
    }

    func clearPremiumPostFromCoreData(managedContext: NSManagedObjectContext) {

        let fetchPosts = NSFetchRequest(entityName: "PremiumPost")

        do  {
            let fetchedEntities = try managedContext.executeFetchRequest(fetchPosts) as? [PremiumPost]

            for entity in fetchedEntities! {
                managedContext.deleteObject(entity)
            }

        }
        catch let fetchError as NSError {
            print("Fetch Post for delete error: \(fetchError.localizedDescription)")
        }

        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save: \(error)")
        }
    }

    func clearUserFromCoreData(managedContext: NSManagedObjectContext) {

        let fetchPosts = NSFetchRequest(entityName: "User")

        do  {
            let fetchedEntities = try managedContext.executeFetchRequest(fetchPosts) as? [User]

            for entity in fetchedEntities! {
                managedContext.deleteObject(entity)
            }

        }
        catch let fetchError as NSError {
            print("Fetch Post for delete error: \(fetchError.localizedDescription)")
        }

        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save: \(error)")
        }
    }


    func dateToSting(date: NSDate) -> NSString
    {
        let dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd H:mm:ss"
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")

        return dateFormatter.stringFromDate(date)
    }

    //--- Convert Date String to NSDate ---//
    func stringToDate(dateString: NSString, dateFormat:String) -> NSDate?
    {
        let dateFormatter = NSDateFormatter()
        //dateFormatter.dateFormat = "yyyy-MM-dd H:mm:ss"
        dateFormatter.dateFormat = dateFormat//"yyyy-MM-dd H:mm:ss"
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")

        return dateFormatter.dateFromString(dateString as String)
    }

}