//
//  ArtistViewController+.swift
//  Selklik-Fans
//
//  Created by Jamal N. Ahmad on 16/10/2015.
//  Copyright © 2015 Selklik. All rights reserved.
//

import Foundation

extension ArtistViewController:UITableViewDataSource {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "mycell")

        cell.textLabel!.text = "unknown artist list cell"//socialMediaType! + " - " + postType!

        return cell
    }
}