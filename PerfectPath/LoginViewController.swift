//
//  LoginViewController.swift
//  PerfectPath
//
//  Created by Odell Mizrahi on 2/28/17.
//  Copyright © 2017 PerfectPath. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapLoginButton(_ sender: Any) {
        handleEmailPasswordLogin()
    }
    
    @IBAction func didTapSignupButton(_ sender: Any) {
        handleEmailPasswordSignUp()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
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
                                        print("WORKED")
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
