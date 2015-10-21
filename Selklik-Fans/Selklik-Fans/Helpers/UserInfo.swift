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
    func getTokenFromCoreData(managedContext: NSManagedObjectContext) -> String{

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

    func clearArtistFromCoreData(managedContext: NSManagedObjectContext){//, predicate:NSPredicate) {

        let fetchPosts = NSFetchRequest(entityName: "Artist")
        //fetchPosts.predicate = predicate

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


    
}