//
//  ArtistViewController.swift
//  Selklik-Fans
//
//  Created by Jamal N. Ahmad on 20/10/2015.
//  Copyright © 2015 Selklik. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreData
import AlamofireImage

class ArtistViewController: UIViewController {


    //MARK: - Variable
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var managedContext: NSManagedObjectContext!
    var userToken:String!
    var selectedArtistName:String?
    var selectedArtistId:String?
    var selectedArtistCountryCode:String?
    var selectedArtistImageUrl:String?
    var countryCode:String!


    let userInfo = UserInfo()
    let hud = Hud()
    var artistList = [NSManagedObject]()

    var fetchPredicate:NSPredicate!

    var fetchedResultsController : NSFetchedResultsController!

    //MARK: - Struct
    struct CellIdentifiers {
        static let artistListCell = "ArtistListCell"
    }


    //MARK: - IBoutlet
    @IBOutlet weak var artistTableView: UITableView!

    //MARK: - Default Function
    override func viewDidLoad() {
        super.viewDidLoad()

        print("countryCode is:\(countryCode)")

        self.managedContext = appDelegate.coreDataStack.context
        self.userToken = userInfo.getTokenFromCoreData(managedContext)

        artistTableView.dataSource = self
        artistTableView.delegate = self
        
        fetchPredicate = NSPredicate(format: "countryCode == '%@'", countryCode)

        registerNib()

        clearArtistData()
        populateArtistsAndCountries()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //MARK: - Custom Function
    func registerNib(){

        //facebook
        let cellNib = UINib(nibName: CellIdentifiers.artistListCell, bundle: nil)
        artistTableView.registerNib(cellNib, forCellReuseIdentifier: CellIdentifiers.artistListCell)
    }

    func clearArtistData(){
        hud.showProgressBar("Loading data", true, view: self.viewIfLoaded!)

        let fetchRequest = NSFetchRequest(entityName: "Artist")

        //fetchRequest.predicate = fetchPredicate

        do {
            let results =
            try managedContext.executeFetchRequest(fetchRequest)
            if results.count > 0 {
                //userInfo.clearArtistFromCoreData(managedContext,predicate: fetchPredicate)
                userInfo.clearArtistFromCoreData(managedContext)
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }

    func populateArtistsAndCountries() {

        let artistEntity = NSEntityDescription.entityForName("Artist",inManagedObjectContext: managedContext)

        Alamofire.request(DataAPI.Router.ArtistPerCountry(userToken,countryCode)).responseJSON(){
            response in

            print("MASUK populateArtists - ALAMOFIRE")
            if let jsonData = response.result.value {

                let json = JSON(jsonData)

                print(json)
                for (_,subJson):(String, JSON) in json["result"] {
                    let newArtist = Artist(entity: artistEntity!,
                        insertIntoManagedObjectContext: self.managedContext)


                    if let isFollow = subJson["follow"].int {
                        newArtist.isFollow = isFollow
                    }else{
                        print("unable to read JSON data isFollow")
                    }

                    if let hasInstagram = subJson["instagram"].int {
                        newArtist.hasInstagram = hasInstagram
                    }else{
                        print("unable to read JSON data hasInstagram")
                    }

                    if let hasFacebook = subJson["facebook"].int {
                        newArtist.hasFacebook = hasFacebook
                    }else{
                        print("unable to read JSON data hasFacebook")
                    }

                    if let hasTwitter = subJson["twitter"].int {
                        newArtist.hasTwitter = hasTwitter
                    }else{
                        print("unable to read JSON data hasTwitter")
                    }

                    if let hasPremium = subJson["premium"].int {
                        newArtist.hasPremium = hasPremium
                    }else{
                        print("unable to read JSON data hasPremium")
                    }

                    if let continent = subJson["continent"].string {
                        newArtist.continent = continent
                    }else{
                        print("unable to read JSON data continent")
                    }

                    if let artistId = subJson["artist_id"].string {
                        newArtist.artistId = artistId
                    }else{
                        print("unable to read JSON data artistId")
                    }

                    if let artistImageUrl = subJson["artist_img"].string {
                        newArtist.artistImageUrl = artistImageUrl
                    }else{
                        print("unable to read JSON data artistImageUrl")
                    }

                    if let notification = subJson["notification"].int {
                        newArtist.notification = notification
                    }else{
                        print("unable to read JSON data notification")
                    }

                    if let artistName = subJson["artist_name"].string {
                        newArtist.artistName = artistName
                    }else{
                        print("unable to read JSON data artistName")
                    }

                    if let artistGender = subJson["gender"].string {
                        newArtist.artistGender = artistGender
                    }else{
                        print("unable to read JSON data artistGender")
                    }

                    if let countryCode = subJson["country"].string {
                        newArtist.countryCode = countryCode
                    }else{
                        print("unable to read JSON data countryCode")
                    }

                    if let international = subJson["international"].string {
                        newArtist.international = international
                    }else{
                        print("unable to read JSON data international")
                    }

                } // End of For-Loop JSON data

                dispatch_async(dispatch_get_main_queue()) {
                    do {
                        try self.managedContext.save()
                    } catch let error as NSError {
                        print("Could not save: \(error)")
                    }

                    self.getArtistFromCoreData()
                    self.artistTableView.reloadData()

                    self.hud.hideProgressBar()
                    self.view.userInteractionEnabled = true
                }
                
            }
            else{ //Unable to read JSON data from Alamofire
                print("Unable to read JSON data from Alamofire")
            }
            
        }// End of Alamofire
        
    }

    func getArtistFromCoreData() {
        let fetchRequest = NSFetchRequest(entityName: "Artist")
        let nameSort =
        NSSortDescriptor(key: "artistName", ascending: true)
        fetchRequest.sortDescriptors = [nameSort]
        do  {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            artistList = results as! [NSManagedObject]
        }
        catch let fetchError as NSError {
            print("Fetch access in AppDelegate error: \(fetchError.localizedDescription)")
        }
    }
}

extension ArtistViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("artistList.count:\(artistList.count)")
        return artistList.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let artist = artistList[indexPath.row]

        //Download image profile using AlamofireImage
        let artistImageUrlString = artist.valueForKey("artistImageUrl") as? String
        let artistImageUrl = NSURL(string: artistImageUrlString!)


        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifiers.artistListCell, forIndexPath:indexPath) as! ArtistListCell


        cell.profilePhoto.image = UIImage(named: "UserIcon")
        if let imageUrl = artistImageUrl {
            cell.profilePhoto.af_setImageWithURL(imageUrl)
        }

        cell.artistName.text = artist.valueForKey("artistName") as? String

        
        return cell
    }
}

extension ArtistViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let artist = artistList[indexPath.row]
        selectedArtistId = artist.valueForKey("artistId") as? String
        selectedArtistCountryCode = artist.valueForKey("countryCode") as? String
        selectedArtistImageUrl = artist.valueForKey("artistImageUrl") as? String
        selectedArtistName = artist.valueForKey("artistName") as? String
        self.performSegueWithIdentifier("artistListToSinglePost", sender: self)
        
    }



    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "artistListToSinglePost") {
            let singleArtistPostViewController = segue.destinationViewController as! SingleFeedViewController
            singleArtistPostViewController.artistId =  selectedArtistId
            singleArtistPostViewController.countryCode = selectedArtistCountryCode
             singleArtistPostViewController.profileUrl = selectedArtistImageUrl
            singleArtistPostViewController.name = selectedArtistName
        }
        
    }

}

