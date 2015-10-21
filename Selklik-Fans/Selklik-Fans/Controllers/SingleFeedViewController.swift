//
//  SingleFeedViewController.swift
//  Selklik-Fans
//
//  Created by Jamal N. Ahmad on 21/10/2015.
//  Copyright © 2015 Selklik. All rights reserved.
//

import UIKit

class SingleFeedViewController: UIViewController {

    @IBOutlet weak var header: UIView!
    @IBOutlet weak var artistImage: UIImageView!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var facebookIcon: UIImageView!
    @IBOutlet weak var twitterIcon: UIImageView!
    @IBOutlet weak var instagramIcon: UIImageView!
    @IBOutlet weak var feedTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
