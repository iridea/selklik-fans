//
//  CountryListViewController.swift
//  Selklik-Fans
//
//  Created by Jamal N. Ahmad on 19/10/2015.
//  Copyright © 2015 Selklik. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreData
import AlamofireImage


class CountryListViewController: UIViewController {

    //MARK: - Variable
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var managedContext: NSManagedObjectContext!
    var userToken:String!
    let userInfo = UserInfo()
    let hud = Hud()
    var countryObject = [NSManagedObject]()
    var selectedCountryCode:String?
    
    //MARK: - IBoutlet
    @IBOutlet weak var countryTableView: UITableView!
    @IBOutlet weak var menuButton: UIBarButtonItem!

    struct CellIdentifiers {
        static let countryCell = "CountryCell"
    }

    //MARK: - Default Function
    override func viewDidLoad() {
        super.viewDidLoad()
        slideMenu()
        countryTableView.dataSource = self
        countryTableView.delegate = self
        self.managedContext = appDelegate.coreDataStack.context
        self.userToken = userInfo.getTokenFromCoreData(managedContext)
        registerNib()
        clearLocalCountryData()
        populateCountries()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - IBAction

    //MARK: - Custom function

    func clearLocalCountryData(){
        hud.showProgressBar("Loading data", true, view: self.viewIfLoaded!)

        let fetchRequest = NSFetchRequest(entityName: "Country")
        do {
            let results =
            try managedContext.executeFetchRequest(fetchRequest)
            if results.count > 0 {
                userInfo.clearAllCountryFromCoreData(managedContext)
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }

    func slideMenu(){
        //artistTableView.dataSource = self

        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }

    func registerNib(){

        //facebook
        let cellNib = UINib(nibName: CellIdentifiers.countryCell, bundle: nil)
        countryTableView.registerNib(cellNib, forCellReuseIdentifier: CellIdentifiers.countryCell)
    }

  

    func populateCountries() {

        let countryEntity = NSEntityDescription.entityForName("Country",inManagedObjectContext: managedContext)

        Alamofire.request(DataAPI.Router.ArtistCountry(userToken)).responseJSON(){
            response in

            print("MASUK FetchRemoteFeedData - ALAMOFIRE")
            if let jsonData = response.result.value {

                let json = JSON(jsonData)

                print(json)
                for (_,subJson):(String, JSON) in json["result"] {

                    let newCountry = Country(entity: countryEntity!,
                        insertIntoManagedObjectContext: self.managedContext)

                    if let countryCode = subJson["country_code"].string {
                        newCountry.code = countryCode
                    }else{
                        print("unable to read JSON data countryCode")
                    }

                    if let id = subJson["id"].string {
                        newCountry.id = id
                    }else{
                        print("unable to read JSON data id")
                    }

                    if let country_icon = subJson["country_icon"].string {
                        newCountry.iconUrl = country_icon
                    }else{
                        print("unable to read JSON data country_icon")
                    }

                    if let total = subJson["total"].string {
                        newCountry.totalArtist = Int(total)
                    }else{
                        print("unable to read JSON data total")
                    }

                    if let country_name = subJson["country_name"].string {
                        newCountry.name = country_name
                    }else{
                        print("unable to read JSON data country_name")
                    }

                    if let continent = subJson["continent"].string {
                        newCountry.continent = continent
                    }else{
                        print("unable to read JSON data continent")
                    }
                } // End of For-Loop JSON data

                dispatch_async(dispatch_get_main_queue()) {
                    do {
                        try self.managedContext.save()
                    } catch let error as NSError {
                        print("Could not save: \(error)")
                    }

                    self.getCountryCoreData()
                    self.countryTableView.reloadData()

                    self.hud.hideProgressBar()
                    self.view.userInteractionEnabled = true
                }

            }
            else{ //Unable to read JSON data from Alamofire
                print("Unable to read JSON data from Alamofire")
            }

        }// End of Alamofire
        
    }

    func getCountryCoreData() {
        let fetchRequest = NSFetchRequest(entityName: "Country")

        do  {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            countryObject = results as! [NSManagedObject]

        }
        catch let fetchError as NSError {
            print("Fetch access in AppDelegate error: \(fetchError.localizedDescription)")
        }
    }

}
