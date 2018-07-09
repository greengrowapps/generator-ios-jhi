import Foundation
import UIKit

class RecoverPasswordViewController: BaseViewController {
    @IBOutlet weak var emailTextField: UITextField!

    @IBAction func onRecoverPasswordClick(_ sender: Any) {
        getJhiUsers().recoverPassword(email: emailTextField.text ?? "", completion: onRecoverPassword)
    }
    func onRecoverPassword(success: Bool) {
        if(success){
            alert(title: "Success", message: "We habe sent you an email with recover password instructions", callback: goBack)
        }
        else{
            alert(title: "Error", message: "Account not found")
        }
    }
}
