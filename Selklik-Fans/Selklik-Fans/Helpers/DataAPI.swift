//
//  DataAPI.swift
//  Selklik-Fans
//
//  Created by Jamal N. Ahmad on 9/28/15.
//  Copyright © 2015 Selklik. All rights reserved.
//

import Foundation
import Alamofire

  struct DataAPI {
    enum Router: URLRequestConvertible {
        static let baseURLString = API.url
        static let country = Setting.malaysia
        static let version = API.version

        case ArtistCountry(String)
        case ArtistList(String)
        case ArtistPerCountry(String,String)
        case FavouriteArtistList(String)
        case ArtistPost(String)
        case SingleArtistPost(String,String,String)
        case ArtistPremiumPost(String)
        case FeedComment(String,String,String, String)
        case LatestNews(String)
        
        var URLRequest: NSMutableURLRequest {
            let result: (path: String, parameters: [String: AnyObject]) = {
                switch self {

                //api/1.2/artist_country?token=
                case .ArtistCountry (let token):
                    let params = ["token": token]
                    return ("/\(Router.version)/artist_country", params)

                case .ArtistList (let token):
                    let params = ["token": token]
                    return ("/\(Router.version)/artist_all", params)

                case .ArtistPerCountry (let token, let countryCode):
                    let params = ["token": token, "country": countryCode]
                    return ("/\(Router.version)/artist_all", params)

                case .FavouriteArtistList (let token):
                    let params = ["token": token, "country": Router.country, "follow":"1"]
                    return ("/\(Router.version)/artist_following", params)

                case .ArtistPost (let token):
                    let params = ["token": token, "limit" : "60"]//, "post_type" : "shared"]
                    return ("/\(Router.version)/artist_premium", params)

                    //artist_peek
                case .SingleArtistPost (let token, let artistId,let endPointName):
                    let params = ["token": token, "limit" : "25", "artist_id":artistId]
                    return ("/\(Router.version)/\(endPointName)", params)
                    
                case .ArtistPremiumPost (let token):
                    let params = ["token": token, "country": Router.country, "limit" : "15", "post_type":"premium"]
                    return ("/\(Router.version)/artist_feed", params)
                    
                case .FeedComment (let token, let postId, let socialMediaType, let countryCode):
                    let params = ["token": token, "country": countryCode, "post_id":postId, "social_media":socialMediaType]
                    return ("/\(Router.version)/artist_comments", params)
                    
                case .LatestNews (let token):
                    let params = ["token": token]
                    return ("/\(Router.version)/news_latest", params)
                }
                }()

            let URL = NSURL(string: Router.baseURLString)!
            let URLRequest = NSURLRequest(URL: URL.URLByAppendingPathComponent(result.path))
            let encoding = Alamofire.ParameterEncoding.URL
            
            return encoding.encode(URLRequest, parameters: result.parameters).0
            
        }
    }
}