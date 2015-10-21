//
//  FeedViewController+UITableViewDelegate .swift
//  Selklik-Fans
//
//  Created by Jamal N. Ahmad on 20/10/2015.
//  Copyright © 2015 Selklik. All rights reserved.
//

import Foundation

extension FeedViewController:UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
}



    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "FeedToViewPhoto") {
            let viewPhotoViewController = segue.destinationViewController as! ViewPhotoViewController
            viewPhotoViewController.ImageUrl =  selectedImageUrl
        }

    }
}

