//
//  Login2ViewController.swift
//  PerfectPath
//
//  Created by Odell Mizrahi on 4/2/17.
//  Copyright © 2017 PerfectPath. All rights reserved.
//
import UIKit
import Material
import Firebase

struct ButtonLayout {
    struct Flat {
        static let width: CGFloat = 120
        static let height: CGFloat = 44
        static let offsetY: CGFloat = -150
    }
    
    struct Raised {
        static let width: CGFloat = 150
        static let height: CGFloat = 44
        static let offsetY: CGFloat = -75
    }
    
    struct Fab {
        static let diameter: CGFloat = 48
    }
    
    struct Icon {
        static let width: CGFloat = 120
        static let height: CGFloat = 48
        static let offsetY: CGFloat = 75
    }
}

class LoginViewController: UIViewController {
    fileprivate var card: ImageCard!
    fileprivate var fabButton: FABButton!
    fileprivate var loginButton: RaisedButton!
    fileprivate var registerButton: FlatButton!
    fileprivate var imageView: UIImageView!
    fileprivate var emailField: TextField!
    fileprivate var passwordField: TextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.grey.lighten5
        
        prepareImageView()
        prepareEmailField()
        preparePasswordField()
        prepareLoginButton()
        prepareRegisterButton()
        prepareFABButton()
        preparePresenterCard()
        prepareLayout()
    }
}

extension LoginViewController {
    fileprivate func prepareImageView() {
        imageView = UIImageView()
        imageView.image = UIImage(named: "icon")?.resize(toWidth: view.width)
    }
    
    fileprivate func prepareRegisterButton() {
        registerButton = FlatButton(title: "Register Here")
        registerButton.pulseColor = .yellow
        registerButton.addTarget(self, action: #selector(handleNextButton), for: .touchUpInside)
    }
    
    fileprivate func prepareEmailField() {
        emailField = TextField()
        emailField.placeholder = "Email"
        emailField.isClearIconButtonEnabled = true
    }
    
    fileprivate func preparePasswordField() {
        passwordField = TextField()
        passwordField.placeholder = "Password"
        passwordField.clearButtonMode = .whileEditing
        passwordField.isVisibilityIconButtonEnabled = true
        passwordField.visibilityIconButton?.tintColor = Color.green.base.withAlphaComponent(passwordField.isSecureTextEntry ? 0.38 : 0.54)
    }
    
    fileprivate func prepareLoginButton() {
        loginButton = RaisedButton(title: "Login")
        loginButton.pulseColor = .yellow
        loginButton.addTarget(self, action: #selector(handleLoginButton), for: .touchUpInside)
    }
    
    fileprivate func prepareFABButton() {
        fabButton = FABButton(image: Icon.cm.photoCamera)
        fabButton.addTarget(self, action: #selector(handleNextButton), for: .touchUpInside)
        //view.layout(fabButton).width(64).height(64).bottom(24).right(24)
    }
    
    fileprivate func preparePresenterCard() {
        card = ImageCard()
        
        card.imageView = imageView
        
        //view.layout(loginButton).width(150).height(44).center(offsetY: 120).left(20)
        //view.layout(registerButton).width(150).height(44).center(offsetY: 120).right(20)
        //view.layout(fabButton).width(64).height(64).bottom(24).right(24)
        //view.layout(passwordField).center(offsetY: 60).left(20).right(20)
        //view.layout(emailField).center(offsetY: 0).left(20).right(20)
        //view.layout(card).center(offsetY: -160).left(20).right(20)
    }
    
    fileprivate func prepareLayout() {
        view.layout(loginButton).width(150).height(44).center(offsetY: 120).left(20)
        view.layout(registerButton).width(150).height(44).center(offsetY: 120).right(20)
        view.layout(passwordField).center(offsetY: 60).left(20).right(20)
        view.layout(emailField).center(offsetY: 0).left(20).right(20)
        view.layout(card).center(offsetY: -160).left(20).right(20)
    }
}

extension LoginViewController {
    @objc
    fileprivate func handleNextButton() {
        navigationController?.pushViewController(RegisterViewController(), animated: true)
    }
    
    @objc
    fileprivate func handleLoginButton() {
        FIRAuth.auth()?.signIn(withEmail: emailField.text!,
                               password: passwordField.text!,
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
                                    self.appDelegate.handleLogin()
                                }
        })
    }
}
