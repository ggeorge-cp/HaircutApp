//
//  CreateHaircutSessionScreen.swift
//  HaircutApp
//
//  Created by CheckoutUser on 3/2/18.
//  Copyright © 2018 CheckoutUser. All rights reserved.
//

import UIKit

class CreateHaircutSessionScreen: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // Segues
    @IBAction func backToHomeScreen(_ sender: UIButton) {
        performSegue(withIdentifier: "unwindToHome", sender: self)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
