//
//  AppDelegate.swift
//  <%= appName %>
//
//  Created by Pablo Apellidos on 8/6/18.
//  Copyright © 2018 Pablo Apellidos. All rights reserved.
//

import UIKit
import GoogleSignIn
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    var window: UIWindow?

    var usersCore: JhiUsers?

    var googleLoginDelegate: GoogleLoginProtocol?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        usersCore = JhiUsers(api:JhiUsersApi(baseUrl:"http://localhost:8080"), keepLogin: true)
        let signin =  GIDSignIn.sharedInstance()

        signin?.clientID = "YOUR_GOOGLE_CLIENT_ID"
        signin?.serverClientID = "YOUR_GOOGLE_SERVER_CLIENT_ID"

        signin?.shouldFetchBasicProfile = true;
        signin?.delegate = self

        FBSDKApplicationDelegate.sharedInstance().application( application, didFinishLaunchingWithOptions: launchOptions)

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            googleLoginDelegate?.googleLoginDidError(message: error.localizedDescription)
        } else if let idToken = user.serverAuthCode {
            usersCore?.loginWithGoogle(token:idToken, completion: googleLoginDidEnd)
        } else {
            if(user?.authentication?.idToken != nil){
                signIn.signOut()
                googleLoginDelegate?.googleLoginDidError(message: "unknown")
            }
            return
        }
    }
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        googleLoginDelegate?.googleLoginDidError(message: error.localizedDescription)
    }
    func googleLoginDidEnd(success:Bool,message:String){
        if(success){
            googleLoginDelegate?.googleLoginDidSuccess()
        }
        else{
            googleLoginDelegate?.googleLoginDidError(message: "Server error")
        }
    }
}
func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any])
    -> Bool {
        var handled = GIDSignIn.sharedInstance().handle(url,
                                                    sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                    annotation: [:])
        if(!handled){
            handled = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, options: options)
        }
        return handled
}

protocol GoogleLoginProtocol {
    func googleLoginDidSuccess()
    func googleLoginDidError(message:String)

}


