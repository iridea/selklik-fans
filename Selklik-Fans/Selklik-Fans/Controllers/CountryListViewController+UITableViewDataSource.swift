//
//  CountryListViewController+.swift
//  Selklik-Fans
//
//  Created by Jamal N. Ahmad on 19/10/2015.
//  Copyright © 2015 Selklik. All rights reserved.
//

import Foundation

extension CountryListViewController:UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countryObject.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let country = countryObject[indexPath.row]

        //Download image profile using AlamofireImage
        let countryIconUrlString = country.valueForKey("iconUrl") as? String
        let countryIconUrl = NSURL(string: countryIconUrlString!)


        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifiers.countryCell, forIndexPath:indexPath) as! CountryCell


        cell.flagImageView.image = nil
        cell.flagImageView.af_setImageWithURL(countryIconUrl!)
        cell.countryNameLabel.text = country.valueForKey("name") as? String
        let totalArtist = country.valueForKey("totalArtist") as! Int
        var astistText = " artist"
        if totalArtist > 1 {
            astistText += "s"
        }
        cell.totalArtistLabel.text = String(totalArtist) + astistText

//        let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "mycell")
//
//        cell.textLabel!.text = "Unknow cell format"

        return cell
    }
}