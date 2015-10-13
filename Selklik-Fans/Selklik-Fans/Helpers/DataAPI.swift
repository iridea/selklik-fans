//
//  DataAPI.swift
//  Selklik-Fans
//
//  Created by Jamal N. Ahmad on 9/28/15.
//  Copyright © 2015 Selklik. All rights reserved.
//

import Foundation
import Alamofire

//struct DataAPI {
    
    /*
    enum Router: URLRequestConvertible {
    static let baseURLString = "http://example.com"
    static let perPage = 50
    
    case Search(query: String, page: Int)
    
    // MARK: URLRequestConvertible
    
    var URLRequest: NSMutableURLRequest {
    let result: (path: String, parameters: [String: AnyObject]) = {
    switch self {
    case .Search(let query, let page) where page > 1:
    return ("/search", ["q": query, "offset": Router.perPage * page])
    case .Search(let query, _):
    return ("/search", ["q": query])
    }
    }()
    
    let URL = NSURL(string: Router.baseURLString)!
    let URLRequest = NSURLRequest(URL: URL.URLByAppendingPathComponent(result.path))
    let encoding = Alamofire.ParameterEncoding.URL
    
    return encoding.encode(URLRequest, parameters: result.parameters).0
    }
    }
    */
  struct DataAPI {
    enum Router: URLRequestConvertible {
        static let baseURLString = API.url
        static let country = Setting.malaysia
        static let version = API.version
        
        case ArtistList(String)
        case FavouriteArtistList(String)
        case ArtistPost(String)
        case SingleArtistPost(String,String)
        case ArtistPremiumPost(String)
        case FeedComment(String,String,String)
        case LatestNews(String)
        
        var URLRequest: NSMutableURLRequest {
            let result: (path: String, parameters: [String: AnyObject]) = {
                switch self {
                    
                case .ArtistList (let token):
                    let params = ["token": token, "country": Router.country]
                    return ("/\(Router.version)/artist_all", params)
                    
                case .FavouriteArtistList (let token):
                    let params = ["token": token, "country": Router.country, "follow":"1"]
                    return ("/\(Router.version)/artist_following", params)
                    
                    
                case .ArtistPost (let token):
                    let params = ["token": token, "country": Router.country, "limit" : "25", "postType":"photo"]
                    return ("/\(Router.version)/artist_fb_feed", params)
                    
                case .SingleArtistPost (let token, let artistId):
                    let params = ["token": token, "country": Router.country, "limit" : "15", "artist_id":artistId]
                    return ("/\(Router.version)/artist_feed", params)
                    
                case .ArtistPremiumPost (let token):
                    let params = ["token": token, "country": Router.country, "limit" : "15", "post_type":"premium"]
                    return ("/\(Router.version)/artist_feed", params)
                    
                case .FeedComment (let token, let postId, let socialMediaType):
                    let params = ["token": token, "country": Router.country, "post_id":postId, "social_media":socialMediaType]
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