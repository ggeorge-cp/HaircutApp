//
//  ProfileScreen.swift
//  HaircutApp
//
//  Created by CheckoutUser on 3/2/18.
//  Copyright © 2018 CheckoutUser. All rights reserved.
//

import UIKit

class ProfileScreen: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func toSettings(_ sender: UIButton) {
        performSegue(withIdentifier: "toSettings", sender: self)
    }
    
    /*
     https://medium.com/@felicity.johnson.mail/firebase-user-sign-up-login-data-management-992d778b167
     */
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
