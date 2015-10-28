//
//  RegisterViewController.swift
//  Selklik-Fans
//
//  Created by Jamal N. Ahmad on 28/10/2015.
//  Copyright © 2015 Selklik. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    //MARK: - IBAction
    @IBAction func backButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func joinButton(sender: AnyObject) {
        //showRegisterSuccessfulMessage()
    }

    //MARK: Custom function


    /*
    func updateFollowStatus(followThisArtist:Bool){

        let headers = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]

        let parameters = [
            "token": userToken,
            "artist_id": artistId
        ]

        print("userToken: \(userToken)")
        print("artistId: \(artistId)")

        let APIUrl = API.url + API.version
        print("APIUrl: \(APIUrl)")
        var postUrl = APIUrl + "user_follow"

        if !followThisArtist {
            postUrl = APIUrl + "user_unfollow"
        }

        Alamofire.request(.POST, postUrl, headers: headers, parameters: parameters).responseJSON {
            response in

            if let jsonData = response.result.value {

                let json = JSON(jsonData)
                
                print(json)
            }
            
        }
        
    }*/

    //MARK: Default function
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
