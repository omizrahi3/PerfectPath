//
//  RegisterViewController.swift
//  PerfectPath
//
//  Created by Odell Mizrahi on 4/6/17.
//  Copyright © 2017 PerfectPath. All rights reserved.
//

import UIKit
import Material
import Firebase

class RegisterViewController: UIViewController {
    fileprivate var registerButton: RaisedButton!
    fileprivate var emailTextField: TextField!
    fileprivate var passwordTextField: TextField!
    fileprivate var firstnameTextField: TextField!
    fileprivate var lastnameTextField: TextField!
    fileprivate var phonenumberTextField: TextField!
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.grey.lighten5
        
        prepareNavigationItem()
        prepareEmailField()
        preparePasswordField()
        prepareFNField()
        prepareLNField()
        preparePNField()
        prepareRegisterButton()
        prepareLayout()
    }
}

extension RegisterViewController {
    fileprivate func prepareEmailField() {
        emailTextField = TextField()
        emailTextField.placeholder = "Email"
        emailTextField.isClearIconButtonEnabled = true
    }
    
    fileprivate func preparePasswordField() {
        passwordTextField = TextField()
        passwordTextField.placeholder = "Password"
        passwordTextField.clearButtonMode = .whileEditing
        passwordTextField.isVisibilityIconButtonEnabled = true
        passwordTextField.visibilityIconButton?.tintColor = Color.green.base.withAlphaComponent(passwordTextField.isSecureTextEntry ? 0.38 : 0.54)
    }
    
    fileprivate func prepareFNField() {
        firstnameTextField = TextField()
        firstnameTextField.placeholder = "First Name"
        firstnameTextField.isClearIconButtonEnabled = true
    }
    
    fileprivate func prepareLNField() {
        lastnameTextField = TextField()
        lastnameTextField.placeholder = "Last Name"
        lastnameTextField.isClearIconButtonEnabled = true
    }
    
    fileprivate func preparePNField() {
        phonenumberTextField = TextField()
        phonenumberTextField.placeholder = "Phone Number"
        phonenumberTextField.isClearIconButtonEnabled = true
    }
    
    fileprivate func prepareRegisterButton() {
        registerButton = RaisedButton(title: "Register")
        registerButton.pulseColor = .yellow
        registerButton.addTarget(self, action: #selector(handleEmailPasswordSignUp), for: .touchUpInside)
    }


    
    fileprivate func prepareLayout() {
        view.layout(registerButton).width(150).height(44).center(offsetY: 120).left(20)
        view.layout(phonenumberTextField).center(offsetY: 40).left(20).right(20)
        view.layout(lastnameTextField).center(offsetY: -20).left(20).right(20)
        view.layout(firstnameTextField).center(offsetY: -80).left(20).right(20)
        view.layout(passwordTextField).center(offsetY: -140).left(20).right(20)
        view.layout(emailTextField).center(offsetY: -200).left(20).right(20)
    }
}

extension RegisterViewController {
    fileprivate func prepareNavigationItem() {
        navigationItem.title = "Perfect Path"
        navigationItem.detail = "Register"
    }
    
    @objc
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
}
