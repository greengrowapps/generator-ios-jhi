//
//  RecoverPasswordViewController.swift
//  <%= appName %>
//
//  Created by Pablo Apellidos on 11/6/18.
//  Copyright © 2018 Pablo Apellidos. All rights reserved.
//

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
