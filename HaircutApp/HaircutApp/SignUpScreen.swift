//
//  SignUpScreen.swift
//  HaircutApp
//
//  Created by CheckoutUser on 3/1/18.
//  Copyright © 2018 CheckoutUser. All rights reserved.
///Users/checkoutuser/Desktop/HaircutApp/HaircutApp/Base.lproj/Main.storyboard

import UIKit
import Firebase
import FirebaseDatabase

class SignUpScreen: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var databaseRef : DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.userNameField.delegate = self
        self.emailField.delegate = self
        self.passwordField.delegate = self
        
        databaseRef = Database.database().reference()

        // Do any additional setup after loading the view.
    }

    @IBAction func signInButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "unwindToLogin", sender: self)
    }
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        if self.userNameField.text == "" || self.emailField.text == "" || self.passwordField.text == "" {
            let alertController = UIAlertController(title: "Oops!", message: "Please enter a username, email, and password.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)

            self.present(alertController, animated: true, completion: nil)
        }
        else {
            Auth.auth().createUser(withEmail: self.emailField.text!, password: self.passwordField.text!) { (user, error) in
                if error == nil {
                    self.emailField.text = ""
                    self.passwordField.text = ""
                    self.performSegue(withIdentifier: "unwindToLogin", sender: self)
                }
                else {
                    let alertController = UIAlertController(title: "Oops!", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userNameField.resignFirstResponder()
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        return true
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
