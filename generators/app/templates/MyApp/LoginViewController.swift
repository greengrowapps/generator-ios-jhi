//
//  ViewController.swift
//  <%= appName %>
//
//  Created by Pablo Apellidos on 8/6/18.
//  Copyright © 2018 Pablo Apellidos. All rights reserved.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit
import FBSDKCoreKit

class LoginViewController: BaseViewController, GIDSignInUIDelegate, GoogleLoginProtocol, FBSDKLoginButtonDelegate {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    @IBOutlet weak var loginWithGoogle: GIDSignInButton!

    @IBOutlet weak var facebookLoginButton: FBSDKLoginButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let users = getJhiUsers()

        usernameTextField.text = "user"
        passwordTextField.text = "user"

        GIDSignIn.sharedInstance().uiDelegate = self

        facebookLoginButton.delegate = self

        if let accessToken = FBSDKAccessToken.current() {
            users.loginWithFacebook(token: accessToken.tokenString, completion: loginDidEnd)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let users = getJhiUsers()
        if(users.isLogedIn()){
            toMainViewController(animated: false)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.googleLoginDelegate = self
    }
    override func viewDidDisappear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.googleLoginDelegate = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginClick(_ sender: Any) {
        let email = usernameTextField.text
        let password = passwordTextField.text

        getJhiUsers().login(email: (email ?? ""), password: (password ?? ""), completion: loginDidEnd)
    }
    func loginDidEnd(success: Bool, message: String) -> Void {
        if( success ) {
            toMainViewController(animated: true)
        }
        else{
            alert(title: "Error", message: message)
        }
    }

    func googleLoginDidSuccess() {
        loginDidEnd(success: true, message: "")
    }
    func googleLoginDidError(message: String) {
        loginDidEnd(success: false, message: message)
    }
    func toMainViewController( animated:Bool){
        guard var viewControllers = navigationController?.viewControllers else { return }

        // Pop sourceViewController
        viewControllers.popLast()

        guard let mainViewController = storyboard?.instantiateViewController(withIdentifier: "Main") else { return }
        // Push targetViewController
        viewControllers.append(mainViewController)
        navigationController?.setViewControllers(viewControllers, animated: animated)
    }
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        guard let token = result?.token?.tokenString else { return }
         getJhiUsers().loginWithFacebook(token: token, completion: loginDidEnd)
    }
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        //Ignore
    }
}

