//
//  LoginViewController.swift
//  PerfectPath
//
//  Created by Odell Mizrahi on 2/28/17.
//  Copyright © 2017 PerfectPath. All rights reserved.
//

import UIKit
import Firebase
import Material

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var firstnameTextField: UITextField!
    @IBOutlet weak var lastnameTextField: UITextField!
    @IBOutlet weak var phonenumberTextField: UITextField!
    
    fileprivate var menuButton: IconButton!
    fileprivate var starButton: IconButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        //prepareMenuButton()
        //prepareStarButton()
        prepareNavigationItem()
    }
    
    @IBAction func didTapLoginButton(_ sender: Any) {
        handleEmailPasswordLogin()
    }
    
    @IBAction func didTapSignupButton(_ sender: Any) {
        handleEmailPasswordSignUp()
    }

    
    func loginCompletionCallback(user: FIRUser?, error: NSError?) {
        if error == nil
        {
            self.appDelegate.handleLogin()
        }
        else
        {
            let alertController = UIAlertController(title: "Login failed", message: error?.localizedDescription, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func handleEmailPasswordSignUp() {
        FIRAuth.auth()?.createUser(withEmail: emailTextField.text!,
                                   password: passwordTextField.text!,
                                   completion: { (user, err) in
                                    if let error = err
                                    {
                                        let alertController = UIAlertController(title: "Login Failed", message: error.localizedDescription, preferredStyle: .alert)
                                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                                        alertController.addAction(okAction)
                                        self.present(alertController, animated: true, completion: nil)
                                    }
                                    else
                                    {
                                        var profileRef: FIRDatabaseReference!
                                        let firebaseRef = FIRDatabase.database().reference()
                                        profileRef = firebaseRef.child("profiles").child(user!.uid)
                                        
                                        profileRef.child("firstname").setValue(self.firstnameTextField.text!)
                                        profileRef.child("lastname").setValue(self.lastnameTextField.text!)
                                        profileRef.child("phonenumber").setValue(self.phonenumberTextField.text!)
                                        self.appDelegate.handleLogin()
                                    }
                                    
        })
    }
    
    func handleEmailPasswordLogin() {
        FIRAuth.auth()?.signIn(withEmail: emailTextField.text!,
                               password: passwordTextField.text!,
                               completion: { (user, err) in
                                if let error = err
                                {
                                    let alertController = UIAlertController(title: "Login Failed", message: error.localizedDescription, preferredStyle: .alert)
                                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                                    alertController.addAction(okAction)
                                    self.present(alertController, animated: true, completion: nil)
                                }
                                else
                                {
                                    print("WORKED")
                                    self.appDelegate.handleLogin()
                                }
        })
    }

}

extension LoginViewController {
    fileprivate func prepareMenuButton() {
        menuButton = IconButton(image: Icon.cm.menu)
    }
    
    fileprivate func prepareStarButton() {
        starButton = IconButton(image: Icon.cm.star)
    }
    
    fileprivate func prepareNavigationItem() {
        navigationItem.title = "PerfectPath"
        navigationItem.detail = "Login"
    }
}
