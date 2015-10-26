//
//  CommentViewController+UITableViewDataSource.swift
//  Selklik-Fans
//
//  Created by Jamal N. Ahmad on 26/10/2015.
//  Copyright © 2015 Selklik. All rights reserved.
//


import Foundation

extension CommentViewController:UITableViewDataSource {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentObject.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let comment = commentObject[indexPath.row]

        //Download image profile using AlamofireImage
        let profileImageUrlString = comment.valueForKey("profileImageUrl") as? String
        let profileImageUrl = NSURL(string: profileImageUrlString!)


        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifiers.commentCell, forIndexPath:indexPath) as! CommentCell


        cell.name.text = comment.valueForKey("name") as? String
        cell.profilePhoto.af_setImageWithURL(profileImageUrl!)
        cell.commentLabel.text = comment.valueForKey("comment") as? String

        cell.dateTimeLabel.text = String(comment.valueForKey("timeStamp") as! NSDate)
        return cell
    }
}
