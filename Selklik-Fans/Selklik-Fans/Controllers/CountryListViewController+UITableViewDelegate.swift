//
//  extension CountryListViewController+UITableViewDelegate.swift
//  Selklik-Fans
//
//  Created by Jamal N. Ahmad on 19/10/2015.
//  Copyright © 2015 Selklik. All rights reserved.
//

import Foundation

extension CountryListViewController:UITableViewDelegate {

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let country = countryObject[indexPath.row]

        if let code = country.valueForKey("code") as? String {
            print(code)
            selectedCountryCode = code
            performSegueWithIdentifier("ContryListToArtistList", sender: self)
        }

    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "ContryListToArtistList") {
            let artistViewController = segue.destinationViewController as! ArtistViewController
            artistViewController.countryCode =  selectedCountryCode
        }
        
    }
}