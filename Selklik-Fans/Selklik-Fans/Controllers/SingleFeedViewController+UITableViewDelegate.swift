//
//  SingleFeedViewController+UITableViewDelegate.swift
//  Selklik-Fans
//
//  Created by Jamal N. Ahmad on 23/10/2015.
//  Copyright © 2015 Selklik. All rights reserved.
//

import Foundation

extension SingleFeedViewController:UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }



    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "SingleFeedToViewPhoto") {
            let viewPhotoViewController = segue.destinationViewController as! ViewPhotoViewController
            viewPhotoViewController.ImageUrl =  selectedImageUrl
        }
        
    }
}