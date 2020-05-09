//
//  RegisterViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    //display registration errors to user
    @IBOutlet weak var errorLabel: UILabel!
    
    //make error display empty initially
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.text = ""
    }
    
    
    @IBAction func registerPressed(_ sender: UIButton) {
        
        /*
        let email = emailTextfield.text
        let password = passwordTextfield.text
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
        }
        */
        if let email = emailTextfield.text, let password = passwordTextfield.text {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error { //optionally bind error to variable
                    print(e.localizedDescription)   //message user understands, in local language
                    //display registration errors to user
                    self.errorLabel.text = e.localizedDescription
                } else {    //user authenticated successfully
                    //navigate to the ChatViewController
                    //self.performSegue(withIdentifier: "RegisterToChat", sender: self)
                    self.performSegue(withIdentifier: K.registerSegue, sender: self)
                }
            }
        }
    }
    
}
