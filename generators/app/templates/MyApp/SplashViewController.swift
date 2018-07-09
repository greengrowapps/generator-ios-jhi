import Foundation
import UIKit
import FBSDKCoreKit
import GoogleSignIn

class SplashViewController : BaseViewController, GoogleLoginProtocol{

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let jhiUsers = getJhiUsers()

        if( jhiUsers.isLoginSaved() ) {
            jhiUsers.autoLogin(completion: loginDidEnd)
        }
        else if(jhiUsers.isFacebookLoginSaved()){
            if let accessToken = FBSDKAccessToken.current() {
                jhiUsers.loginWithFacebook(token: accessToken.tokenString, completion: loginDidEnd)
            } else {
                toLoginViewController()
            }
        }
        else if(jhiUsers.isGoogleLoginSaved()){

            let signin =  GIDSignIn.sharedInstance()

            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.googleLoginDelegate = self

            signin?.signInSilently()
        }
        else{
            toLoginViewController()
        }
    }

    func toLoginViewController(){
        performSegue(withIdentifier: "start", sender: nil)
    }

    func loginDidEnd(success: Bool, message: String) -> Void {
        toLoginViewController()
    }
    func googleLoginDidSuccess() {
        toLoginViewController()
    }
    func googleLoginDidError(message:String){
        toLoginViewController()
    }
}
