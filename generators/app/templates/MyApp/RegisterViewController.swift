import Foundation
import UIKit

class RegisterViewController : BaseViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!

    @IBOutlet weak var firstNameValidationLabel: UILabel!
    @IBOutlet weak var emailValidationLabel: UILabel!
    @IBOutlet weak var lastNameValidationLabel: UILabel!
    @IBOutlet weak var passwordValidationLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

//        emailTextField.text="test@testers.com"
//        firstNameTextField.text="tester"
//        lastNameTextField.text="test"
//        passwordTextField.text="123456"
//        repeatPasswordTextField.text="123456"
    }

    @IBAction func onRegisterClick(_ sender: Any) {
        let email = emailTextField.text
        let firstName = firstNameTextField.text
        let lastName = lastNameTextField.text
        let password = passwordTextField.text
        let repeatPassword = repeatPasswordTextField.text

        if((password?.count ?? 0)<4){
            passwordValidationLabel.isHidden = false
            passwordValidationLabel.text = "Password is too weak"
        }
        else if(password != repeatPassword){
            passwordValidationLabel.isHidden = false
            passwordValidationLabel.text = "Passwords not match"
        }
        else{
            passwordValidationLabel.isHidden = true
        }

        firstNameValidationLabel.isHidden = (firstName?.count ?? 0)>0
        lastNameValidationLabel.isHidden = (lastName?.count ?? 0)>0
        emailValidationLabel.isHidden = isValidEmail(testStr: email ?? "")

        if( passwordValidationLabel.isHidden && firstNameValidationLabel.isHidden && lastNameValidationLabel.isHidden && emailValidationLabel.isHidden){
            getJhiUsers().register(email: email ?? "", firstName: firstName ?? "", lastName: lastName ?? "", password: password ?? "", langKey: "es", completion: onRegisterEnd)
        }
    }

    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }

    func onRegisterEnd(success: RegisterStatus) -> Void {

        switch success {
        case RegisterStatus.SUCCESS:
            alert(title: "Success", message: "We habe sent you an email to verify your account, please veify and log in", callback: goBack)
            break
        case RegisterStatus.ALREADY_EXISTS:
            alert(title: "Error", message: "already existing account")
            break
        default:
            alert(title: "Error", message: "Error while register")
            break
        }
    }
}
