import Foundation
import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn

class MainViewController: BaseViewController {

    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var oldPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let usersCore = appDelegate.usersCore
        usersCore?.loadUser(completion: userDidLoad)
    }
    func userDidLoad( user: JhiUserDto? ) {
        userTextField.text = user?.login ?? "error"
    }
    @IBAction func onChangePassword(_ sender: Any) {
        getJhiUsers().changePassword(password: newPasswordTextField.text ?? "", completion: onChangePasswordSuccess)

    }
    func onChangePasswordSuccess(success: Bool){
        if(success){
            alert(title: "Success", message: "Password changed")
        }
        else{
            alert(title: "Error", message: "Password not changed")
        }
    }
     @IBAction func bClick(_ sender: Any) {
            //let viewController = MyEntityList(nibName: "MyEntityList", bundle: nil)

        /*    // Present
            self.present(viewController, animated: true) {

            }
     */

            //push
         //   self.navigationController?.pushViewController(viewController, animated: true)
        }
    @IBAction func logout(_ sender: Any) {
        let users = getJhiUsers();
        if(users.isFacebookLoginSaved()){
            FBSDKLoginManager().logOut()
        }
        if(users.isGoogleLoginSaved()){
            GIDSignIn.sharedInstance().signOut()
        }


        users.logout()

        guard var viewControllers = navigationController?.viewControllers else { return }

        // Pop sourceViewController
        viewControllers.popLast()

        guard let mainViewController = storyboard?.instantiateViewController(withIdentifier: "Login") else { return }
        // Push targetViewController
        viewControllers.append(mainViewController)
        navigationController?.setViewControllers(viewControllers, animated: false)
    }
}
