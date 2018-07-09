import Foundation
import UIKit
class BaseViewController: UIViewController {
    func getJhiUsers() -> JhiUsers {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.usersCore!
    }

    func alert(title: String, message: String){
        alert(title:title, message:message, callback:dummy)
    }

    func alert(title: String, message: String, callback: @escaping ()->Void){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                callback()
            case .cancel:
                print("cancel")
                callback()
            case .destructive:
                print("destructive")
                callback()
            }}))
        self.present(alert, animated: true, completion: nil)
    }

    private func dummy(){
        //Do nothing
    }

    func goBack(){
        navigationController?.popViewController(animated: true)
    }


}
