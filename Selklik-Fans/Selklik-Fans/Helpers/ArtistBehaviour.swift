//
//  ArtistBehaviour.swift
//  Selklik-Fans
//
//  Created by Jamal N. Ahmad on 26/11/2015.
//  Copyright © 2015 Selklik. All rights reserved.
//

import Foundation
import CoreData
import Alamofire
import SwiftyJSON

class ArtistBehaviour {

    func updateArtistIsFollowStatus(managedContext: NSManagedObjectContext, artistId:String, isFollowStatus: Int) -> Bool {

        var updateStatus = true
        let predicate = NSPredicate(format: "artistId == %@", artistId)

        let fetchRequest = NSFetchRequest(entityName: "Artist")
        fetchRequest.predicate = predicate

        do {
            let fetchedEntities = try managedContext.executeFetchRequest(fetchRequest) as! [Artist]
            fetchedEntities.first?.isFollow = isFollowStatus

        } catch {
            print("Fail updating artist:\(artistId) isFollow status")
            updateStatus = false
        }
        
        do {
            try managedContext.save()
        } catch {
            print("Fail save isFollow status")
            updateStatus = false
        }

        return updateStatus
    }

    func updateArtistIsFollowStatusInServer(token:String, artistIdList: String, isFollow:Int) -> Bool{

        var updateServerStatus = true

        let headers = ["Content-Type": "application/x-www-form-urlencoded"]

        let parameters = [
            "token": token,
            "artist_id": artistIdList
        ]

        var postUrl = API.followUrl

        if isFollow == 0 {
            postUrl = API.unFollowUrl
        }

       Alamofire.request(.POST, postUrl, headers: headers, parameters: parameters).responseJSON { response in

                let json = JSON(response.result.value!)

                print("json from follow:\(json)")

                if  (json["status"].boolValue) == false{
                    updateServerStatus = false
                }

        }

        return updateServerStatus
        
    }

}